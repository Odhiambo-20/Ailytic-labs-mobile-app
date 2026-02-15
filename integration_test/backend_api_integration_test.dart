import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tutorial/backend_api.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HttpServer server;
  late Uri baseUri;

  final stripeHitCount = <String, int>{};

  Future<Map<String, dynamic>> readJson(HttpRequest request) async {
    final body = await utf8.decodeStream(request);
    if (body.isEmpty) return <String, dynamic>{};
    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<void> writeJson(HttpResponse response,int statusCode,Object? body,) async {
  response.statusCode = statusCode;
  response.headers.contentType = ContentType.json;
  response.write(jsonEncode(body));
  await response.close();
}


  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    baseUri = Uri.parse('http://${server.address.host}:${server.port}');

    server.listen((request) async {
      final path = request.uri.path;
      final auth = request.headers.value(HttpHeaders.authorizationHeader) ?? '';

      if (path == '/api/v1/auth/login' && request.method == 'POST') {
        final body = await readJson(request);
        if ((body['username'] ?? '').toString().isEmpty || (body['password'] ?? '').toString().isEmpty) {
          return writeJson(request.response, 400, {'message': 'Missing credentials'});
        }

        return writeJson(request.response, 200, {
          'accessToken': 'access-token-1',
          'refreshToken': 'refresh-token-1',
          'userId': 'u-1',
          'username': body['username'],
          'email': body['username'],
          'roles': ['ROLE_USER'],
        });
      }

      if (path == '/api/v1/auth/register' && request.method == 'POST') {
        final body = await readJson(request);
        return writeJson(request.response, 200, {
          'accessToken': 'access-token-2',
          'refreshToken': 'refresh-token-2',
          'userId': 'u-2',
          'username': body['username'] ?? body['email'],
          'email': body['email'],
          'roles': ['ROLE_USER'],
        });
      }

      if (path == '/api/v1/auth/refresh' && request.method == 'POST') {
        if (auth != 'Bearer refresh-token-x') {
          return writeJson(request.response, 401, {'message': 'Invalid refresh'});
        }

        return writeJson(request.response, 200, {
          'accessToken': 'new-access-token',
          'refreshToken': 'refresh-token-x',
          'userId': 'u-refresh',
          'username': 'refresh_user',
          'email': 'refresh@example.com',
          'roles': ['ROLE_USER'],
        });
      }

      if (path == '/api/robots' && request.method == 'GET') {
        return writeJson(request.response, 200, [
          {
            'id': 'r-1',
            'name': 'SafeTest 3000',
            'type': 'Food Testing',
            'description': 'Robot description',
            'capabilities': ['A', 'B'],
            'image': 'https://example.com/robot.jpg',
            'price': '\$100',
            'rating': 4.7,
            'reviews': 20,
          }
        ]);
      }

      if (path == '/api/drones' && request.method == 'GET') {
        return writeJson(request.response, 200, [
          {
            'id': 11,
            'name': 'Drone X',
            'type': 'Survey',
            'description': 'Drone description',
            'specifications': ['4K', 'GPS'],
            'image': 'https://example.com/drone.jpg',
            'price': '\$250',
            'rating': 4.5,
            'reviews': 12,
          }
        ]);
      }

      if (path == '/api/solar-panels' && request.method == 'GET') {
        return writeJson(request.response, 200, [
          {
            'id': 's-1',
            'name': 'SunCore',
            'type': 'Residential',
            'description': 'Panel description',
            'image': 'https://example.com/panel.jpg',
            'power': '450W',
            'efficiency': '22%',
            'price': '\$450',
            'rating': 4.8,
            'reviews': 32,
          }
        ]);
      }

      if (path == '/api/contact' && request.method == 'POST') {
        final body = await readJson(request);
        if ((body['email'] ?? '').toString().isEmpty) {
          return writeJson(request.response, 400, {'message': 'Email required'});
        }

        return writeJson(request.response, 201, {'status': 'ok'});
      }

      if (path == '/api/v1/payments/stripe/create-intent' && request.method == 'POST') {
        const key = 'stripe';
        stripeHitCount[key] = (stripeHitCount[key] ?? 0) + 1;

        if (auth == 'Bearer stale-access-token') {
          return writeJson(request.response, 401, {'message': 'Token expired'});
        }
        if (auth != 'Bearer access-token-1' && auth != 'Bearer new-access-token') {
          return writeJson(request.response, 401, {'message': 'Unauthorized'});
        }

        return writeJson(request.response, 200, {
          'paymentId': 'pay-stripe-1',
          'status': 'PENDING',
        });
      }

      if (path == '/api/v1/payments/mpesa/stkpush' && request.method == 'POST') {
        if (auth != 'Bearer access-token-1' && auth != 'Bearer new-access-token') {
          return writeJson(request.response, 401, {'message': 'Unauthorized'});
        }
        return writeJson(request.response, 200, {
          'checkoutRequestId': 'mpesa-1',
          'status': 'PENDING',
        });
      }

      return writeJson(request.response, 404, {'message': 'Not found'});
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    stripeHitCount.clear();
  });

  testWidgets('login and register persist auth data', (_) async {
    final tokenStorage = InMemoryTokenStorage();
    final api = BackendApi(baseUrl: baseUri.toString(), tokenStorage: tokenStorage);

    final login = await api.login(username: 'user@example.com', password: 'password123');
    expect(login.accessToken, 'access-token-1');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('userId'), 'u-1');
    expect(await tokenStorage.read('accessToken'), 'access-token-1');

    final register = await api.register(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'password123',
      confirmPassword: 'password123',
    );

    expect(register.accessToken, 'access-token-2');
    expect(await tokenStorage.read('refreshToken'), 'refresh-token-2');
  });

  testWidgets('fetch catalog endpoints', (_) async {
    final api = BackendApi(baseUrl: baseUri.toString(), tokenStorage: InMemoryTokenStorage());

    final robots = await api.fetchRobots();
    final drones = await api.fetchDrones();
    final panels = await api.fetchSolarPanels();

    expect(robots, isNotEmpty);
    expect(drones, isNotEmpty);
    expect(panels, isNotEmpty);
  });

  testWidgets('submit contact', (_) async {
    final api = BackendApi(baseUrl: baseUri.toString(), tokenStorage: InMemoryTokenStorage());

    final response = await api.submitContact(
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane@example.com',
      helpType: 'Product Information',
      message: 'Need details',
    );

    expect(response['status'], 'ok');
  });

  testWidgets('authorized stripe and mpesa payments', (_) async {
    final tokenStorage = InMemoryTokenStorage();
    final api = BackendApi(baseUrl: baseUri.toString(), tokenStorage: tokenStorage);

    await api.login(username: 'buyer@example.com', password: 'password123');

    final stripe = await api.createStripePayment({
      'userId': 'u-1',
      'amount': 100.0,
      'currency': 'USD',
      'paymentMethod': 'STRIPE',
      'idempotencyKey': 'idem-1',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    expect(stripe['paymentId'], 'pay-stripe-1');

    final mpesa = await api.createMpesaPayment({
      'userId': 'u-1',
      'amount': 1200.0,
      'currency': 'KES',
      'paymentMethod': 'MPESA',
      'phoneNumber': '254712345678',
      'idempotencyKey': 'idem-2',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    expect(mpesa['checkoutRequestId'], 'mpesa-1');
  });

  testWidgets('refresh token flow retries protected request on 401', (_) async {
    final tokenStorage = InMemoryTokenStorage();
    await tokenStorage.write('accessToken', 'stale-access-token');
    await tokenStorage.write('refreshToken', 'refresh-token-x');

    final api = BackendApi(baseUrl: baseUri.toString(), tokenStorage: tokenStorage);

    final result = await api.createStripePayment({
      'userId': 'u-refresh',
      'amount': 55.0,
      'currency': 'USD',
      'paymentMethod': 'STRIPE',
      'idempotencyKey': 'idem-3',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    expect(result['paymentId'], 'pay-stripe-1');
    expect(await tokenStorage.read('accessToken'), 'new-access-token');
    expect(stripeHitCount['stripe'], greaterThanOrEqualTo(2));
  });
}
