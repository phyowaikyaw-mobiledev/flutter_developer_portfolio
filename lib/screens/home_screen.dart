import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/common/hover_button.dart';
import '../widgets/common/counter_number.dart';
import '../widgets/common/reveal_animator.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl, _rotCtrl;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _rotCtrl.dispose();
    super.dispose();
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _gmail() {
    const s = 'Portfolio Contact - Flutter Developer Opportunity';
    const b =
        'Hello Phyo Wai Kyaw,\n\nI came across your portfolio and would like to connect.\n\nBest regards,';
    _launch(
      'https://mail.google.com/mail/?view=cm&fs=1&to=${AppStrings.email}&su=${Uri.encodeComponent(s)}&body=${Uri.encodeComponent(b)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: MouseRegion(
        onHover: (e) => setState(() => _mousePos = e.localPosition),
        child: Stack(
          children: [
            AnimatedBackground(rotation: _rotCtrl),
            // mouse-following orb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 120),
              left: _mousePos.dx - 150,
              top: _mousePos.dy - 150,
              child: IgnorePointer(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF3B82F6).withValues(alpha: 0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _hero(isMobile),
                  _proofStrip(isMobile),
                  _stats(isMobile),
                  _footer(isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(bool isMobile) {
    return SizedBox(
      height: isMobile ? 750 : 850,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // floating avatar
                  AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(_floatCtrl.value * math.pi) * 18,
                      ),
                      child: child,
                    ),
                    child: Container(
                      width: isMobile ? 170 : 210,
                      height: isMobile ? 170 : 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF3B82F6),
                            Color(0xFF06B6D4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.55),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF7C3AED,
                            ).withValues(alpha: 0.35),
                            blurRadius: 70,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0A0E27),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/phyo.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.person,
                                  size: isMobile ? 60 : 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 30 : 50),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (_, double v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 40 * (1 - v)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [
                              Color(0xFF1E40AF),
                              Color(0xFF3B82F6),
                              Color(0xFF60A5FA),
                            ],
                          ).createShader(b),
                          child: Text(
                            'PHYO WAI KYAW',
                            style: TextStyle(
                              fontSize: isMobile ? 32 : 52,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          ).createShader(b),
                          child: Text(
                            'Flutter Developer',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 28,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                          'Cross-Platform Mobile Developer focused on shipping reliable, business-ready products',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            color: Colors.white.withValues(alpha: 0.65),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _badge(
                              Icons.location_on,
                              'Based in Chonburi, Thailand',
                              const Color(0xFF7C3AED),
                              const Color(0xFFA78BFA),
                              isMobile,
                            ),
                            _badgeAvailable(isMobile),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 30 : 40),
                  _socials(isMobile),
                  SizedBox(height: isMobile ? 20 : 30),
                  _ctas(isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String text, Color bg, Color fg, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bg.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeAvailable(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(),
          const SizedBox(width: 6),
          Text(
            'Available for opportunities',
            style: TextStyle(
              color: Colors.green,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socials(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialBtn(
          icon: FontAwesomeIcons.github,
          url: AppStrings.github,
          isMobile: isMobile,
          launch: _launch,
        ),
        SizedBox(width: isMobile ? 20 : 28),
        _SocialBtn(
          icon: FontAwesomeIcons.linkedin,
          url: AppStrings.linkedin,
          isMobile: isMobile,
          launch: _launch,
        ),
        SizedBox(width: isMobile ? 20 : 28),
        _SocialBtn(
          icon: FontAwesomeIcons.facebook,
          url: AppStrings.facebook,
          isMobile: isMobile,
          launch: _launch,
        ),
        SizedBox(width: isMobile ? 20 : 28),
        _SocialBtn(
          icon: FontAwesomeIcons.envelope,
          url: '',
          isMobile: isMobile,
          launch: (_) => _gmail(),
        ),
      ],
    );
  }

  Widget _ctas(bool isMobile) => Wrap(
    alignment: WrapAlignment.center,
    spacing: isMobile ? 12 : 16,
    runSpacing: 12,
    children: [
      HoverButton(
        label: 'Hire Me',
        icon: Icons.mail_outline,
        isMobile: isMobile,
        filled: true,
        onTap: () => context.go('/contact'),
      ),
      HoverButton(
        label: 'View Featured Work',
        icon: Icons.folder_open_outlined,
        isMobile: isMobile,
        filled: false,
        onTap: () => context.go('/apps'),
      ),
      HoverButton(
        label: 'Download CV',
        icon: Icons.download_outlined,
        isMobile: isMobile,
        filled: false,
        accent: true,
        onTap: () => _launch(AppStrings.cvUrl),
      ),
    ],
  );

  Widget _proofStrip(bool isMobile) {
    final chips = [
      (Icons.verified_rounded, 'Production Apps', '4+ live deployments'),
      (Icons.groups_2_outlined, 'Team Collaboration', 'Cross-functional engineering'),
      (Icons.bolt_rounded, 'Delivery Style', 'Scalable and maintainable code'),
    ];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 6 : 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 18,
        vertical: isMobile ? 14 : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.22),
        ),
      ),
      child: isMobile
          ? Column(
              children: chips
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _proofItem(item.$1, item.$2, item.$3, isMobile),
                      ))
                  .toList(),
            )
          : Row(
              children: chips
                  .map(
                    (item) => Expanded(
                      child: _proofItem(item.$1, item.$2, item.$3, isMobile),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _proofItem(
    IconData icon,
    String title,
    String value,
    bool isMobile,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF60A5FA), size: isMobile ? 18 : 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: isMobile ? 11 : 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stats(bool isMobile) {
    return RevealAnimator(
      delay: const Duration(milliseconds: 100),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: isMobile ? 12 : 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 28 : 36,
          horizontal: isMobile ? 20 : 40,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E40AF).withValues(alpha: 0.18),
              const Color(0xFF3B82F6).withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem(1, '+', 'Year\nExperience', isMobile),
            _divider(),
            _statItem(12, '+', 'Projects\nBuilt', isMobile),
            _divider(),
            _statItem(1, '', 'Hackathon\nWin', isMobile),
            _divider(),
            _statItem(4, '+', 'Production\nApps', isMobile),
          ],
        ),
      ),
    );
  }

  Widget _statItem(int target, String suffix, String label, bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          ).createShader(b),
          child: CounterNumber(
            key: ValueKey('counter_$target$label'),
            target: target,
            suffix: suffix,
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 11 : 13,
            color: Colors.white54,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 50,
    color: Colors.white.withValues(alpha: 0.1),
  );

  Widget _footer(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      child: Center(
        child: Column(
          children: [
            Text(
              'Built with Flutter for production-quality delivery',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2026 Phyo Wai Kyaw. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
            const SizedBox(height: 20),
            _socials(isMobile),
          ],
        ),
      ),
    );
  }
}

// ── Pulse dot ─────────────────────────────────────────────────────────────────
class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3 + 0.4 * _c.value),
            blurRadius: 4 + 6 * _c.value,
          ),
        ],
      ),
    ),
  );
}

// ── Social Button ─────────────────────────────────────────────────────────────
class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String url;
  final bool isMobile;
  final void Function(String) launch;

  const _SocialBtn({
    required this.icon,
    required this.url,
    required this.isMobile,
    required this.launch,
  });

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: () => widget.launch(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _h ? -4 : 0, 0),
          padding: EdgeInsets.all(widget.isMobile ? 11 : 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _h
                ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                : const Color(0xFF1E40AF).withValues(alpha: 0.2),
            border: Border.all(
              color: _h
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF3B82F6).withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: _h
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                      blurRadius: 16,
                    ),
                  ]
                : [],
          ),
          child: FaIcon(
            widget.icon,
            color: _h ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA),
            size: widget.isMobile ? 18 : 20,
          ),
        ),
      ),
    );
  }
}
