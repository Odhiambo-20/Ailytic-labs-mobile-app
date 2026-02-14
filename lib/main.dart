import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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
        '/solarpanels': (context) => const PlaceholderPage(title: 'Solar Panels'),
        '/products': (context) => const PlaceholderPage(title: 'Products'),
        '/robots/catalog': (context) => const RobotsCatalogPage(),
        '/solutions': (context) => const PlaceholderPage(title: 'Solutions'),
        '/research': (context) => const PlaceholderPage(title: 'Research'),
        '/about': (context) => const PlaceholderPage(title: 'About'),
        '/careers': (context) => const PlaceholderPage(title: 'Careers'),
        '/news': (context) => const PlaceholderPage(title: 'News'),
        '/contact': (context) => const PlaceholderPage(title: 'Contact'),
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
