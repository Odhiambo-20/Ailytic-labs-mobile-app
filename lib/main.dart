import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

void main() {
  runApp(const AilyticLabsApp());
}

class AilyticLabsApp extends StatelessWidget {
  const AilyticLabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ailytic Labs',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1023),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6BFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/robots': (context) => const RobotsPage(),
        '/drones': (context) => const DronesPage(),
        '/solarpanels': (context) => const SolarPanelsPage(),
        '/products': (context) => const PlaceholderPage(title: 'Products'),
        '/robots/catalog': (context) => const RobotsCatalogPage(),
        '/solutions': (context) => const PlaceholderPage(title: 'Solutions'),
        '/research': (context) => const PlaceholderPage(title: 'Research'),
        '/about': (context) => const AboutPage(),
        '/careers': (context) => const CareersPage(),
        '/news': (context) => const NewsPage(),
        '/contact': (context) => const ContactPage(),
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/privacy': (context) => const PlaceholderPage(title: 'Privacy & Legal'),
        '/support': (context) => const PlaceholderPage(title: 'Support'),
        '/partners': (context) => const PlaceholderPage(title: 'Partners'),
        '/demo': (context) => const DemoPage(),
        '/order': (context) => const OrderPage(),
        '/latest-models': (context) => const LatestModelsPage(),
       
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeSection = 0;
  int currentGalleryIndex = 0;
  Timer? _heroTimer;

  final List<HeroSectionData> heroSections = const [
    HeroSectionData(
      title: 'Advanced Robotics Solutions',
      subtitle: 'Transforming industries with intelligent automation',
      cta: 'Explore Robots',
      link: '/robots',
      demoType: 'robot',
      gradientA: Color(0xFF2D6BFF),
      gradientB: Color(0xFF8B2CFF),
      backgroundAsset: 'assets/drone.jpg',
    ),
    HeroSectionData(
      title: 'Professional Drone Services',
      subtitle: 'Aerial innovation across all sectors of the economy',
      cta: 'Explore Drones',
      link: '/drones',
      demoType: 'drone',
      gradientA: Color(0xFF10B981),
      gradientB: Color(0xFF0D9488),
      backgroundAsset: 'assets/professional drone.jpg',
    ),
    HeroSectionData(
      title: 'Solar Energy Systems',
      subtitle: 'Sustainable power solutions for a cleaner future',
      cta: 'Explore Solar',
      link: '/solarpanels',
      demoType: 'solar',
      gradientA: Color(0xFFF97316),
      gradientB: Color(0xFFDC2626),
      backgroundAsset: 'assets/roof-top solar.jpg',
    ),
  ];

  final List<InnovationData> innovations = const [
    InnovationData(
      title: 'Advanced Robotics',
      description:
          'Precision automation with AI-powered intelligence for manufacturing and logistics.',
      stats: ['25+ payload capacity', '99.9% uptime', 'Real-time analytics'],
      link: '/robots',
      accent: Color(0xFF2D6BFF),
      backgroundAsset: 'assets/DJI Mavic 4 Pro Drone Combo.png',
    ),
    InnovationData(
      title: 'Professional Drones',
      description:
          'Enterprise-grade aerial solutions with autonomous capabilities.',
      stats: ['8K camera system', '120-min flight time', 'Autonomous mapping'],
      link: '/drones',
      accent: Color(0xFF10B981),
      backgroundAsset: 'assets/professional drone.jpg',
    ),
  ];

  final List<GalleryData> galleryItems = const [
    GalleryData(
      title: 'Professional Drones',
      description:
          'Experience unparalleled aerial precision with our enterprise-grade drones for surveying and autonomous operations.',
      link: '/drones',
      gradientA: Color(0xFF10B981),
      gradientB: Color(0xFF0D9488),
      backgroundAsset: 'assets/agricultural drone.jpg',
    ),
    GalleryData(
      title: 'Advanced Robotics',
      description:
          'Transform your operations with intelligent automation across manufacturing, logistics, and industrial workflows.',
      link: '/robots',
      gradientA: Color(0xFF2D6BFF),
      gradientB: Color(0xFF8B2CFF),
      backgroundAsset: 'assets/dji avata 2 fly more combo.jpg',
    ),
    GalleryData(
      title: 'Solar Energy Solutions',
      description:
          'Harness high-efficiency solar systems designed for long-term reliability and sustainability.',
      link: '/solarpanels',
      gradientA: Color(0xFFF97316),
      gradientB: Color(0xFFDC2626),
      backgroundAsset: 'assets/cutting-edge solar panels.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      setState(() {
        activeSection = (activeSection + 1) % heroSections.length;
      });
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    super.dispose();
  }

  void _go(String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  void _nextGallery() {
    setState(() {
      currentGalleryIndex = (currentGalleryIndex + 1) % galleryItems.length;
    });
  }

  void _prevGallery() {
    setState(() {
      currentGalleryIndex =
          (currentGalleryIndex - 1 + galleryItems.length) % galleryItems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeNavBar(
              isMobile: isMobile,
              onRoute: _go,
            ),
            _buildHeroSection(isMobile),
            _buildInnovationsSection(isMobile),
            _buildGallerySection(isMobile),
            _buildBottomCta(isMobile),
            HomeFooter(onRoute: _go),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    final hero = heroSections[activeSection];

    return SizedBox(
      height: isMobile ? 700 : 860,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _AssetBackground(assetPath: hero.backgroundAsset),
          Container(color: Colors.black.withOpacity(0.55)),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Text(
                    'The Future of Technology',
                    style: TextStyle(color: Color(0xFFBFDBFE), fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: Text(
                      hero.title,
                      key: ValueKey(hero.title),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 46 : 82,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                        color: const Color(0xFFE5EDFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    hero.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 34,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    GradientButton(
                      text: hero.cta,
                      a: hero.gradientA,
                      b: hero.gradientB,
                      onPressed: () => _go(hero.link),
                    ),
                    OutlinedButton(
                      onPressed: () => _go('/demo', arguments: hero.demoType),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Watch Demo'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    heroSections.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() => activeSection = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: activeSection == index ? 30 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: activeSection == index ? Colors.white : Colors.white38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: Colors.white70),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnovationsSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 20,
        vertical: 56,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111827), Color(0xFF0B1224)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Innovative Solutions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 40 : 64,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cutting-edge technology powering the next generation of automation and innovation',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 20),
          ),
          const SizedBox(height: 30),
          if (isMobile)
            Column(
              children: [
                InnovationCard(item: innovations[0], onTap: () => _go(innovations[0].link)),
                const SizedBox(height: 16),
                InnovationCard(item: innovations[1], onTap: () => _go(innovations[1].link)),
              ],
            )
          else
            Row(
              children: [
                Expanded(child: InnovationCard(item: innovations[0], onTap: () => _go(innovations[0].link))),
                const SizedBox(width: 14),
                Expanded(child: InnovationCard(item: innovations[1], onTap: () => _go(innovations[1].link))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(bool isMobile) {
    final item = galleryItems[currentGalleryIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F2937), Color(0xFF0B1224)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Trusted By Industry Leaders',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isMobile ? 38 : 64, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Explore our cutting-edge technology solutions',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 20),
          ),
          const SizedBox(height: 26),
          SizedBox(
            height: isMobile ? 520 : 620,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _AssetBackground(assetPath: item.backgroundAsset),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.85),
                                  Colors.black.withOpacity(0.45),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 860),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: isMobile ? 36 : 56,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        color: Color(0xFFE5E7EB),
                                        fontSize: 21,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 10,
                                      children: [
                                        GradientButton(
                                          text: 'Explore Now',
                                          a: item.gradientA,
                                          b: item.gradientB,
                                          onPressed: () => _go(item.link),
                                        ),
                                        OutlinedButton(
                                          onPressed: () => _go(item.link),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white54),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 22,
                                              vertical: 18,
                                            ),
                                          ),
                                          child: const Text('Learn More'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: CircleIconButton(
                      icon: Icons.chevron_left,
                      onTap: _prevGallery,
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: CircleIconButton(
                      icon: Icons.chevron_right,
                      onTap: _nextGallery,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              galleryItems.length,
              (i) => GestureDetector(
                onTap: () => setState(() => currentGalleryIndex = i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentGalleryIndex == i ? 34 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: currentGalleryIndex == i
                        ? const LinearGradient(colors: [Color(0xFF2D6BFF), Color(0xFF8B2CFF)])
                        : null,
                    color: currentGalleryIndex == i ? null : const Color(0xFF6B7280),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCta(bool isMobile) {
    return SizedBox(
      height: isMobile ? 540 : 760,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AssetBackground(assetPath: 'assets/solar panels.jpg'),
          Container(color: Colors.black.withOpacity(0.62)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ready to Transform Tomorrow?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 50 : 84,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE5EDFF),
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Join thousands of companies leveraging our technology to drive innovation and sustainability',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Color(0xFFE5E7EB)),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 8),
                  GradientButton(
                    text: 'Schedule Demo',
                    a: const Color(0xFF2D6BFF),
                    b: const Color(0xFF8B2CFF),
                    onPressed: () => _go('/contact'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeNavBar extends StatelessWidget {
  final bool isMobile;
  final void Function(String route, {Object? arguments}) onRoute;

  const HomeNavBar({
    super.key,
    required this.isMobile,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1734),
        border: Border(bottom: BorderSide(color: Color(0xFF1E2A44))),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Color(0xFFFAB387)),
          const SizedBox(width: 8),
          const Text(
            'AILYTIC LABS',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFFCD0AD)),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _TopLink(text: 'Home', onTap: () => onRoute('/')),
            _TopLink(text: 'Robots', onTap: () => onRoute('/robots')),
            _TopLink(text: 'Drones', onTap: () => onRoute('/drones')),
            _TopLink(text: 'Solarpanels', onTap: () => onRoute('/solarpanels')),
            const SizedBox(width: 8),
            GradientButton(
              text: 'Contact Us',
              a: const Color(0xFF2D6BFF),
              b: const Color(0xFF8B2CFF),
              compact: true,
              onPressed: () => onRoute('/contact'),
            ),
          ] else
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) => onRoute(value),
              itemBuilder: (context) => const [
                PopupMenuItem(value: '/', child: Text('Home')),
                PopupMenuItem(value: '/robots', child: Text('Robots')),
                PopupMenuItem(value: '/drones', child: Text('Drones')),
                PopupMenuItem(value: '/solarpanels', child: Text('Solarpanels')),
                PopupMenuItem(value: '/contact', child: Text('Contact Us')),
              ],
            ),
        ],
      ),
    );
  }
}

class HomeFooter extends StatelessWidget {
  final void Function(String route, {Object? arguments}) onRoute;

  const HomeFooter({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF030712),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          Wrap(
            spacing: 36,
            runSpacing: 24,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Color(0xFFFAB387)),
                        SizedBox(width: 8),
                        Text(
                          'Ailytic Labs',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Pioneering the future of robotics, drones, and renewable energy.',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                    ),
                  ],
                ),
              ),
              _FooterGroup(
                title: 'Solutions',
                links: const [
                  FooterLink(label: 'Robotics', route: '/robots'),
                  FooterLink(label: 'Drones', route: '/drones'),
                  FooterLink(label: 'Solar', route: '/solarpanels'),
                ],
                onRoute: onRoute,
              ),
              _FooterGroup(
                title: 'Company',
                links: const [
                  FooterLink(label: 'About', route: '/about'),
                  FooterLink(label: 'Careers', route: '/careers'),
                  FooterLink(label: 'News', route: '/news'),
                ],
                onRoute: onRoute,
              ),
              _FooterGroup(
                title: 'Connect',
                links: const [
                  FooterLink(label: 'Contact', route: '/contact'),
                  FooterLink(label: 'Support', route: '/support'),
                  FooterLink(label: 'Partners', route: '/partners'),
                ],
                onRoute: onRoute,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF1F2937)),
          const SizedBox(height: 8),
          const Text('© 2026 Ailytic Labs. All rights reserved.', style: TextStyle(color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}

class _FooterGroup extends StatelessWidget {
  final String title;
  final List<FooterLink> links;
  final void Function(String route, {Object? arguments}) onRoute;

  const _FooterGroup({
    required this.title,
    required this.links,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...links.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onRoute(link.route),
                child: Text(link.label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InnovationCard extends StatelessWidget {
  final InnovationData item;
  final VoidCallback onTap;

  const InnovationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.accent.withOpacity(0.65)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _AssetBackground(assetPath: item.backgroundAsset),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.86), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(item.description, style: const TextStyle(fontSize: 21, color: Color(0xFFE5E7EB))),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.stats
                      .map(
                        (stat) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(stat, style: const TextStyle(color: Color(0xFFD1D5DB))),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onTap,
                  iconAlignment: IconAlignment.end,
                  style: TextButton.styleFrom(foregroundColor: item.accent),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Learn More', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final Color a;
  final Color b;
  final VoidCallback onPressed;
  final bool compact;

  const GradientButton({
    super.key,
    required this.text,
    required this.a,
    required this.b,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [a, b]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        iconAlignment: IconAlignment.end,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 24,
            vertical: compact ? 10 : 18,
          ),
        ),
        icon: compact ? const SizedBox.shrink() : const Icon(Icons.arrow_forward),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class _TopLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _TopLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontSize: 17, color: Color(0xFFE5E7EB))),
    );
  }
}

class _AssetBackground extends StatelessWidget {
  final String assetPath;
  static Future<Set<String>>? _assetKeysFuture;

  const _AssetBackground({required this.assetPath});

  static Future<Set<String>> _loadAssetKeys() async {
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final map = jsonDecode(manifest) as Map<String, dynamic>;
    return map.keys.toSet();
  }

  bool _isImageAsset(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.png') ||
        p.endsWith('.jpg') ||
        p.endsWith('.jpeg') ||
        p.endsWith('.webp') ||
        p.endsWith('.avif') ||
        p.endsWith('.gif') ||
        p.endsWith('.bmp');
  }

  @override
  Widget build(BuildContext context) {
    _assetKeysFuture ??= _loadAssetKeys();

    return FutureBuilder<Set<String>>(
      future: _assetKeysFuture,
      builder: (context, snapshot) {
        final hasAsset = snapshot.data?.contains(assetPath) ?? false;
        final isImage = _isImageAsset(assetPath);

        if (hasAsset && isImage) {
          return Image.asset(assetPath, fit: BoxFit.cover);
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F2937), Color(0xFF0B1224)],
            ),
          ),
          child: hasAsset && !isImage
              ? const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 72,
                    color: Colors.white70,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class DronesPage extends StatefulWidget {
  const DronesPage({super.key});

  @override
  State<DronesPage> createState() => _DronesPageState();
}

class _DronesPageState extends State<DronesPage> {
  int currentGalleryIndex = 0;
  int? hoveredDroneId;
  bool loading = true;
  String? error;
  List<DroneData> droneApplications = [];

  final List<DroneHeroItem> galleryItems = const [
    DroneHeroItem(
      image: 'assets/delivery drone.jpg',
      title: 'Professional Delivery Drones',
      subtitle: 'Revolutionary cargo solutions for modern logistics',
      highlight: 'Transport',
    ),
    DroneHeroItem(
      image: 'assets/drone.jpg',
      title: 'Advanced Surveillance Systems',
      subtitle: 'Cutting-edge aerial security and monitoring',
      highlight: 'Security',
    ),
    DroneHeroItem(
      image: 'assets/agricultural drone.jpg',
      title: 'Precision Agriculture Drones',
      subtitle: 'Smart farming with AI-powered crop analysis',
      highlight: 'Agriculture',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDrones();
  }

  Future<void> _fetchDrones() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      droneApplications = const [
        DroneData(
          id: 1,
          name: 'SkyGuard Pro',
          application: 'Surveillance',
          type: 'Security',
          description:
              'Advanced surveillance drone with 4K thermal imaging and 8-hour flight time',
          image:
              'https://images.pexels.com/photos/442587/pexels-photo-442587.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: '4K Camera | Thermal Imaging | 8hr Battery',
          price: '\$15,000',
          rating: 4.8,
          reviews: 124,
        ),
        DroneData(
          id: 2,
          name: 'CargoMax 500',
          application: 'Transport',
          type: 'Delivery',
          description:
              'Heavy-lift cargo drone with 50kg payload capacity and autonomous navigation',
          image:
              'https://images.pexels.com/photos/8566473/pexels-photo-8566473.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: '50kg Payload | GPS Navigation | Weather Resistant',
          price: '\$25,000',
          rating: 4.9,
          reviews: 89,
        ),
        DroneData(
          id: 3,
          name: 'AgriScan X1',
          application: 'Agriculture',
          type: 'Farming',
          description:
              'Precision agriculture drone with multispectral imaging for crop health monitoring',
          image:
              'https://images.pexels.com/photos/1034650/pexels-photo-1034650.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: 'Multispectral | AI Analysis | Crop Mapping',
          price: '\$18,000',
          rating: 4.7,
          reviews: 156,
        ),
        DroneData(
          id: 4,
          name: 'MapMaster Pro',
          application: 'Mapping',
          type: 'Survey',
          description:
              'High-precision mapping drone with LiDAR and photogrammetry capabilities',
          image:
              'https://images.pexels.com/photos/2246476/pexels-photo-2246476.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: 'LiDAR | 3D Mapping | RTK GPS',
          price: '\$22,000',
          rating: 4.8,
          reviews: 73,
        ),
        DroneData(
          id: 5,
          name: 'CineAir 8K',
          application: 'Media',
          type: 'Cinematography',
          description:
              'Professional cinema drone with 8K video recording and gimbal stabilization',
          image:
              'https://images.pexels.com/photos/3945683/pexels-photo-3945683.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: '8K Video | 3-Axis Gimbal | RAW Recording',
          price: '\$12,000',
          rating: 4.9,
          reviews: 201,
        ),
        DroneData(
          id: 6,
          name: 'PartyFlyer LED',
          application: 'Entertainment',
          type: 'Events',
          description:
              'Light show drone for events with synchronized LED displays and formations',
          image:
              'https://images.pexels.com/photos/1730877/pexels-photo-1730877.jpeg?auto=compress&cs=tinysrgb&w=1200',
          features: 'LED Display | Swarm Control | Show Programming',
          price: '\$8,000',
          rating: 4.6,
          reviews: 94,
        ),
      ];
      setState(() => loading = false);
    } catch (_) {
      setState(() {
        loading = false;
        error = 'Failed to load drones. Please try again later.';
      });
    }
  }

  void _nextGalleryItem() {
    setState(() {
      currentGalleryIndex = (currentGalleryIndex + 1) % galleryItems.length;
    });
  }

  void _prevGalleryItem() {
    setState(() {
      currentGalleryIndex =
          (currentGalleryIndex - 1 + galleryItems.length) % galleryItems.length;
    });
  }

  void _handleOrderNow(DroneData drone) {
    Navigator.pushNamed(context, '/order', arguments: drone);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final currentHero = galleryItems[currentGalleryIndex];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0B1734),
                border: Border(bottom: BorderSide(color: Color(0xFF1E2A44))),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                    child: const Text('Ailytic Labs'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    child: const Text('Home'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/robots'),
                    child: const Text('Robots'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Drones'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/solarpanels'),
                    child: const Text('Solar'),
                  ),
                  const SizedBox(width: 8),
                  GradientButton(
                    text: 'Contact Us',
                    a: const Color(0xFF2563EB),
                    b: const Color(0xFF0891B2),
                    compact: true,
                    onPressed: () => Navigator.pushNamed(context, '/contact'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: isMobile ? 620 : 760,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _AssetBackground(assetPath: currentHero.image),
                  Container(color: Colors.black.withOpacity(0.5)),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(currentHero.highlight),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          currentHero.title,
                          style: TextStyle(
                            fontSize: isMobile ? 34 : 64,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentHero.subtitle,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 28,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            GradientButton(
                              text: 'Order Now',
                              a: const Color(0xFF2563EB),
                              b: const Color(0xFF0891B2),
                              onPressed: () => _handleOrderNow(
                                DroneData(
                                  id: 1000 + currentGalleryIndex,
                                  name: currentHero.title,
                                  application: currentHero.highlight,
                                  type: currentHero.highlight,
                                  description: currentHero.subtitle,
                                  image: '',
                                  features: 'Enterprise drone',
                                  price: '\$25,000',
                                  rating: 4.8,
                                  reviews: 0,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Text('Learn More'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: CircleIconButton(
                        icon: Icons.chevron_left,
                        onTap: _prevGalleryItem,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: CircleIconButton(
                        icon: Icons.chevron_right,
                        onTap: _nextGalleryItem,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        galleryItems.length,
                        (i) => GestureDetector(
                          onTap: () => setState(() => currentGalleryIndex = i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentGalleryIndex == i ? 30 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentGalleryIndex == i
                                  ? const Color(0xFF22D3EE)
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF111827), Color(0xFF0B1224)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Drone Solutions for Every Industry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 34 : 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover our professional drones for surveillance, transport, agriculture, mapping, media, and entertainment',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  if (loading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text('Loading drones from database...'),
                  ] else if (error != null) ...[
                    Text(error!, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _fetchDrones, child: const Text('Retry Loading')),
                  ] else if (droneApplications.isEmpty) ...[
                    const Text('No drones available at the moment.'),
                  ] else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: droneApplications.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : 3,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: isMobile ? 1.25 : 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final d = droneApplications[index];
                        return MouseRegion(
                          onEnter: (_) => setState(() => hoveredDroneId = index),
                          onExit: (_) => setState(() => hoveredDroneId = null),
                          child: _DroneCard(
                            drone: d,
                            hover: hoveredDroneId == index,
                            onOrder: () => _handleOrderNow(d),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            SizedBox(
              height: isMobile ? 520 : 700,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const _AssetBackground(assetPath: 'assets/drone.jpg'),
                  Container(color: Colors.black.withOpacity(0.62)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text('Next Generation Technology'),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Latest Innovations in Drone Technology',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 36 : 64,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Experience AI-powered autonomy, longer range, and industrial-grade reliability.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              GradientButton(
                                text: 'Explore Latest Models',
                                a: const Color(0xFF2563EB),
                                b: const Color(0xFF0891B2),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/latest-models'),
                              ),
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/demo', arguments: 'drone'),
                                child: const Text('Watch Technology Demo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HomeFooter(
              onRoute: (route, {arguments}) {
                Navigator.pushNamed(context, route, arguments: arguments);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DroneCard extends StatelessWidget {
  final DroneData drone;
  final bool hover;
  final VoidCallback onOrder;

  const _DroneCard({
    required this.drone,
    required this.hover,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: hover ? const Color(0xFF3B82F6) : const Color(0xFF374151)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            drone.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _AssetBackground(assetPath: 'assets/drone.jpg'),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.88), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drone.application, style: const TextStyle(color: Color(0xFF93C5FD))),
                const SizedBox(height: 6),
                Text(drone.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(drone.description, maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text(drone.features, style: const TextStyle(color: Color(0xFF67E8F9))),
                const SizedBox(height: 8),
                Text('${drone.price}  •  ★ ${drone.rating} (${drone.reviews})',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                FilledButton(onPressed: onOrder, child: const Text('Order Now')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DroneHeroItem {
  final String image;
  final String title;
  final String subtitle;
  final String highlight;

  const DroneHeroItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.highlight,
  });
}

class DroneData {
  final int id;
  final String name;
  final String application;
  final String type;
  final String description;
  final String image;
  final String features;
  final String price;
  final double rating;
  final int reviews;

  const DroneData({
    required this.id,
    required this.name,
    required this.application,
    required this.type,
    required this.description,
    required this.image,
    required this.features,
    required this.price,
    required this.rating,
    required this.reviews,
  });
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderProduct? _product;
  bool _orderConfirmed = false;
  bool _showMap = false;
  bool _isProcessing = false;
  String? _paymentError;
  String? _paymentId;

  final _formKey = GlobalKey<FormState>();

  final Map<String, double> _shippingCosts = const {
    'standard': 0,
    'express': 49.99,
    'overnight': 99.99,
  };

  final Map<String, String> _shippingLabels = const {
    'standard': 'Standard Shipping',
    'express': 'Express Shipping',
    'overnight': 'Overnight Shipping',
  };

  final Map<String, String> _paymentLabels = const {
    'stripe': 'Credit/Debit Card',
    'mpesa': 'M-Pesa',
  };

  String fullName = '';
  String email = '';
  String phone = '';
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String cardNumber = '';
  String cardName = '';
  String expiryDate = '';
  String cvv = '';
  String shippingMethod = 'standard';
  String paymentMethod = 'mpesa';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product ??= _extractProduct(ModalRoute.of(context)?.settings.arguments);
  }

  OrderProduct? _extractProduct(Object? args) {
    if (args == null) return null;

    if (args is DroneData) {
      return OrderProduct(
        id: args.id.toString(),
        name: args.name,
        type: args.type,
        description: args.description,
        image: args.image,
        price: args.price,
      );
    }

    if (args is Map) {
      final map = args.map((k, v) => MapEntry(k.toString(), v));
      return OrderProduct(
        id: (map['id'] ?? '0').toString(),
        name: (map['name'] ?? 'Product').toString(),
        type: (map['type'] ?? 'Drone').toString(),
        description: (map['description'] ?? 'No description').toString(),
        image: (map['image'] ?? '').toString(),
        price: (map['price'] ?? '\$0').toString(),
      );
    }

    return null;
  }

  String _formatCardNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'\D'), '');
    return digits.replaceAllMapped(RegExp(r'.{1,4}'), (m) => '${m.group(0)} ').trim();
  }

  String _formatExpiry(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 2) return digits;
    return '${digits.substring(0, 2)}/${digits.substring(2, digits.length.clamp(2, 4))}';
  }

  double _priceToDouble(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  Map<String, String> _calculateTotals() {
    final subtotal = _priceToDouble(_product?.price ?? '\$0');
    final shipping = _shippingCosts[shippingMethod] ?? 0;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return {
      'subtotal': subtotal.toStringAsFixed(2),
      'shipping': shipping.toStringAsFixed(2),
      'tax': tax.toStringAsFixed(2),
      'total': total.toStringAsFixed(2),
    };
  }

  Future<void> _handleSubmit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    setState(() {
      _isProcessing = true;
      _paymentError = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isProcessing = false;
        _orderConfirmed = true;
        _paymentId = 'PAY-${DateTime.now().millisecondsSinceEpoch}';
      });
    } catch (_) {
      setState(() {
        _isProcessing = false;
        _paymentError = 'Payment processing failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    final totals = _calculateTotals();
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 960;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              const Text('Loading order details...'),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/drones', (_) => false),
                child: const Text('Back To Drones'),
              ),
            ],
          ),
        ),
      );
    }

    if (_orderConfirmed) {
      return Scaffold(
        body: Center(
          child: Container(
            width: 520,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 70),
                const SizedBox(height: 12),
                const Text('Order Confirmed!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Your ${product.name} has been ordered successfully.'),
                const SizedBox(height: 12),
                if (_paymentId != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText('Payment ID: $_paymentId'),
                  ),
                const SizedBox(height: 16),
                const Text('Check your email for confirmation details.'),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/drones', (_) => false),
                  child: const Text('Back to Drones'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final mediaPane = _showMap
        ? _DeliveryMapView(
            address: '$address, $city, $state $zipCode',
            onBack: () => setState(() => _showMap = false),
          )
        : _OrderProductImage(imageUrl: product.image, title: product.name);

    final rightPanel = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(product.type, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(product.description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(product.price, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            if (_paymentError != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.6)),
                ),
                child: Text(_paymentError!, style: const TextStyle(color: Colors.redAccent)),
              ),
            const Divider(height: 28),
            const Text('Payment Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._paymentLabels.keys.map(
              (m) => RadioListTile<String>(
                value: m,
                groupValue: paymentMethod,
                onChanged: (v) => setState(() => paymentMethod = v ?? 'mpesa'),
                title: Text(_paymentLabels[m]!),
              ),
            ),
            const Divider(height: 28),
            const Text('Shipping Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._shippingLabels.keys.map(
              (s) => RadioListTile<String>(
                value: s,
                groupValue: shippingMethod,
                onChanged: (v) => setState(() => shippingMethod = v ?? 'standard'),
                title: Text(_shippingLabels[s]!),
                subtitle: Text(s == 'standard' ? '5-7 business days' : s == 'express' ? '2-3 business days' : 'Next business day'),
                secondary: Text(
                  (_shippingCosts[s] ?? 0) == 0 ? 'FREE' : '\$${_shippingCosts[s]!.toStringAsFixed(2)}',
                ),
              ),
            ),
            const Divider(height: 28),
            const Text('Shipping Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _InputField(label: 'Full Name', onSaved: (v) => fullName = v ?? '', validator: _required),
            _InputField(label: 'Email', keyboardType: TextInputType.emailAddress, onSaved: (v) => email = v ?? '', validator: _required),
            _InputField(label: 'Phone', keyboardType: TextInputType.phone, onSaved: (v) => phone = v ?? '', validator: _required),
            _InputField(label: 'Address', onSaved: (v) => address = v ?? '', validator: _required),
            Row(
              children: [
                Expanded(child: _InputField(label: 'City', onSaved: (v) => city = v ?? '', validator: _required)),
                const SizedBox(width: 8),
                Expanded(child: _InputField(label: 'State', onSaved: (v) => state = v ?? '', validator: _required)),
                const SizedBox(width: 8),
                Expanded(child: _InputField(label: 'ZIP Code', onSaved: (v) => zipCode = v ?? '', validator: _required)),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                _formKey.currentState?.save();
                if (address.isNotEmpty && city.isNotEmpty && state.isNotEmpty && zipCode.isNotEmpty) {
                  setState(() => _showMap = true);
                }
              },
              icon: const Icon(Icons.map),
              label: const Text('Show Delivery Location on Map'),
            ),
            const Divider(height: 28),
            if (paymentMethod == 'stripe') ...[
              const Text('Card Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _InputField(
                label: 'Card Number',
                keyboardType: TextInputType.number,
                onSaved: (v) => cardNumber = _formatCardNumber(v ?? ''),
                validator: _required,
              ),
              _InputField(label: 'Cardholder Name', onSaved: (v) => cardName = v ?? '', validator: _required),
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      label: 'Expiry (MM/YY)',
                      onSaved: (v) => expiryDate = _formatExpiry(v ?? ''),
                      validator: _required,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InputField(
                      label: 'CVV',
                      keyboardType: TextInputType.number,
                      onSaved: (v) => cvv = v ?? '',
                      validator: _required,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Your payment information is encrypted and secure.', style: TextStyle(color: Colors.white70)),
              const Divider(height: 28),
            ],
            if (paymentMethod == 'mpesa') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text(
                  'M-Pesa Payment: You will receive an STK push prompt on your phone after submitting.',
                ),
              ),
              const Divider(height: 28),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF374151)),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', '\$${totals['subtotal']}'),
                  _summaryRow('Shipping', '\$${totals['shipping']}'),
                  _summaryRow('Tax (8%)', '\$${totals['tax']}'),
                  const Divider(),
                  _summaryRow('Total', '\$${totals['total']}', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isProcessing ? null : _handleSubmit,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(paymentMethod == 'mpesa' ? Icons.smartphone : Icons.lock),
                label: Text(_isProcessing
                    ? 'Processing Payment...'
                    : paymentMethod == 'mpesa'
                        ? 'Send M-Pesa Prompt - \$${totals['total']}'
                        : 'Complete Order - \$${totals['total']}'),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: isMobile
          ? Column(
              children: [
                SizedBox(height: 300, child: mediaPane),
                Expanded(child: rightPanel),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: mediaPane),
                Expanded(flex: 2, child: rightPanel),
              ],
            ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const _InputField({
    required this.label,
    this.keyboardType,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _DeliveryMapView extends StatelessWidget {
  final String address;
  final VoidCallback onBack;

  const _DeliveryMapView({required this.address, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _AssetBackground(assetPath: 'assets/drone.jpg'),
        Container(color: Colors.black.withOpacity(0.45)),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(child: Text(address)),
                TextButton(onPressed: onBack, child: const Text('View Product')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderProductImage extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _OrderProductImage({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    final isHttp = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    return isHttp
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _AssetBackground(assetPath: 'assets/drone.jpg'),
          )
        : _AssetBackground(assetPath: imageUrl.isEmpty ? 'assets/drone.jpg' : imageUrl);
  }
}

class OrderProduct {
  final String id;
  final String name;
  final String type;
  final String description;
  final String image;
  final String price;

  const OrderProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.price,
  });
}

class LatestModelsPage extends StatefulWidget {
  const LatestModelsPage({super.key});

  @override
  State<LatestModelsPage> createState() => _LatestModelsPageState();
}

class _LatestModelsPageState extends State<LatestModelsPage> {
  bool loading = true;
  List<LatestModelItem> drones = [];

  final List<LatestModelItem> allDrones = const [
    LatestModelItem(
      id: 'drone-1',
      name: 'DJI Air 3S',
      tagline: 'AI-Powered Reconnaissance',
      description: 'Next-gen drone with advanced threat detection and 500km range',
      image: 'assets/DJI Air 3S.avif',
      timeline: 'Q2 2025',
      gradientA: Color(0xFF2563EB),
      gradientB: Color(0xFF0891B2),
    ),
    LatestModelItem(
      id: 'drone-2',
      name: 'DJI Avata 2 Fly More Combo',
      tagline: 'Heavy-Lift Cargo Master',
      description: 'Autonomous logistics drone with 500kg payload capacity',
      image: 'assets/dji avata 2 fly more combo.jpg',
      timeline: 'Q3 2025',
      gradientA: Color(0xFF16A34A),
      gradientB: Color(0xFF059669),
    ),
    LatestModelItem(
      id: 'drone-3',
      name: 'DJI Mavic 4 Pro Drone Combo',
      tagline: 'Precision Agriculture',
      description: 'Hyperspectral imaging for sustainable farming solutions',
      image: 'assets/DJI Mavic 4 Pro Drone Combo.png',
      timeline: 'Q2 2025',
      gradientA: Color(0xFF9333EA),
      gradientB: Color(0xFFDB2777),
    ),
    LatestModelItem(
      id: 'drone-4',
      name: 'Mavic 2',
      tagline: 'Professional Cinema',
      description: '8K HDR recording with advanced gimbal stabilization',
      image: 'assets/mavic 2.jpg',
      timeline: 'January 2025',
      gradientA: Color(0xFFEA580C),
      gradientB: Color(0xFFDC2626),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDrones();
  }

  Future<void> _loadDrones() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      drones = allDrones;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0F172A)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Latest Drone Models',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 42 : 66,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Discover cutting-edge drone technology designed to transform industries and push innovation forward.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
                    ),
                    const SizedBox(height: 22),
                    if (loading)
                      Column(
                        children: const [
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                          SizedBox(height: 10),
                          Text('Loading latest drone models...'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (!loading)
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: drones.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isMobile ? 1 : 1.14,
                  ),
                  itemBuilder: (context, index) {
                    final d = drones[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _AssetBackground(assetPath: d.image),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 6),
                                  Text(d.timeline),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [d.gradientA, d.gradientB]),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    d.tagline,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(d.name,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    )),
                                const SizedBox(height: 8),
                                Text(d.description, style: const TextStyle(color: Color(0xFFBFDBFE))),
                                const SizedBox(height: 10),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [d.gradientA, d.gradientB]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton.icon(
                                    onPressed: () {},
                                    iconAlignment: IconAlignment.end,
                                    icon: const Icon(Icons.chevron_right),
                                    label: const Text('Learn More', style: TextStyle(fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0x4D1E3A8A), Color(0x4D6D28D9)],
                ),
                border: Border(top: BorderSide(color: Color(0x33FFFFFF))),
              ),
              child: Column(
                children: [
                  Text(
                    'Stay Ahead of Innovation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 36 : 56, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Get updates on new launches, early access opportunities, and technology insights.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(color: Color(0x8093C5FD)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.08),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color(0x4DFFFFFF)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color(0x4DFFFFFF)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text('Subscribe', style: TextStyle(fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LatestModelItem {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String image;
  final String timeline;
  final Color gradientA;
  final Color gradientB;

  const LatestModelItem({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.image,
    required this.timeline,
    required this.gradientA,
    required this.gradientB,
  });
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool isMenuOpen = false;
  String activeDemo = 'robot';

  static const Map<String, DemoContent> demoContent = {
    'robot': DemoContent(
      title: 'Advanced Robotics Demo',
      subtitle: 'Experience precision automation with AI-powered intelligence',
      heroVideo: 'assets/robot.mp4',
      demoVideo: 'assets/advanced robotics.mp4',
      heroFallback: 'assets/drone.jpg',
    ),
    'drone': DemoContent(
      title: 'Professional Drone Demo',
      subtitle: 'Aerial innovation with autonomous capabilities',
      heroVideo: 'assets/robot1.mp4',
      demoVideo: 'assets/drone.mp4',
      heroFallback: 'assets/drone.jpg',
    ),
    'solar': DemoContent(
      title: 'Solar Energy Systems Demo',
      subtitle: 'Sustainable power solutions for a cleaner future',
      heroVideo: 'assets/solar panels.mp4',
      demoVideo: 'assets/solar energy.mp4',
      heroFallback: 'assets/solar panels.jpg',
    ),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && demoContent.containsKey(arg)) {
      activeDemo = arg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final currentDemo = demoContent[activeDemo] ?? demoContent['robot']!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNav(isMobile),
            _buildHero(currentDemo, isMobile),
            _buildLiveDemo(currentDemo, isMobile),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav(bool isMobile) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1734),
        border: Border(bottom: BorderSide(color: Color(0xFF1E2A44))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
            child: Row(
              children: const [
                Icon(Icons.bolt, color: Color(0xFF60A5FA)),
                SizedBox(width: 8),
                Text('Ailytic Labs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _TopLink(text: 'Home', onTap: () => Navigator.pushNamed(context, '/')),
            _TopLink(text: 'Robots', onTap: () => Navigator.pushNamed(context, '/robots')),
            _TopLink(text: 'Drones', onTap: () => Navigator.pushNamed(context, '/drones')),
            _TopLink(text: 'Solar', onTap: () => Navigator.pushNamed(context, '/solarpanels')),
            const SizedBox(width: 8),
            GradientButton(
              text: 'Contact Us',
              a: const Color(0xFF3B82F6),
              b: const Color(0xFF8B5CF6),
              compact: true,
              onPressed: () => Navigator.pushNamed(context, '/contact'),
            ),
          ] else
            IconButton(
              onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
              icon: Icon(isMenuOpen ? Icons.close : Icons.menu),
            ),
        ],
      ),
    );
  }

  Widget _buildHero(DemoContent currentDemo, bool isMobile) {
    return SizedBox(
      height: isMobile ? 600 : 800,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _AssetVideoPlayer(
            assetPath: currentDemo.heroVideo,
            fallbackAssetPath: currentDemo.heroFallback,
            showControls: false,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.72),
                  Colors.black.withOpacity(0.52),
                  const Color(0xFF111827),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentDemo.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 44 : 84,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentDemo.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 20 : 30, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDemo(DemoContent currentDemo, bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text(
            'Live Demonstration',
            style: TextStyle(fontSize: isMobile ? 40 : 58, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Watch our technology in action', style: TextStyle(color: Colors.white70, fontSize: 20)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: isMobile ? 280 : 520,
            child: _AssetVideoPlayer(
              assetPath: currentDemo.demoVideo,
              fallbackAssetPath: currentDemo.heroFallback,
              showControls: true,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    Widget link(String text, String route) => TextButton(
          onPressed: () => Navigator.pushNamed(context, route),
          child: Text(text),
        );

    return Container(
      width: double.infinity,
      color: const Color(0xFF030712),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 36,
            runSpacing: 18,
            children: [
              const SizedBox(
                width: 240,
                child: Text('Pioneering the future of robotics, drones, and renewable energy.'),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Solutions', style: TextStyle(fontWeight: FontWeight.w700)),
                link('Robotics', '/robots'),
                link('Drones', '/drones'),
                link('Solar', '/solarpanels'),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Company', style: TextStyle(fontWeight: FontWeight.w700)),
                link('About', '/about'),
                link('Careers', '/careers'),
                link('News', '/news'),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Connect', style: TextStyle(fontWeight: FontWeight.w700)),
                link('Contact', '/contact'),
                link('Support', '/support'),
                link('Partners', '/partners'),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1F2937)),
          const SizedBox(height: 8),
          const Text('© 2026 Ailytic Labs. All rights reserved.', style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}

class DemoContent {
  final String title;
  final String subtitle;
  final String heroVideo;
  final String demoVideo;
  final String heroFallback;

  const DemoContent({
    required this.title,
    required this.subtitle,
    required this.heroVideo,
    required this.demoVideo,
    required this.heroFallback,
  });
}

class _AssetVideoPlayer extends StatefulWidget {
  final String assetPath;
  final String fallbackAssetPath;
  final bool showControls;
  final BoxFit fit;

  const _AssetVideoPlayer({
    required this.assetPath,
    required this.fallbackAssetPath,
    this.showControls = false,
    this.fit = BoxFit.cover,
  });

  @override
  State<_AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<_AssetVideoPlayer> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant _AssetVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeController();
      _ready = false;
      _init();
    }
  }

  Future<void> _init() async {
    try {
      final c = VideoPlayerController.asset(widget.assetPath);
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _ready = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ready = false;
      });
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return _AssetBackground(assetPath: widget.fallbackAssetPath);
    }

    final video = FittedBox(
      fit: widget.fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );

    if (!widget.showControls) return video;

    return Stack(
      fit: StackFit.expand,
      children: [
        video,
        Positioned(
          bottom: 12,
          right: 12,
          child: IconButton(
            onPressed: () {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
              setState(() {});
            },
            icon: Icon(
              _controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 34,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class RobotsPage extends StatefulWidget {
  const RobotsPage({super.key});

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
  List<RobotItem> robots = [];
  bool loading = true;
  String? error;
  String selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _fetchRobots();
  }

  Future<void> _fetchRobots() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      robots = const [
        RobotItem(
          id: 'r1',
          name: 'SafeTest 3000',
          type: 'Food Testing',
          description:
              'Revolutionary food safety testing robot with 99.9% accuracy for contaminants and compliance.',
          image:
              'https://images.pexels.com/photos/2085832/pexels-photo-2085832.jpeg?auto=compress&cs=tinysrgb&w=800',
          capabilities: ['Food Safety', 'AI Detection', 'Compliance'],
          price: '\$78,000',
          rating: 4.9,
          reviews: 184,
        ),
        RobotItem(
          id: 'r2',
          name: 'AgroBot Pro X1',
          type: 'Agricultural',
          description:
              'Autonomous farming robot with precision planting, monitoring, and smart harvesting.',
          image:
              'https://images.pexels.com/photos/2085831/pexels-photo-2085831.jpeg?auto=compress&cs=tinysrgb&w=800',
          capabilities: ['Crop Mapping', 'Precision Planting', 'Autonomous'],
          price: '\$45,000',
          rating: 4.8,
          reviews: 122,
        ),
        RobotItem(
          id: 'r3',
          name: 'IndustrialArm MAX',
          type: 'Industrial',
          description:
              'High-precision industrial robotic arm for manufacturing and heavy-duty operations.',
          image:
              'https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=800',
          capabilities: ['24/7 Ops', 'Precision Assembly', 'Heavy Duty'],
          price: '\$125,000',
          rating: 4.9,
          reviews: 97,
        ),
        RobotItem(
          id: 'r4',
          name: 'CuraAssist M2',
          type: 'Medical',
          description:
              'Clinical assistant robot supporting diagnostics and patient workflow optimization.',
          image:
              'https://images.pexels.com/photos/8460157/pexels-photo-8460157.jpeg?auto=compress&cs=tinysrgb&w=800',
          capabilities: ['Patient Routing', 'Monitoring', 'Data Sync'],
          price: '\$96,000',
          rating: 4.7,
          reviews: 76,
        ),
        RobotItem(
          id: 'r5',
          name: 'LogistiBot R9',
          type: 'Logistics',
          description:
              'Warehouse robot with autonomous path planning for sorting and material movement.',
          image:
              'https://images.pexels.com/photos/8566473/pexels-photo-8566473.jpeg?auto=compress&cs=tinysrgb&w=800',
          capabilities: ['Path Planning', 'Load Transfer', 'Fleet Sync'],
          price: '\$69,000',
          rating: 4.8,
          reviews: 141,
        ),
      ];

      setState(() => loading = false);
    } catch (_) {
      setState(() {
        loading = false;
        error = 'Failed to load robots. Please try again later.';
      });
    }
  }

  void _handleOrderNow(RobotItem robot) {
    Navigator.pushNamed(context, '/order', arguments: {
      'id': robot.id,
      'name': robot.name,
      'type': robot.type,
      'description': robot.description,
      'image': robot.image,
      'price': robot.price,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 1000;
    final filteredRobots = selectedType == 'all'
        ? robots
        : robots.where((r) => r.type == selectedType).toList();
    final robotTypes = ['all', ...{...robots.map((r) => r.type)}];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(isMobile),
            _buildFeaturedVideos(isMobile),
            _buildCatalog(isMobile, robotTypes, filteredRobots),
            _buildReadySection(isMobile),
            _buildIndustrialSection(isMobile),
            HomeFooter(
              onRoute: (route, {arguments}) {
                Navigator.pushNamed(context, route, arguments: arguments);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isMobile) {
    return SizedBox(
      height: isMobile ? 700 : 860,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AssetVideoPlayer(
            assetPath: 'assets/Allytic.mp4',
            fallbackAssetPath: 'assets/drone.jpg',
            showControls: false,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.45)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Future Robotics',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 52 : 84,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Discover the next generation of intelligent robots designed to transform industries.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Color(0xFFBFDBFE)),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GradientButton(
                        text: 'Explore Robots',
                        a: const Color(0xFF2563EB),
                        b: const Color(0xFF7C3AED),
                        onPressed: () => Navigator.pushNamed(context, '/robots/catalog'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/demo', arguments: 'robot'),
                        child: const Text('Watch Demo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedVideos(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
      color: const Color(0xFF0B1224),
      child: isMobile
          ? Column(
              children: [
                _featuredCard(
                  title: 'Precision Food Safety Testing',
                  desc:
                      'AI-powered robot that ensures food quality and safety with 99.9% accuracy.',
                  videoAsset: 'assets/Food Testing Robot.webm',
                  fallbackAsset: 'assets/drone.jpg',
                  buttonA: const Color(0xFF2563EB),
                  buttonB: const Color(0xFF7C3AED),
                  orderItem: const RobotItem(
                    id: 'food-testing-1',
                    name: 'SafeTest 3000',
                    type: 'Food Testing',
                    description: 'Food safety testing robot with 99.9% accuracy.',
                    image:
                        'https://images.pexels.com/photos/2085832/pexels-photo-2085832.jpeg?auto=compress&cs=tinysrgb&w=800',
                    capabilities: ['Food Safety', 'AI Detection'],
                    price: '\$78,000',
                    rating: 4.9,
                    reviews: 184,
                  ),
                ),
                const SizedBox(height: 16),
                _featuredCard(
                  title: 'Smart Agricultural Innovation',
                  desc:
                      'Autonomous farming robot that boosts yields while reducing environmental impact.',
                  videoAsset: 'assets/Agricultural Robot.webm',
                  fallbackAsset: 'assets/agricultural drone.jpg',
                  buttonA: const Color(0xFF16A34A),
                  buttonB: const Color(0xFF0D9488),
                  orderItem: const RobotItem(
                    id: 'agricultural-1',
                    name: 'AgroBot Pro X1',
                    type: 'Agricultural',
                    description: 'Autonomous farming robot with precision planting and harvest.',
                    image:
                        'https://images.pexels.com/photos/2085831/pexels-photo-2085831.jpeg?auto=compress&cs=tinysrgb&w=800',
                    capabilities: ['Crop Mapping', 'Autonomous'],
                    price: '\$45,000',
                    rating: 4.8,
                    reviews: 122,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _featuredCard(
                    title: 'Precision Food Safety Testing',
                    desc:
                        'AI-powered robot that ensures food quality and safety with 99.9% accuracy.',
                    videoAsset: 'assets/Food Testing Robot.webm',
                    fallbackAsset: 'assets/drone.jpg',
                    buttonA: const Color(0xFF2563EB),
                    buttonB: const Color(0xFF7C3AED),
                    orderItem: const RobotItem(
                      id: 'food-testing-1',
                      name: 'SafeTest 3000',
                      type: 'Food Testing',
                      description: 'Food safety testing robot with 99.9% accuracy.',
                      image:
                          'https://images.pexels.com/photos/2085832/pexels-photo-2085832.jpeg?auto=compress&cs=tinysrgb&w=800',
                      capabilities: ['Food Safety', 'AI Detection'],
                      price: '\$78,000',
                      rating: 4.9,
                      reviews: 184,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _featuredCard(
                    title: 'Smart Agricultural Innovation',
                    desc:
                        'Autonomous farming robot that boosts yields while reducing environmental impact.',
                    videoAsset: 'assets/Agricultural Robot.webm',
                    fallbackAsset: 'assets/agricultural drone.jpg',
                    buttonA: const Color(0xFF16A34A),
                    buttonB: const Color(0xFF0D9488),
                    orderItem: const RobotItem(
                      id: 'agricultural-1',
                      name: 'AgroBot Pro X1',
                      type: 'Agricultural',
                      description: 'Autonomous farming robot with precision planting and harvest.',
                      image:
                          'https://images.pexels.com/photos/2085831/pexels-photo-2085831.jpeg?auto=compress&cs=tinysrgb&w=800',
                      capabilities: ['Crop Mapping', 'Autonomous'],
                      price: '\$45,000',
                      rating: 4.8,
                      reviews: 122,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _featuredCard({
    required String title,
    required String desc,
    required String videoAsset,
    required String fallbackAsset,
    required Color buttonA,
    required Color buttonB,
    required RobotItem orderItem,
  }) {
    return Container(
      height: 500,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _AssetVideoPlayer(
            assetPath: videoAsset,
            fallbackAssetPath: fallbackAsset,
            showControls: false,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.86), Colors.black.withOpacity(0.25)],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 18)),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [buttonA, buttonB]),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: TextButton.icon(
                    onPressed: () => _handleOrderNow(orderItem),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalog(bool isMobile, List<String> robotTypes, List<RobotItem> filteredRobots) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC0F172A), Color(0xCC1E3A8A)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Our Robot Collection',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isMobile ? 38 : 56, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore our complete lineup of intelligent robots powered by advanced AI.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: robotTypes
                .map(
                  (type) => ChoiceChip(
                    label: Text(type == 'all' ? 'All Robots' : type),
                    selected: selectedType == type,
                    onSelected: (_) => setState(() => selectedType = type),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          if (loading)
            Column(
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading robots from database...'),
              ],
            )
          else if (error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: _fetchRobots, child: const Text('Retry Loading')),
                ],
              ),
            )
          else if (filteredRobots.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x661E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x66475569)),
              ),
              child: Text(
                selectedType == 'all'
                    ? 'No robots available at the moment.'
                    : 'No $selectedType robots found.',
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredRobots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isMobile ? 1.25 : 0.8,
              ),
              itemBuilder: (context, i) {
                final r = filteredRobots[i];
                return _robotCatalogCard(r);
              },
            ),
        ],
      ),
    );
  }

  Widget _robotCatalogCard(RobotItem robot) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x553B82F6)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC1E293B), Color(0xCC1E3A8A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  robot.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _AssetBackground(assetPath: 'assets/drone.jpg'),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xE62196F3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(robot.type, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(robot.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(robot.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFBFDBFE))),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: robot.capabilities
                      .take(3)
                      .map((c) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0x553B82F6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(c, style: const TextStyle(fontSize: 11)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(robot.price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF60A5FA))),
                    const Spacer(),
                    Text('★ ${robot.rating.toStringAsFixed(1)} (${robot.reviews})'),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _handleOrderNow(robot),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadySection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0x4D1E3A8A), Color(0x4D7C3AED)],
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                _readyText(),
                const SizedBox(height: 14),
                _readyVideo(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _readyText()),
                const SizedBox(width: 16),
                Expanded(child: _readyVideo()),
              ],
            ),
    );
  }

  Widget _readyText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ready to Welcome the Future?', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Text(
          'Control cutting-edge robotics from your smartphone with real-time monitoring and intelligent automation.',
          style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            GradientButton(
              text: 'Get Started Today',
              a: const Color(0xFF2563EB),
              b: const Color(0xFF7C3AED),
              onPressed: () => Navigator.pushNamed(context, '/contact'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              child: const Text('Contact Sales'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _readyVideo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: const SizedBox(
        height: 500,
        child: _AssetVideoPlayer(
          assetPath: 'assets/Robotic Dog.mp4',
          fallbackAssetPath: 'assets/drone.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIndustrialSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0B1224),
      child: Container(
        height: isMobile ? 520 : 620,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _AssetVideoPlayer(
              assetPath: 'assets/Industrial Robot.webm',
              fallbackAssetPath: 'assets/drone.jpg',
              showControls: false,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.black.withOpacity(0.35)],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Industrial Excellence in Motion',
                    style: TextStyle(fontSize: isMobile ? 38 : 56, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Advanced industrial robotics for 24/7 productivity, precision assembly, and maximum efficiency.',
                    style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFDC2626)]),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _handleOrderNow(const RobotItem(
                        id: 'industrial-1',
                        name: 'IndustrialArm MAX',
                        type: 'Industrial',
                        description: 'High-precision industrial robotic arm for heavy-duty operations.',
                        image:
                            'https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=800',
                        capabilities: ['24/7 Ops', 'Precision Assembly'],
                        price: '\$125,000',
                        rating: 4.9,
                        reviews: 97,
                      )),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RobotItem {
  final String id;
  final String name;
  final String type;
  final String description;
  final String image;
  final List<String> capabilities;
  final String price;
  final double rating;
  final int reviews;

  const RobotItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.capabilities,
    required this.price,
    required this.rating,
    required this.reviews,
  });
}

class RobotsCatalogPage extends StatefulWidget {
  const RobotsCatalogPage({super.key});

  @override
  State<RobotsCatalogPage> createState() => _RobotsCatalogPageState();
}

class _RobotsCatalogPageState extends State<RobotsCatalogPage> {
  List<CatalogRobot> robots = [];
  bool loading = true;
  int currentIndex = 0;
  Timer? _slideTimer;

  @override
  void initState() {
    super.initState();
    _fetchRobots();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRobots() async {
    setState(() => loading = true);

    const mockRobots = [
      CatalogRobot(
        id: '1',
        name: 'AgroBot Pro X1',
        type: 'Agricultural',
        description:
            'Advanced autonomous farming robot with AI-powered crop monitoring, precision planting, and smart harvesting capabilities.',
        image:
            'https://images.pexels.com/photos/2085831/pexels-photo-2085831.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Autonomous Navigation', 'Crop Analysis', 'Precision Planting', 'Smart Harvesting'],
        price: '\$45,000',
        rating: 4.8,
        reviews: 124,
      ),
      CatalogRobot(
        id: '2',
        name: 'SafeTest 3000',
        type: 'Food Testing',
        description:
            'Revolutionary food safety testing robot with 99.9% accuracy in detecting contaminants and ensuring compliance.',
        image:
            'https://images.pexels.com/photos/2085832/pexels-photo-2085832.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Contaminant Detection', 'Nutritional Analysis', 'Quality Control', 'Compliance Reporting'],
        price: '\$78,000',
        rating: 4.9,
        reviews: 89,
      ),
      CatalogRobot(
        id: '3',
        name: 'IndustrialArm MAX',
        type: 'Industrial',
        description:
            'High-precision industrial robotic arm designed for manufacturing and heavy-duty operations.',
        image:
            'https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Precision Assembly', 'Heavy Lifting', 'Quality Inspection', 'Welding'],
        price: '\$125,000',
        rating: 4.7,
        reviews: 203,
      ),
      CatalogRobot(
        id: '4',
        name: 'RoboDog Alpha',
        type: 'Companion',
        description:
            'Advanced quadruped robot with AI-powered mobility and interaction for security and inspection.',
        image:
            'https://images.pexels.com/photos/8566473/pexels-photo-8566473.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Terrain Navigation', 'Object Recognition', 'Voice Commands', 'Security Patrol'],
        price: '\$32,000',
        rating: 4.6,
        reviews: 156,
      ),
      CatalogRobot(
        id: '5',
        name: 'MediBot Care+',
        type: 'Medical',
        description:
            'Healthcare assistance robot for patient monitoring and medication workflow support.',
        image:
            'https://images.pexels.com/photos/8460157/pexels-photo-8460157.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Patient Monitoring', 'Medication Delivery', 'Vital Tracking', 'Emergency Response'],
        price: '\$95,000',
        rating: 4.9,
        reviews: 78,
      ),
      CatalogRobot(
        id: '6',
        name: 'CleanBot Pro',
        type: 'Service',
        description:
            'Intelligent commercial cleaning robot with advanced navigation and multi-surface support.',
        image:
            'https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Auto Mapping', 'Multi-Surface Cleaning', 'Obstacle Avoidance', 'Schedule Management'],
        price: '\$18,500',
        rating: 4.5,
        reviews: 312,
      ),
      CatalogRobot(
        id: '7',
        name: 'LogisticsPro X500',
        type: 'Warehouse',
        description:
            'Automated warehouse robot for inventory management, picking, and transportation of goods.',
        image:
            'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Inventory Tracking', 'Automated Picking', 'Load Transport', 'Route Optimization'],
        price: '\$65,000',
        rating: 4.8,
        reviews: 145,
      ),
      CatalogRobot(
        id: '8',
        name: 'EduBot Scholar',
        type: 'Educational',
        description:
            'Interactive educational robot to teach coding and STEM through engaging AI-powered lessons.',
        image:
            'https://images.pexels.com/photos/8438979/pexels-photo-8438979.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Interactive Learning', 'Coding Tutorials', 'STEM Education', 'Progress Tracking'],
        price: '\$8,900',
        rating: 4.7,
        reviews: 567,
      ),
      CatalogRobot(
        id: '9',
        name: 'SecurityBot Guardian',
        type: 'Security',
        description:
            'Advanced security and surveillance robot with thermal imaging and autonomous patrol.',
        image:
            'https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=800',
        capabilities: ['Thermal Imaging', 'Facial Recognition', 'Autonomous Patrol', 'Alert System'],
        price: '\$52,000',
        rating: 4.6,
        reviews: 98,
      ),
    ];

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      robots = mockRobots;
      loading = false;
      currentIndex = 0;
    });

    _slideTimer?.cancel();
    _slideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || robots.isEmpty) return;
      setState(() {
        currentIndex = (currentIndex + 1) % robots.length;
      });
    });
  }

  void _goNext() {
    if (robots.isEmpty) return;
    setState(() => currentIndex = (currentIndex + 1) % robots.length);
  }

  void _goPrev() {
    if (robots.isEmpty) return;
    setState(() => currentIndex = (currentIndex - 1 + robots.length) % robots.length);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final currentRobot = robots.isNotEmpty ? robots[currentIndex] : null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0F172A)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Our Robot Collection',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 44 : 64, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Discover our complete lineup of intelligent robots powered by advanced AI and cutting-edge technology.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
                  ),
                ],
              ),
            ),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading our amazing robots...'),
                  ],
                ),
              )
            else if (currentRobot != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xCC1E293B), Color(0xCC1E3A8A)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: isMobile ? 520 : 700,
                          width: double.infinity,
                          child: Image.network(
                            currentRobot.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const _AssetBackground(assetPath: 'assets/drone.jpg'),
                          ),
                        ),
                        Container(
                          height: isMobile ? 520 : 700,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.35)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: CircleIconButton(icon: Icons.chevron_left, onTap: _goPrev),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: CircleIconButton(icon: Icons.chevron_right, onTap: _goNext),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xE62196F3),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(currentRobot.type),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('★ ${currentRobot.rating.toStringAsFixed(1)}'),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text('${currentIndex + 1} / ${robots.length}'),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentRobot.name,
                                style: TextStyle(
                                  fontSize: isMobile ? 34 : 60,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentRobot.description,
                                style: const TextStyle(fontSize: 20, color: Color(0xFFBFDBFE)),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: currentRobot.capabilities
                                    .take(4)
                                    .map(
                                      (c) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(999),
                                          border: Border.all(color: Colors.white24),
                                        ),
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  iconAlignment: IconAlignment.end,
                                  icon: const Icon(Icons.chevron_right),
                                  label: const Text('Learn More', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0x803B82F6), Color(0x807C3AED)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Need Help Choosing?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 34 : 48, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Our robotics experts are here to help you find the perfect robot for your needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GradientButton(
                        text: 'Contact Sales',
                        a: const Color(0xFF2563EB),
                        b: const Color(0xFF7C3AED),
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/demo', arguments: 'robot'),
                        child: const Text('Request a Demo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogRobot {
  final String id;
  final String name;
  final String type;
  final String description;
  final String image;
  final List<String> capabilities;
  final String price;
  final double rating;
  final int reviews;

  const CatalogRobot({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.capabilities,
    required this.price,
    required this.rating,
    required this.reviews,
  });
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String helpType = 'Product Information';
  String message = '';

  bool isSubmitting = false;
  String? submitStatus; // success | error
  String errorMessage = '';

  Future<void> _handleSubmit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    setState(() {
      isSubmitting = true;
      submitStatus = null;
      errorMessage = '';
    });

    try {
      // Simulated backend call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() {
        submitStatus = 'success';
        isSubmitting = false;
      });

      _formKey.currentState?.reset();
      firstName = '';
      lastName = '';
      email = '';
      helpType = 'Product Information';
      message = '';

      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) return;
        setState(() => submitStatus = null);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        submitStatus = 'error';
        isSubmitting = false;
        errorMessage =
            'Failed to send message. Please try again or contact us directly via email.';
      });
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 960;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(isMobile),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: isMobile
                      ? Column(
                          children: [
                            _buildFormCard(),
                            const SizedBox(height: 14),
                            _buildSidebar(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildFormCard()),
                            const SizedBox(width: 14),
                            Expanded(child: _buildSidebar()),
                          ],
                        ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1E293B)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Get in Touch',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isMobile ? 48 : 68, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'We would love to hear from you. Send us a message and we will respond as soon as possible.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            labelStyle: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            floatingLabelStyle: const TextStyle(
              color: Color(0xFF1D4ED8),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Color(0xFF0F172A)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send us a message',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Fill out the form and our team will get back to you within 24 hours.',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 16),
                ),
                const SizedBox(height: 14),
                if (submitStatus == 'success')
                  _statusBanner(
                    good: true,
                    title: 'Message sent successfully!',
                    body: 'Thank you for contacting us. We will get back to you within 24 hours.',
                  ),
                if (submitStatus == 'error')
                  _statusBanner(
                    good: false,
                    title: 'Failed to send message',
                    body: errorMessage,
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _ContactField(
                        label: 'First name *',
                        validator: _required,
                        onSaved: (v) => firstName = v ?? '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ContactField(
                        label: 'Last name',
                        onSaved: (v) => lastName = v ?? '',
                      ),
                    ),
                  ],
                ),
                _ContactField(
                  label: 'Email address *',
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                  onSaved: (v) => email = v ?? '',
                ),
                DropdownButtonFormField<String>(
                  value: helpType,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  dropdownColor: Colors.white,
                  iconEnabledColor: const Color(0xFF334155),
                  decoration: const InputDecoration(
                    labelText: 'How can we help you?',
                    labelStyle: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF1D4ED8),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Product Information',
                      child: Text('Product Information', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'Technical Support',
                      child: Text('Technical Support', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'Partnership Inquiry',
                      child: Text('Partnership Inquiry', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'Media Inquiry',
                      child: Text('Media Inquiry', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'Sales Inquiry',
                      child: Text('Sales Inquiry', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text('Other', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                  ],
                  onChanged: (v) => setState(() => helpType = v ?? 'Product Information'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 6,
                  maxLines: 6,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: Color(0xFF1D4ED8),
                  decoration: const InputDecoration(
                    labelText: 'Your message',
                    labelStyle: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF1D4ED8),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    hintText: 'Tell us more about your inquiry...',
                    hintStyle: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onSaved: (v) => message = v ?? '',
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: isSubmitting ? null : _handleSubmit,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(isSubmitting ? 'Sending...' : 'Send Message'),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Text(
                    'Note: We do not process job applications via this form. For career opportunities, email recruitment@ailyticslabs.com',
                    style: TextStyle(color: Color(0xFF1E3A8A)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBanner({required bool good, required String title, required String body}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: good ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: good ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(good ? Icons.check_circle : Icons.error, color: good ? const Color(0xFF16A34A) : const Color(0xFFDC2626)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: good ? const Color(0xFF166534) : const Color(0xFF991B1B))),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(color: good ? const Color(0xFF166534) : const Color(0xFF991B1B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: const DefaultTextStyle(
            style: TextStyle(color: Color(0xFF0F172A)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Info', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 14),
                _InfoRow(icon: Icons.mail, title: 'Email', body: 'info@ailyticslabs.com\nbusiness@ailyticslabs.com'),
                SizedBox(height: 10),
                _InfoRow(icon: Icons.phone, title: 'Phone', body: '+254 748 630 243'),
                SizedBox(height: 10),
                _InfoRow(icon: Icons.location_on, title: 'Address', body: 'P.O Box 00100\nNairobi\nKenya'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Business Hours', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _hours('Monday - Friday', '9:00 - 18:00'),
              _hours('Saturday', '10:00 - 16:00'),
              _hours('Sunday', 'Closed'),
              const SizedBox(height: 12),
              const Divider(color: Color(0x335B9BF8)),
              const SizedBox(height: 10),
              const Text('Follow us on social media', style: TextStyle(color: Color(0xFFBFDBFE))),
              const SizedBox(height: 8),
              const Row(
                children: [
                  _SocialIcon(
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.instagram.com/ailyticslabs',
                  ),
                  SizedBox(width: 8),
                  _SocialIcon(
                    icon: FontAwesomeIcons.github,
                    url: 'https://github.com/ailyticslabs',
                  ),
                  SizedBox(width: 8),
                  _SocialIcon(
                    icon: FontAwesomeIcons.youtube,
                    url: 'https://www.youtube.com/@ailyticslabs',
                  ),
                  SizedBox(width: 8),
                  _SocialIcon(
                    icon: FontAwesomeIcons.linkedinIn,
                    url: 'https://www.linkedin.com/company/ailyticslabs',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hours(String d, String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(d, style: const TextStyle(color: Color(0xFFBFDBFE))),
          const Spacer(),
          Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    Widget link(String t, String r) => TextButton(
          onPressed: () => Navigator.pushNamed(context, r),
          child: Text(t, style: const TextStyle(color: Color(0xFF94A3B8))),
        );

    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 260,
                child: Text('Pioneering the future of robotics, drones, and renewable energy.'),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Solutions', style: TextStyle(fontWeight: FontWeight.w700)),
                link('Robotics', '/robots'),
                link('Drones', '/drones'),
                link('Solar Panels', '/solarpanels'),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Applications', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Academic Research', style: TextStyle(color: Color(0xFF94A3B8))),
                Text('Agriculture', style: TextStyle(color: Color(0xFF94A3B8))),
                Text('Construction', style: TextStyle(color: Color(0xFF94A3B8))),
                Text('Industrial', style: TextStyle(color: Color(0xFF94A3B8))),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Company', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Our Story', style: TextStyle(color: Color(0xFF94A3B8))),
                const Text('Careers', style: TextStyle(color: Color(0xFF94A3B8))),
                const Text('Press', style: TextStyle(color: Color(0xFF94A3B8))),
                link('Contact Us', '/contact'),
              ]),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF1E293B)),
          const SizedBox(height: 8),
          const Text('© 2026 Ailytic Labs. All rights reserved', style: TextStyle(color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const _ContactField({
    required this.label,
    this.keyboardType,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: const Color(0xFF1D4ED8),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF1D4ED8),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoRow({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(body, style: const TextStyle(color: Color(0xFF475569))),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open social media link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: FaIcon(icon, size: 18)),
        ),
      ),
    );
  }
}

class SolarPanelsPage extends StatefulWidget {
  const SolarPanelsPage({super.key});

  @override
  State<SolarPanelsPage> createState() => _SolarPanelsPageState();
}

class _SolarPanelsPageState extends State<SolarPanelsPage> {
  int currentSlide = 0;
  List<SolarPanelItem> solarPanels = [];
  bool loading = true;
  String? error;
  String selectedType = 'all';
  Timer? _testimonialTimer;

  final List<TestimonialItem> testimonials = const [
    TestimonialItem(
      name: 'Sarah Johnson',
      company: 'Green Home Solutions',
      rating: 5,
      text:
          'Allytic Labs solar panels exceeded expectations. Efficiency is outstanding and monitoring is incredibly useful.',
      location: 'Nairobi, Kenya',
    ),
    TestimonialItem(
      name: 'Michael Chen',
      company: 'EcoTech Industries',
      rating: 5,
      text:
          'Our commercial installation reduced energy costs by 40%. Excellent ROI and reliable performance.',
      location: 'Lagos, Nigeria',
    ),
    TestimonialItem(
      name: 'Dr. Amara Okafor',
      company: 'Solar Research Institute',
      rating: 5,
      text:
          'The technology and innovation behind these panels is impressive. Perfect for our research facility.',
      location: 'Accra, Ghana',
    ),
  ];

  final List<SolarBenefitItem> benefits = const [
    SolarBenefitItem(
      icon: Icons.eco,
      title: 'Environmental Impact',
      description: 'Reduce carbon footprint by up to 80% with renewable energy.',
      colorA: Color(0x3322C55E),
      colorB: Color(0x334ADE80),
    ),
    SolarBenefitItem(
      icon: Icons.trending_up,
      title: 'Cost Savings',
      description: 'Save 60-90% on electricity bills with efficient systems.',
      colorA: Color(0x333B82F6),
      colorB: Color(0x3360A5FA),
    ),
    SolarBenefitItem(
      icon: Icons.shield,
      title: 'Reliability',
      description: '25-30 year warranty with long-term durability.',
      colorA: Color(0x338B5CF6),
      colorB: Color(0x33A78BFA),
    ),
    SolarBenefitItem(
      icon: Icons.bar_chart,
      title: 'Smart Monitoring',
      description: 'Real-time tracking and predictive maintenance.',
      colorA: Color(0x33F97316),
      colorB: Color(0x33FB923C),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchSolarPanels();
    _testimonialTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || testimonials.isEmpty) return;
      setState(() => currentSlide = (currentSlide + 1) % testimonials.length);
    });
  }

  @override
  void dispose() {
    _testimonialTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSolarPanels() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        solarPanels = const [
          SolarPanelItem(
            id: 's1',
            name: 'SunCore Residential 450',
            type: 'Residential',
            description: 'High-efficiency monocrystalline panel ideal for modern homes.',
            image: 'assets/roof-top solar.jpg',
            capacity: '450W',
            efficiency: '22.1%',
            price: '\$420',
            rating: 4.8,
            reviews: 182,
          ),
          SolarPanelItem(
            id: 's2',
            name: 'AgriPower Farm 650',
            type: 'Agricultural',
            description: 'Durable panel array optimized for solar farm deployments.',
            image: 'assets/solar panels.jpg',
            capacity: '650W',
            efficiency: '21.5%',
            price: '\$560',
            rating: 4.9,
            reviews: 96,
          ),
          SolarPanelItem(
            id: 's3',
            name: 'Enterprise Pro 720',
            type: 'Commercial',
            description: 'Enterprise-grade panel with advanced performance analytics.',
            image: 'assets/cutting-edge solar panels.jpg',
            capacity: '720W',
            efficiency: '23.0%',
            price: '\$690',
            rating: 4.9,
            reviews: 124,
          ),
          SolarPanelItem(
            id: 's4',
            name: 'UrbanLite 380',
            type: 'Residential',
            description: 'Compact rooftop panel designed for urban installations.',
            image: 'assets/solar panels 1.jpg',
            capacity: '380W',
            efficiency: '20.4%',
            price: '\$350',
            rating: 4.6,
            reviews: 208,
          ),
          SolarPanelItem(
            id: 's5',
            name: 'GridMax Industrial 800',
            type: 'Industrial',
            description: 'Heavy-duty panel with exceptional output for utility systems.',
            image: 'assets/cutting-edge solar panels.jpg',
            capacity: '800W',
            efficiency: '23.4%',
            price: '\$780',
            rating: 4.8,
            reviews: 73,
          ),
        ];
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = 'Failed to load solar panels. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 1000;
    final filteredPanels = selectedType == 'all'
        ? solarPanels
        : solarPanels.where((p) => p.type == selectedType).toList();
    final panelTypes = ['all', ...{...solarPanels.map((p) => p.type)}];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _hero(isMobile),
            _rooftopSection(isMobile),
            _solarFarmSection(isMobile),
            _commercialSection(isMobile),
            _catalogSection(isMobile, panelTypes, filteredPanels),
            _innovationSection(isMobile),
            _benefitsSection(isMobile),
            _testimonialsSection(isMobile),
            _ctaSection(isMobile),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _hero(bool isMobile) {
    return SizedBox(
      height: isMobile ? 700 : 900,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AssetVideoPlayer(
            assetPath: 'assets/solar.mp4',
            fallbackAssetPath: 'assets/solar panels.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.25)],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced Solar Panel Technology',
                      style: TextStyle(fontSize: isMobile ? 48 : 78, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Transform energy consumption with intelligent solar solutions that deliver exceptional performance.',
                      style: TextStyle(fontSize: 24, color: Color(0xFFF1F5F9)),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Get Started Today',
                      a: const Color(0xFFEA580C),
                      b: const Color(0xFFEAB308),
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rooftopSection(bool isMobile) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(
        height: 500,
        child: _AssetBackground(assetPath: 'assets/roof-top solar.jpg'),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transform Your Home with Rooftop Solar', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        const Text(
          'Bring clean, renewable energy directly to your home with premium monocrystalline panels.',
          style: TextStyle(fontSize: 22, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 14),
        ...const [
          'Up to 22% energy efficiency',
          'Weather-resistant installation',
          'Smart monitoring system included',
          '25-year performance warranty',
        ].map((s) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF16A34A)),
                  SizedBox(width: 8),
                  Expanded(child: Text(s, style: TextStyle(color: Color(0xFF334155), fontSize: 18))),
                ],
              ),
            )),
        const SizedBox(height: 10),
        GradientButton(
          text: 'Learn More',
          a: Color(0xFFEA580C),
          b: Color(0xFFEAB308),
          onPressed: () {},
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)]),
      ),
      child: isMobile
          ? Column(children: [image, const SizedBox(height: 14), text])
          : Row(children: [Expanded(child: image), const SizedBox(width: 16), Expanded(child: text)]),
    );
  }

  Widget _solarFarmSection(bool isMobile) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Large-Scale Solar Farm Solutions', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        const Text(
          'Harness the power of thousands of panels for utility-scale projects.',
          style: TextStyle(fontSize: 22, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 14),
        _infoBox('Energy Generation', 'Generate 500+ kWh annually per installed system', const [Color(0xFFFFF7ED), Color(0xFFFFEDD5)]),
        _infoBox('Cost Efficiency', 'Reduce operational costs by up to 70%', const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)]),
        _infoBox('Environmental Impact', 'Offset 2000+ tons of carbon annually', const [Color(0xFFF0FDF4), Color(0xFFDCFCE7)]),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: () {}, child: const Text('Explore Farm Solutions')),
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(height: 500, child: _AssetBackground(assetPath: 'assets/solar panels.jpg')),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      child: isMobile
          ? Column(children: [text, const SizedBox(height: 14), image])
          : Row(children: [Expanded(child: text), const SizedBox(width: 16), Expanded(child: image)]),
    );
  }

  Widget _commercialSection(bool isMobile) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(height: 500, child: _AssetBackground(assetPath: 'assets/cutting-edge solar panels.jpg')),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enterprise-Grade Commercial Solar', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        const Text(
          'Designed for businesses demanding maximum performance and reliability.',
          style: TextStyle(fontSize: 22, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 12),
        _featureRow(Icons.trending_up, '500+ kW Capacity', 'Scale to meet any business energy demands', const [Color(0xFFEA580C), Color(0xFFF59E0B)]),
        _featureRow(Icons.workspace_premium, 'Industry Leading', 'Certified and trusted by enterprise customers', const [Color(0xFF3B82F6), Color(0xFF06B6D4)]),
        _featureRow(Icons.bolt, '24/7 Monitoring', 'Real-time analytics and performance tracking', const [Color(0xFF22C55E), Color(0xFF10B981)]),
        const SizedBox(height: 10),
        GradientButton(
          text: 'Request Commercial Quote',
          a: const Color(0xFFEA580C),
          b: const Color(0xFFEAB308),
          onPressed: () => Navigator.pushNamed(context, '/contact'),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFFFF7ED)]),
      ),
      child: isMobile
          ? Column(children: [image, const SizedBox(height: 14), text])
          : Row(children: [Expanded(child: image), const SizedBox(width: 16), Expanded(child: text)]),
    );
  }

  Widget _catalogSection(bool isMobile, List<String> panelTypes, List<SolarPanelItem> filteredPanels) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFEF9C3)]),
      ),
      child: Column(
        children: [
          Text('Our Solar Panel Collection', style: TextStyle(fontSize: isMobile ? 40 : 58, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
          const SizedBox(height: 10),
          const Text(
            'Explore our complete range for residential, commercial, and industrial applications.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF334155), fontSize: 20),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: panelTypes
                .map(
                  (type) => ChoiceChip(
                    label: Text(type == 'all' ? 'All Panels' : type),
                    selected: selectedType == type,
                    onSelected: (_) => setState(() => selectedType = type),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          if (loading)
            const Column(children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Loading solar panels from database...')])
          else if (error != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Column(
                children: [
                  Text(error!, style: const TextStyle(color: Color(0xFFDC2626))),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: _fetchSolarPanels, child: const Text('Retry Loading')),
                ],
              ),
            )
          else if (filteredPanels.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Text(
                selectedType == 'all' ? 'No solar panels available at the moment.' : 'No $selectedType panels found.',
                style: const TextStyle(color: Color(0xFF334155)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredPanels.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isMobile ? 1.2 : 0.82,
              ),
              itemBuilder: (context, i) {
                final panel = filteredPanels[i];
                return _panelCard(panel);
              },
            ),
        ],
      ),
    );
  }

  Widget _panelCard(SolarPanelItem panel) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _AssetBackground(assetPath: panel.image),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xEAEA580C),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(panel.type),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: DefaultTextStyle(
              style: const TextStyle(color: Color(0xFF0F172A)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(panel.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(panel.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF334155))),
                  const SizedBox(height: 8),
                  if (panel.capacity.isNotEmpty) _statRow('Capacity', panel.capacity),
                  if (panel.efficiency.isNotEmpty) _statRow('Efficiency', panel.efficiency),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(panel.price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFEA580C))),
                      const Spacer(),
                      Text('★ ${panel.rating.toStringAsFixed(1)} (${panel.reviews})'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFEAB308)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Get Quote', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _innovationSection(bool isMobile) {
    return SizedBox(
      height: isMobile ? 800 : 900,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AssetVideoPlayer(
            assetPath: 'assets/solar.webm',
            fallbackAssetPath: 'assets/solar panels.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cutting-Edge Solar Innovation',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: isMobile ? 48 : 70, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Stay ahead with AI-powered optimization, predictive maintenance, and real-time energy management.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Color(0xFFF1F5F9)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Next-Generation Features', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                          SizedBox(height: 10),
                          _Bullet('AI-powered energy optimization'),
                          _Bullet('Predictive maintenance alerts'),
                          _Bullet('Mobile app control & monitoring'),
                          _Bullet('Weather-adaptive performance'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GradientButton(
                      text: 'Explore Technology',
                      a: const Color(0xFFEA580C),
                      b: const Color(0xFFEAB308),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitsSection(bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0x08000000),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      child: Column(
        children: [
          const Text('Why Choose Allytic Solar?', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          const Text(
            'Experience the advantages of our advanced solar technology and comprehensive service.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF334155), fontSize: 20),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: benefits.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMobile ? 2.8 : 0.9,
            ),
            itemBuilder: (context, i) {
              final b = benefits[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [b.colorA, b.colorB]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(color: Color(0xFF0F172A)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(b.icon, size: 38),
                      const SizedBox(height: 8),
                      Text(b.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(b.description, style: const TextStyle(color: Color(0xFF334155))),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _testimonialsSection(bool isMobile) {
    final t = testimonials[currentSlide];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      child: Column(
        children: [
          const Text('What Our Customers Say', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          const Text(
            'Real feedback from satisfied customers across Africa and beyond.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF334155), fontSize: 20),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFEF9C3)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(t.rating, (_) => const Icon(Icons.star, color: Color(0xFFEAB308))),
                ),
                const SizedBox(height: 10),
                Text('"${t.text}"', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFEA580C),
                      child: Text(t.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        Text(t.company, style: const TextStyle(color: Color(0xFF334155))),
                        Text(t.location, style: const TextStyle(color: Color(0xFFEA580C))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              testimonials.length,
              (i) => GestureDetector(
                onTap: () => setState(() => currentSlide = i),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: currentSlide == i ? const Color(0xFFEA580C) : const Color(0xFF94A3B8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEAB308)]),
      ),
      child: Column(
        children: [
          const Text('Ready to Go Solar?', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'Join thousands of customers who switched to clean renewable energy. Get a free consultation today.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/contact'),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Schedule Consultation'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFEA580C),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('Call: +254-700-000-000'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            children: const [
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Color(0xFFFACC15)),
                        SizedBox(width: 8),
                        Text('Allytic Labs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Leading provider of solar solutions across Africa and beyond.', style: TextStyle(color: Color(0xFF94A3B8))),
                    SizedBox(height: 6),
                    Row(children: [Icon(Icons.location_on, size: 16), SizedBox(width: 6), Text('Nairobi, Kenya')]),
                  ],
                ),
              ),
              _FooterMini(title: 'Quick Links', items: ['Products', 'Installation', 'Maintenance', 'Support']),
              _FooterMini(title: 'Contact Info', items: ['+254-700-000-000', 'solar@allytic-labs.com']),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 8),
          const Text('© 2026 Allytic Labs. All rights reserved.'),
        ],
      ),
    );
  }

  Widget _infoBox(String title, String body, List<Color> colors) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Color(0xFF0F172A)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(body, style: const TextStyle(color: Color(0xFF334155))),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String body, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                Text(body, style: const TextStyle(color: Color(0xFF334155))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label:', style: const TextStyle(color: Color(0xFF64748B))),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(color: Color(0xFFEA580C), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 20, color: Color(0xFFF1F5F9)))),
        ],
      ),
    );
  }
}

class _FooterMini extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterMini({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...items.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(i, style: const TextStyle(color: Color(0xFF94A3B8))),
              )),
        ],
      ),
    );
  }
}

class SolarPanelItem {
  final String id;
  final String name;
  final String type;
  final String description;
  final String image;
  final String capacity;
  final String efficiency;
  final String price;
  final double rating;
  final int reviews;

  const SolarPanelItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.capacity,
    required this.efficiency,
    required this.price,
    required this.rating,
    required this.reviews,
  });
}

class TestimonialItem {
  final String name;
  final String company;
  final int rating;
  final String text;
  final String location;

  const TestimonialItem({
    required this.name,
    required this.company,
    required this.rating,
    required this.text,
    required this.location,
  });
}

class SolarBenefitItem {
  final IconData icon;
  final String title;
  final String description;
  final Color colorA;
  final Color colorB;

  const SolarBenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.colorA,
    required this.colorB,
  });
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, isMobile ? 90 : 120, 20, 56),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0B1224), Color(0xFF1E3A8A), Color(0xFF0F766E)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'About Ailytic Labs',
                      style: TextStyle(color: Color(0xFFDBEAFE), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Engineering Practical Innovation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 44 : 72, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'We build robotics, drone, and solar systems that solve real operational problems at scale.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 21),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    children: [
                      Text(
                        'Our Mission',
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: isMobile ? 38 : 56,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Deliver dependable intelligent systems that improve productivity, safety, and sustainability across industries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF334155), fontSize: 19),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          _AboutMetricCard(label: 'Projects Delivered', value: '120+'),
                          _AboutMetricCard(label: 'Enterprise Clients', value: '45+'),
                          _AboutMetricCard(label: 'Countries Served', value: '9'),
                          _AboutMetricCard(label: 'Uptime Across Systems', value: '99.9%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F172A), Color(0xFF0B1224)],
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    children: [
                      Text(
                        'What Defines Us',
                        style: TextStyle(fontSize: isMobile ? 36 : 52, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'A practical culture focused on execution quality and long-term customer value.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 19),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          _AboutValueCard(
                            icon: Icons.verified,
                            title: 'Reliability First',
                            text: 'We prioritize robust systems with measurable performance and minimal downtime.',
                          ),
                          _AboutValueCard(
                            icon: Icons.psychology,
                            title: 'Applied Intelligence',
                            text: 'AI is used where it creates clear operational impact, not as a gimmick.',
                          ),
                          _AboutValueCard(
                            icon: Icons.handshake,
                            title: 'Long-Term Partnership',
                            text: 'We work closely with clients from deployment through optimization and support.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF111827),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
              child: Column(
                children: [
                  const Text(
                    'Want to build with us or partner with us?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      GradientButton(
                        text: 'Contact Us',
                        a: const Color(0xFF2563EB),
                        b: const Color(0xFF06B6D4),
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/careers'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                        child: const Text('See Careers'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutMetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _AboutMetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 34, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AboutValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _AboutValueCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1F2937)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF60A5FA), size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Robotics',
    'Drones',
    'Solar',
    'Company',
  ];

  final List<_NewsItem> news = const [
    _NewsItem(
      title: 'Ailytic Labs Launches Autonomous Inspection Drone Suite',
      excerpt:
          'New AI-assisted flight stack improves inspection speed and reduces manual review time by up to 45%.',
      category: 'Drones',
      date: 'February 2026',
      readTime: '5 min read',
    ),
    _NewsItem(
      title: 'Industrial Robotics Deployment Reaches 99.9% Uptime',
      excerpt:
          'Latest manufacturing rollout demonstrates stable, high-throughput automation across three facilities.',
      category: 'Robotics',
      date: 'January 2026',
      readTime: '4 min read',
    ),
    _NewsItem(
      title: 'Solar Analytics Platform Adds Predictive Maintenance Alerts',
      excerpt:
          'Operations teams can now detect underperformance trends earlier with anomaly and weather correlation.',
      category: 'Solar',
      date: 'January 2026',
      readTime: '6 min read',
    ),
    _NewsItem(
      title: 'Ailytic Labs Expands Regional Service Network',
      excerpt:
          'New partner coverage improves implementation support and field response times across key markets.',
      category: 'Company',
      date: 'December 2025',
      readTime: '3 min read',
    ),
    _NewsItem(
      title: 'Multi-Robot Orchestration Engine Enters Production',
      excerpt:
          'Coordinated fleet control now powers logistics and warehouse workflows with improved throughput.',
      category: 'Robotics',
      date: 'November 2025',
      readTime: '5 min read',
    ),
    _NewsItem(
      title: 'Field Pilot: Smart Solar Monitoring for Commercial Roofs',
      excerpt:
          'Pilot results show faster fault triage and better energy yield consistency in mixed-weather conditions.',
      category: 'Solar',
      date: 'October 2025',
      readTime: '4 min read',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final filtered = selectedCategory == 'All'
        ? news
        : news.where((n) => n.category == selectedCategory).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, isMobile ? 90 : 120, 20, 56),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0B1224), Color(0xFF1E3A8A), Color(0xFF0EA5E9)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Newsroom', style: TextStyle(color: Color(0xFFDBEAFE), fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Latest News & Updates',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 44 : 72, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Announcements, product updates, and engineering milestones from Ailytic Labs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 21),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories
                      .map(
                        (c) => ChoiceChip(
                          label: Text(c),
                          selected: selectedCategory == c,
                          onSelected: (_) => setState(() => selectedCategory = c),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF111827)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D4ED8),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('Featured', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 12),
                        Text(news.first.title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(news.first.excerpt, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('${news.first.category} · ${news.first.date} · ${news.first.readTime}', style: const TextStyle(color: Color(0xFF93C5FD))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isMobile ? 1.7 : 1.45,
                    ),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF1F2937)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.category, style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(item.excerpt, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16)),
                            const Spacer(),
                            Text('${item.date} · ${item.readTime}', style: const TextStyle(color: Color(0xFF94A3B8))),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF111827),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
              child: Column(
                children: [
                  const Text('Want product updates directly?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      GradientButton(
                        text: 'Contact Us',
                        a: const Color(0xFF2563EB),
                        b: const Color(0xFF06B6D4),
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/about'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                        child: const Text('About Us'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsItem {
  final String title;
  final String excerpt;
  final String category;
  final String date;
  final String readTime;

  const _NewsItem({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
    required this.readTime,
  });
}

class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    const jobs = [
      _CareerJob(
        title: 'Senior Robotics Engineer',
        location: 'Nairobi, Kenya',
        type: 'Full-time',
        team: 'Robotics',
        summary: 'Design and ship autonomous robotic systems for industrial and agricultural use cases.',
      ),
      _CareerJob(
        title: 'Drone Systems Developer',
        location: 'Lagos, Nigeria',
        type: 'Full-time',
        team: 'Drones',
        summary: 'Build flight-control, telemetry, and computer-vision modules for enterprise drone products.',
      ),
      _CareerJob(
        title: 'Solar Solutions Consultant',
        location: 'Accra, Ghana',
        type: 'Full-time',
        team: 'Energy',
        summary: 'Lead customer discovery, sizing, and solution architecture for commercial solar deployments.',
      ),
      _CareerJob(
        title: 'Frontend Flutter Engineer',
        location: 'Remote',
        type: 'Contract',
        team: 'Platform',
        summary: 'Develop responsive, high-performance mobile and web interfaces across product lines.',
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, isMobile ? 90 : 120, 20, 54),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0B1224), Color(0xFF1E3A8A), Color(0xFF0EA5E9)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Join Allytic Labs', style: TextStyle(color: Color(0xFFDBEAFE))),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Build The Future With Us',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 44 : 72, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'We are hiring engineers, researchers, and operators across robotics, drones, and solar energy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 21),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      GradientButton(
                        text: 'View Open Roles',
                        a: const Color(0xFF2563EB),
                        b: const Color(0xFF06B6D4),
                        onPressed: () {},
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                        child: const Text('Contact Recruiting'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
              child: Column(
                children: [
                  Text(
                    'Why Work Here',
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: isMobile ? 38 : 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We build real-world systems with measurable impact and strong engineering standards.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF334155), fontSize: 19),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      _CareerBenefitCard(
                        icon: Icons.bolt,
                        title: 'High-Impact Work',
                        text: 'Ship products used in agriculture, logistics, and energy markets.',
                      ),
                      _CareerBenefitCard(
                        icon: Icons.groups_2,
                        title: 'Strong Team',
                        text: 'Collaborate with multidisciplinary engineers and domain specialists.',
                      ),
                      _CareerBenefitCard(
                        icon: Icons.school,
                        title: 'Growth',
                        text: 'Clear ownership, mentorship, and opportunities to lead initiatives.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F172A), Color(0xFF0B1224)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Open Positions',
                    style: TextStyle(fontSize: isMobile ? 36 : 52, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Select a role and apply through our recruiting team.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      children: jobs
                          .map(
                            (job) => _CareerJobCard(
                              job: job,
                              onApply: () => Navigator.pushNamed(context, '/contact'),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
              color: const Color(0xFF111827),
              child: const Column(
                children: [
                  Text('careers@ailyticslabs.com', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text(
                    'Send your CV and portfolio. Include the role title in your email subject.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareerBenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _CareerBenefitCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF1D4ED8), size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Color(0xFF334155), fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _CareerJobCard extends StatelessWidget {
  final _CareerJob job;
  final VoidCallback onApply;

  const _CareerJobCard({required this.job, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _jobChip(job.team),
                    _jobChip(job.type),
                    _jobChip(job.location),
                  ],
                ),
                const SizedBox(height: 10),
                Text(job.summary, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GradientButton(
            text: 'Apply',
            a: const Color(0xFF2563EB),
            b: const Color(0xFF06B6D4),
            onPressed: onApply,
            compact: true,
          ),
        ],
      ),
    );
  }

  Widget _jobChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
    );
  }
}

class _CareerJob {
  final String title;
  final String location;
  final String type;
  final String team;
  final String summary;

  const _CareerJob({
    required this.title,
    required this.location,
    required this.type,
    required this.team,
    required this.summary,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _apiBaseUrl =
      'http://allytic-labs-prod.eba-pukad2pd.us-east-1.elasticbeanstalk.com';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _step = 1;
  bool _loading = false;
  bool _showPassword = false;
  String? _emailError;
  String? _passwordError;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinkHandling();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  Map<String, dynamic>? _tryDecodeJson(String body) {
    try {
      final parsed = jsonDecode(body);
      if (parsed is Map<String, dynamic>) return parsed;
    } catch (_) {}
    return null;
  }

  Future<void> _initializeDeepLinkHandling() async {
    if (kIsWeb) {
      await _handleOAuthRedirectUri(Uri.base);
      return;
    }

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleOAuthRedirectUri(initialUri);
      }
    } catch (_) {}

    _linkSub?.cancel();
    _linkSub = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleOAuthRedirectUri(uri);
      },
      onError: (_) {},
    );
  }

  bool _isOAuthRedirect(Uri uri) {
    final isAppScheme =
        uri.scheme.toLowerCase() == 'allyticlabs' && uri.host.toLowerCase() == 'oauth2' && uri.path == '/redirect';

    final isWebCallback = kIsWeb && uri.path.contains('/oauth2/redirect');

    return isAppScheme || isWebCallback;
  }

  Map<String, String> _extractOAuthParams(Uri uri) {
    final params = <String, String>{};
    params.addAll(uri.queryParameters);

    if (uri.fragment.isNotEmpty) {
      try {
        final fragmentParams = Uri.splitQueryString(uri.fragment);
        for (final entry in fragmentParams.entries) {
          params.putIfAbsent(entry.key, () => entry.value);
        }
      } catch (_) {}
    }

    return params;
  }

  Future<void> _handleOAuthRedirectUri(Uri uri) async {
    if (!_isOAuthRedirect(uri) || !mounted) return;

    final params = _extractOAuthParams(uri);

    if (params.containsKey('error')) {
      if (!mounted) return;
      setState(() {
        _passwordError = params['error_description'] ?? params['error'] ?? 'Google sign-in failed.';
      });
      return;
    }

    final accessToken = params['accessToken'] ?? params['access_token'];
    final refreshToken = params['refreshToken'] ?? params['refresh_token'];
    final userId = params['userId'] ?? params['user_id'];
    final email = params['email'];
    final username = params['username'];
    final rolesRaw = params['roles'];

    if (accessToken != null && accessToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await prefs.setString('refreshToken', refreshToken);
      }
      if (userId != null && userId.isNotEmpty) {
        await prefs.setString('userId', userId);
      }

      final resolvedEmail = (email != null && email.isNotEmpty) ? email : _emailController.text.trim();
      final resolvedUsername = (username != null && username.isNotEmpty)
          ? username
          : (resolvedEmail.isNotEmpty ? resolvedEmail : 'google_user');

      if (resolvedEmail.isNotEmpty) {
        await prefs.setString('userEmail', resolvedEmail);
      }
      await prefs.setString('username', resolvedUsername);

      final roles = rolesRaw != null && rolesRaw.isNotEmpty
          ? rolesRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : <String>[];

      await prefs.setString(
        'user',
        jsonEncode({
          'userId': userId,
          'email': resolvedEmail,
          'username': resolvedUsername,
          'roles': roles,
        }),
      );

      final returnTo = params['state'] ?? prefs.getString('returnTo') ?? '/';
      await prefs.remove('returnTo');

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, returnTo, (route) => false);
      return;
    }

    final code = params['code'];
    if (code != null && code.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _passwordError =
            'Google sign-in returned an authorization code but no access token. Configure backend callback to include tokens in redirect.';
      });
    }
  }

  void _submitEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return;
    }
    setState(() {
      _emailError = null;
      _step = 2;
    });
  }

  Future<void> _submitPassword() async {
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    if (password.trim().isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }
    if (password.length < 8) {
      setState(() => _passwordError = 'Password must be at least 8 characters');
      return;
    }

    setState(() {
      _passwordError = null;
      _loading = true;
    });

    HttpClient? client;
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/auth/login');
      client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(
        utf8.encode(
          jsonEncode({
            'username': email,
            'password': password,
          }),
        ),
      );

      final response = await request.close();
      final body = await utf8.decodeStream(response);
      final data = _tryDecodeJson(body);
      final contentType = response.headers.contentType?.mimeType ?? '';

      if (!contentType.contains('application/json') || data == null) {
        if (!mounted) return;
        setState(() => _passwordError = 'Server returned invalid response. Please try again.');
        return;
      }

      final ok = response.statusCode >= 200 && response.statusCode < 300;
      final status = data['status']?.toString().toLowerCase();
      if (ok && status == 'success') {
        final prefs = await SharedPreferences.getInstance();

        if (data['accessToken'] != null) {
          await prefs.setString('accessToken', data['accessToken'].toString());
        }
        if (data['refreshToken'] != null) {
          await prefs.setString('refreshToken', data['refreshToken'].toString());
        }
        if (data['userId'] != null) {
          await prefs.setString('userId', data['userId'].toString());
        }

        final userEmail = (data['email'] ?? email).toString();
        final username = (data['username'] ?? email).toString();
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('username', username);

        await prefs.setString(
          'user',
          jsonEncode({
            'userId': data['userId'],
            'email': userEmail,
            'username': username,
            'roles': data['roles'] ?? <dynamic>[],
          }),
        );

        final returnTo = prefs.getString('returnTo') ?? '/';
        await prefs.remove('returnTo');

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, returnTo, (route) => false);
      } else {
        final message = data['message']?.toString() ??
            data['error']?.toString() ??
            'Invalid email or password';
        if (!mounted) return;
        setState(() => _passwordError = message);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _passwordError = 'Unable to connect to server. Please check your internet connection.';
      });
    } finally {
      client?.close(force: true);
      if (mounted) setState(() => _loading = false);
    }
  }

  void _forgotPassword() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset'),
        content: const Text(
          'Password reset feature will be available soon. Please contact support for immediate assistance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _googleLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final returnTo = prefs.getString('returnTo') ?? '/';
      await prefs.setString('returnTo', returnTo);

      final redirectUri = kIsWeb
          ? '${Uri.base.origin}/oauth2/redirect'
          : 'allyticlabs://oauth2/redirect';

      final oauthUri = Uri.parse('$_apiBaseUrl/oauth2/authorize/google').replace(
        queryParameters: {
          'redirect_uri': redirectUri,
          'state': returnTo,
        },
      );

      final launched = await launchUrl(
        oauthUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Google sign-in.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to start Google sign-in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Allytic Labs',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_step == 1) ...[
                          _AuthInputField(
                            label: 'Email',
                            controller: _emailController,
                            enabled: !_loading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (_) => null,
                          ),
                          if (_emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(_emailError!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
                            ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: _loading ? null : _submitEmail,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Next'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _forgotPassword,
                            child: const Text('Trouble Signing In?'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('Or', style: TextStyle(color: Color(0xFF6B7280))),
                              ),
                              Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _loading ? null : _googleLogin,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1F2937),
                                side: const BorderSide(color: Color(0xFFD1D5DB)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Continue with Google'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _loading ? null : () => Navigator.pushNamed(context, '/signup'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1F2937),
                                backgroundColor: const Color(0xFFF3F4F6),
                                side: const BorderSide(color: Color(0xFFE5E7EB)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Create Account'),
                            ),
                          ),
                        ] else ...[
                          TextButton.icon(
                            onPressed: _loading
                                ? null
                                : () {
                                    setState(() {
                                      _step = 1;
                                      _passwordController.clear();
                                      _passwordError = null;
                                    });
                                  },
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text('Back'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Signing in as: ${_emailController.text.trim()}',
                            style: const TextStyle(color: Color(0xFF4B5563)),
                          ),
                          const SizedBox(height: 12),
                          _AuthInputField(
                            label: 'Password',
                            controller: _passwordController,
                            enabled: !_loading,
                            obscureText: !_showPassword,
                            validator: (_) => null,
                            suffix: IconButton(
                              onPressed: _loading ? null : () => setState(() => _showPassword = !_showPassword),
                              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                          if (_passwordError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(_passwordError!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
                            ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: _loading ? null : _submitPassword,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _loading ? null : _forgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Allytic Labs © 2026', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/privacy'),
                              child: const Text('Privacy & Legal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/contact'),
                              child: const Text('Contact'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const String _apiBaseUrl =
      'http://allytic-labs-prod.eba-pukad2pd.us-east-1.elasticbeanstalk.com/api/v1';

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  String _apiError = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  String? _validateEmail(String? value) {
    final required = _required(value, 'Email');
    if (required != null) return required;
    final email = value!.trim();
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
      return 'Email is invalid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final required = _required(value, 'Password');
    if (required != null) return required;
    if (value!.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final required = _required(value, 'Confirm password');
    if (required != null) return required;
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Map<String, dynamic>? _tryDecodeJson(String body) {
    try {
      final parsed = jsonDecode(body);
      if (parsed is Map<String, dynamic>) return parsed;
    } catch (_) {}
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _apiError = '');

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final payload = {
      'username': email,
      'email': email,
      'password': _passwordController.text,
      'confirmPassword': _confirmPasswordController.text,
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
    };

    HttpClient? client;
    try {
      final uri = Uri.parse('$_apiBaseUrl/auth/register');
      client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));

      final response = await request.close();
      final body = await utf8.decodeStream(response);
      final contentType = response.headers.contentType?.mimeType ?? '';
      final data = _tryDecodeJson(body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Account Created'),
            content: const Text('Account created successfully. Please login with your credentials.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (!mounted) return;
        Navigator.pushNamed(context, '/login');
      } else {
        String message = 'Registration failed. Please try again.';
        if (data != null) {
          if (data['message'] is String && (data['message'] as String).trim().isNotEmpty) {
            message = data['message'] as String;
          } else if (data['errors'] is Map) {
            final entries = <String>[];
            (data['errors'] as Map).forEach((k, v) {
              entries.add('$k: $v');
            });
            if (entries.isNotEmpty) {
              message = entries.join('\n');
            }
          }
        } else if (!contentType.contains('application/json')) {
          message = 'Server returned invalid response. Please try again.';
        }

        if (!mounted) return;
        setState(() => _apiError = message);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _apiError = 'Unable to connect to server. Please check your internet connection.';
      });
    } finally {
      client?.close(force: true);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Allytic Labs',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 22),
                          if (_apiError.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _apiError,
                                      style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          _AuthInputField(
                            label: 'First Name',
                            controller: _firstNameController,
                            enabled: !_isLoading,
                            validator: (v) => _required(v, 'First name'),
                          ),
                          const SizedBox(height: 12),
                          _AuthInputField(
                            label: 'Last Name',
                            controller: _lastNameController,
                            enabled: !_isLoading,
                            validator: (v) => _required(v, 'Last name'),
                          ),
                          const SizedBox(height: 12),
                          _AuthInputField(
                            label: 'Email',
                            controller: _emailController,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 12),
                          _AuthInputField(
                            label: 'Password',
                            controller: _passwordController,
                            enabled: !_isLoading,
                            obscureText: !_showPassword,
                            validator: _validatePassword,
                            suffix: IconButton(
                              onPressed: _isLoading ? null : () => setState(() => _showPassword = !_showPassword),
                              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _AuthInputField(
                            label: 'Confirm Password',
                            controller: _confirmPasswordController,
                            enabled: !_isLoading,
                            obscureText: !_showConfirmPassword,
                            validator: _validateConfirmPassword,
                            suffix: IconButton(
                              onPressed: _isLoading ? null : () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                              icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: _isLoading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Create Account'),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('Already have an account?', style: TextStyle(color: Color(0xFF6B7280))),
                              ),
                              Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/login'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF374151),
                                side: const BorderSide(color: Color(0xFFD1D5DB)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Allytic Labs © 2026', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/privacy'),
                                child: const Text('Privacy & Legal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/contact'),
                                child: const Text('Contact'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthInputField({
    required this.label,
    required this.controller,
    required this.enabled,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: suffix,
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$title Page', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text('This page is intentionally empty for now.'),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              child: const Text('Back To Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoPlaceholderPage extends StatelessWidget {
  const DemoPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demoType = ModalRoute.of(context)?.settings.arguments as String? ?? 'unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Demo Page', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Requested demo type: $demoType'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              child: const Text('Back To Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroSectionData {
  final String title;
  final String subtitle;
  final String cta;
  final String link;
  final String demoType;
  final Color gradientA;
  final Color gradientB;
  final String backgroundAsset;

  const HeroSectionData({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.link,
    required this.demoType,
    required this.gradientA,
    required this.gradientB,
    required this.backgroundAsset,
  });
}

class InnovationData {
  final String title;
  final String description;
  final List<String> stats;
  final String link;
  final Color accent;
  final String backgroundAsset;

  const InnovationData({
    required this.title,
    required this.description,
    required this.stats,
    required this.link,
    required this.accent,
    required this.backgroundAsset,
  });
}

class GalleryData {
  final String title;
  final String description;
  final String link;
  final Color gradientA;
  final Color gradientB;
  final String backgroundAsset;

  const GalleryData({
    required this.title,
    required this.description,
    required this.link,
    required this.gradientA,
    required this.gradientB,
    required this.backgroundAsset,
  });
}

class FooterLink {
  final String label;
  final String route;

  const FooterLink({required this.label, required this.route});
}
