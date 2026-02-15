import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final Object? details;

  const ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? username;
  final String? email;
  final List<String> roles;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.username,
    this.email,
    this.roles = const [],
  });

  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    final rolesRaw = map['roles'];
    final roles = <String>[];
    if (rolesRaw is List) {
      for (final r in rolesRaw) {
        if (r != null) roles.add(r.toString());
      }
    }

    final token = (map['accessToken'] ?? '').toString();
    if (token.isEmpty) {
      throw const ApiException('Missing access token in auth response');
    }

    return AuthTokens(
      accessToken: token,
      refreshToken: map['refreshToken']?.toString(),
      userId: map['userId']?.toString(),
      username: map['username']?.toString(),
      email: map['email']?.toString(),
      roles: roles,
    );
  }
}

abstract class TokenStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<String?> read(String key) async {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }
}

class InMemoryTokenStorage implements TokenStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    return _store[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }
}

class BackendApi {
  BackendApi({
    String? baseUrl,
    HttpClient? httpClient,
    TokenStorage? tokenStorage,
  })  : _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'AILYTIC_API_BASE_URL',
              defaultValue: 'http://allytic-labs-prod.eba-pukad2pd.us-east-1.elasticbeanstalk.com',
            ),
        _client = httpClient ??
            (HttpClient()
              ..connectionTimeout = const Duration(seconds: 20)
              ..idleTimeout = const Duration(seconds: 20)),
        _tokenStorage = tokenStorage ??
            const SecureTokenStorage(
              FlutterSecureStorage(
                aOptions: AndroidOptions(encryptedSharedPreferences: true),
                iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
              ),
            );

  static final BackendApi instance = BackendApi();

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  final String _baseUrl;
  final HttpClient _client;
  final TokenStorage _tokenStorage;

  bool _legacyMigrationDone = false;

  Uri _uri(String path, {Map<String, String>? query}) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: query);
  }

  Future<void> _migrateLegacyTokensIfNeeded() async {
    if (_legacyMigrationDone) return;

    final prefs = await SharedPreferences.getInstance();

    final accessInSecure = await _safeReadToken(_accessTokenKey);
    final refreshInSecure = await _safeReadToken(_refreshTokenKey);

    if (accessInSecure == null || accessInSecure.isEmpty) {
      final legacyAccess = prefs.getString(_accessTokenKey);
      if (legacyAccess != null && legacyAccess.isNotEmpty) {
        await _safeWriteToken(_accessTokenKey, legacyAccess);
      }
    }

    if (refreshInSecure == null || refreshInSecure.isEmpty) {
      final legacyRefresh = prefs.getString(_refreshTokenKey);
      if (legacyRefresh != null && legacyRefresh.isNotEmpty) {
        await _safeWriteToken(_refreshTokenKey, legacyRefresh);
      }
    }

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    _legacyMigrationDone = true;
  }

  Future<String?> _safeReadToken(String key) async {
    try {
      return await _tokenStorage.read(key);
    } on PlatformException {
      throw const ApiException('Secure storage is unavailable on this device');
    }
  }

  Future<void> _safeWriteToken(String key, String value) async {
    try {
      await _tokenStorage.write(key, value);
    } on PlatformException {
      throw const ApiException('Could not write secure authentication token');
    }
  }

  Future<void> _safeDeleteToken(String key) async {
    try {
      await _tokenStorage.delete(key);
    } on PlatformException {
      throw const ApiException('Could not clear secure authentication token');
    }
  }

  Future<Map<String, String>> _authHeaders({bool requiresAuth = false}) async {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    if (requiresAuth) {
      await _migrateLegacyTokensIfNeeded();
      final token = await _safeReadToken(_accessTokenKey);
      if (token == null || token.isEmpty) {
        throw const ApiException('Authentication required');
      }
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool requiresAuth = false,
    bool retryOn401 = true,
  }) async {
    final uri = _uri(path, query: query);
    final headers = await _authHeaders(requiresAuth: requiresAuth);

    Future<dynamic> doCall() async {
      final req = await _client.openUrl(method, uri).timeout(const Duration(seconds: 25));
      headers.forEach(req.headers.set);
      if (body != null) {
        req.add(utf8.encode(jsonEncode(body)));
      }

      final res = await req.close().timeout(const Duration(seconds: 30));
      final text = await utf8.decodeStream(res).timeout(const Duration(seconds: 30));
      final isJson = (res.headers.contentType?.mimeType ?? '').contains('json');

      dynamic decoded;
      if (text.isNotEmpty && isJson) {
        try {
          decoded = jsonDecode(text);
        } catch (_) {
          throw ApiException(
            'Invalid JSON response from server',
            statusCode: res.statusCode,
            details: text,
          );
        }
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return decoded;
      }

      if (res.statusCode == 401 && requiresAuth && retryOn401) {
        final refreshed = await refreshAccessToken();
        if (refreshed) {
          return _request(
            method,
            path,
            body: body,
            query: query,
            requiresAuth: requiresAuth,
            retryOn401: false,
          );
        }
      }

      final backendMsg = decoded is Map<String, dynamic>
          ? (decoded['message']?.toString() ?? decoded['error']?.toString())
          : null;
      throw ApiException(
        backendMsg ?? 'Request failed with status ${res.statusCode}',
        statusCode: res.statusCode,
        details: decoded ?? text,
      );
    }

    final isIdempotent = method == 'GET';
    final attempts = isIdempotent ? 3 : 1;
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        return await doCall();
      } on SocketException catch (e) {
        if (attempt >= attempts) {
          throw ApiException('Network error. Please check your connection.', details: e);
        }
      } on TimeoutException catch (e) {
        if (attempt >= attempts) {
          throw ApiException('Request timed out. Please try again.', details: e);
        }
      }
      await Future.delayed(Duration(milliseconds: 300 * attempt));
    }
  }

  Future<void> saveAuthTokens(AuthTokens tokens) async {
    await _safeWriteToken(_accessTokenKey, tokens.accessToken);
    if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
      await _safeWriteToken(_refreshTokenKey, tokens.refreshToken!);
    }

    final prefs = await SharedPreferences.getInstance();
    if (tokens.userId != null) await prefs.setString('userId', tokens.userId!);
    if (tokens.username != null) await prefs.setString('username', tokens.username!);
    if (tokens.email != null) await prefs.setString('userEmail', tokens.email!);

    await prefs.setString(
      'user',
      jsonEncode({
        'userId': tokens.userId,
        'username': tokens.username,
        'email': tokens.email,
        'roles': tokens.roles,
      }),
    );
  }

  Future<void> clearAuth() async {
    await _safeDeleteToken(_accessTokenKey);
    await _safeDeleteToken(_refreshTokenKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('userEmail');
    await prefs.remove('user');
  }

  Future<bool> refreshAccessToken() async {
    await _migrateLegacyTokensIfNeeded();
    final refresh = await _safeReadToken(_refreshTokenKey);
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final uri = _uri('/api/v1/auth/refresh');
      final req = await _client.postUrl(uri);
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $refresh');
      req.add(utf8.encode('{}'));
      final res = await req.close();
      final body = await utf8.decodeStream(res);
      if (res.statusCode < 200 || res.statusCode >= 300) return false;

      final data = jsonDecode(body);
      if (data is! Map<String, dynamic>) return false;
      final tokens = AuthTokens.fromMap({...data, 'refreshToken': data['refreshToken'] ?? refresh});
      await saveAuthTokens(tokens);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<AuthTokens> login({required String username, required String password}) async {
    final res = await _request(
      'POST',
      '/api/v1/auth/login',
      body: {
        'username': username,
        'password': password,
      },
      requiresAuth: false,
    );
    if (res is! Map<String, dynamic>) {
      throw const ApiException('Unexpected login response format');
    }
    final tokens = AuthTokens.fromMap(res);
    await saveAuthTokens(tokens);
    return tokens;
  }

  Future<AuthTokens> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await _request(
      'POST',
      '/api/v1/auth/register',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
      requiresAuth: false,
    );

    if (res is! Map<String, dynamic>) {
      throw const ApiException('Unexpected registration response format');
    }

    final tokens = AuthTokens.fromMap(res);
    await saveAuthTokens(tokens);
    return tokens;
  }

  Future<List<Map<String, dynamic>>> fetchRobots({String? type}) async {
    final data = await _request(
      'GET',
      '/api/robots',
      query: type == null ? null : {'type': type},
    );
    if (data is! List) return const [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchDrones({String? type}) async {
    final data = await _request(
      'GET',
      '/api/drones',
      query: type == null ? null : {'type': type},
    );
    if (data is! List) return const [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchSolarPanels({String? type}) async {
    final data = await _request(
      'GET',
      '/api/solar-panels',
      query: type == null ? null : {'type': type},
    );
    if (data is! List) return const [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> submitContact({
    required String firstName,
    String? lastName,
    required String email,
    required String helpType,
    String? message,
  }) async {
    final data = await _request(
      'POST',
      '/api/contact',
      body: {
        'firstName': firstName,
        'lastName': (lastName ?? '').trim(),
        'email': email,
        'helpType': helpType,
        'message': (message ?? '').trim(),
      },
    );
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> subscribeNewsletter({required String email}) async {
    final data = await _request(
      'POST',
      '/api/newsletter',
      body: {'email': email},
    );
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> createStripePayment(Map<String, dynamic> payload) async {
    final data = await _request(
      'POST',
      '/api/v1/payments/stripe/create-intent',
      body: payload,
      requiresAuth: true,
    );
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected stripe payment response');
    }
    return data;
  }

  Future<Map<String, dynamic>> createMpesaPayment(Map<String, dynamic> payload) async {
    final data = await _request(
      'POST',
      '/api/v1/payments/mpesa/stkpush',
      body: payload,
      requiresAuth: true,
    );
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected M-Pesa response');
    }
    return data;
  }

  Future<Map<String, dynamic>> createQrPayment(Map<String, dynamic> payload) async {
    final data = await _request(
      'POST',
      '/api/v1/payments/qr/generate',
      body: payload,
      requiresAuth: true,
    );
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Unexpected QR payment response');
    }
    return data;
  }
}
