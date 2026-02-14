import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        '/robots': (context) => const PlaceholderPage(title: 'Robots'),
        '/drones': (context) => const DronesPage(),
        '/solarpanels': (context) => const PlaceholderPage(title: 'Solar Panels'),
        '/products': (context) => const PlaceholderPage(title: 'Products'),
        '/solutions': (context) => const PlaceholderPage(title: 'Solutions'),
        '/research': (context) => const PlaceholderPage(title: 'Research'),
        '/about': (context) => const PlaceholderPage(title: 'About'),
        '/careers': (context) => const PlaceholderPage(title: 'Careers'),
        '/news': (context) => const PlaceholderPage(title: 'News'),
        '/contact': (context) => const PlaceholderPage(title: 'Contact'),
        '/support': (context) => const PlaceholderPage(title: 'Support'),
        '/partners': (context) => const PlaceholderPage(title: 'Partners'),
        '/demo': (context) => const DemoPlaceholderPage(),
        '/order': (context) => const PlaceholderPage(title: 'Order'),
        '/latest-models': (context) => const PlaceholderPage(title: 'Latest Models'),
       
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

  @override
  Widget build(BuildContext context) {
    _assetKeysFuture ??= _loadAssetKeys();

    return FutureBuilder<Set<String>>(
      future: _assetKeysFuture,
      builder: (context, snapshot) {
        final hasAsset = snapshot.data?.contains(assetPath) ?? false;
        if (hasAsset) {
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
