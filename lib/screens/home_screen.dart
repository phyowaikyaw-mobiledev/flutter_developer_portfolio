import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/common/hover_button.dart';
import '../widgets/common/counter_number.dart';
import '../widgets/common/reveal_animator.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _rotCtrl;

  @override
  void initState() {
    super.initState();
    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final compactProof = width < 1100;
    final p = context.portfolio;
    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: [
          AnimatedBackground(rotation: _rotCtrl),
          SingleChildScrollView(
            child: Column(
              children: [
                _hero(context, isMobile),
                _coreSkillsStrip(context, isMobile),
                _proofStrip(
                  context: context,
                  isMobile: isMobile,
                  compactProof: compactProof,
                ),
                _stats(context, isMobile),
                _footer(context, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coreSkillsStrip(BuildContext context, bool isMobile) {
    final p = context.portfolio;
    const skills = ['Flutter', 'Dart', 'Firebase', 'GetX', 'BLoC', 'Dio'];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 40,
        0,
        isMobile ? 20 : 40,
        isMobile ? 8 : 12,
      ),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/skills'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 20,
                vertical: isMobile ? 10 : 12,
              ),
              decoration: BoxDecoration(
                color: p.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.border),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  Text(
                    'Core stack:',
                    style: TextStyle(
                      color: p.textMuted,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...skills.map(
                    (s) => Text(
                      s,
                      style: TextStyle(
                        color: p.textPrimary,
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '→ View all skills',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, bool isMobile) {
    final p = context.portfolio;
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
                  // avatar
                  Container(
                    width: isMobile ? 170 : 210,
                    height: isMobile ? 170 : 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/phyo.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: isMobile ? 60 : 80,
                            color: p.textPrimary,
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
                        Text(
                          'PHYO WAI KYAW',
                          style: TextStyle(
                            fontSize: isMobile ? 32 : 52,
                            fontWeight: FontWeight.bold,
                            color: p.textPrimary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 28,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: isMobile ? 10 : 14),
                        _heroTagline(context, isMobile),
                        SizedBox(height: isMobile ? 12 : 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _badge(
                              Icons.location_on,
                              'Based in Chonburi, Thailand',
                              p,
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

  Widget _heroTagline(BuildContext context, bool isMobile) {
    final fontSize = isMobile ? 14.0 : 18.5;
    final p = context.portfolio;
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.25,
      height: 1.4,
      color: p.textPrimary.withValues(alpha: 0.88),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? 360 : 720),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 20,
          vertical: isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Text.rich(
          TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(text: 'Shipped '),
              TextSpan(
                text: 'DrZon',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: p.textPrimary,
                ),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Phone King Plus',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: p.textPrimary,
                ),
              ),
              const TextSpan(
                text: ' — live on Google Play and the App Store.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _badge(
    IconData icon,
    String text,
    PortfolioColors p,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryLight, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: p.textPrimary.withValues(alpha: 0.9),
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
        onTap: () => context.go('/work?section=apps'),
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

  Widget _proofStrip({
    required BuildContext context,
    required bool isMobile,
    required bool compactProof,
  }) {
    final p = context.portfolio;
    final chips = [
      (Icons.verified_rounded, 'Store Releases', '3 live on both stores'),
      (
        Icons.groups_2_outlined,
        'Team Delivery',
        'Code reviews & sprint collaboration',
      ),
      (Icons.architecture_outlined, 'Engineering', 'Dio · BLoC · l10n · Firebase'),
    ];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 6 : 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compactProof
            ? (isMobile ? 10 : 14)
            : (isMobile ? 14 : 18),
        vertical: compactProof ? 12 : (isMobile ? 14 : 16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: p.cardBg,
        border: Border.all(color: p.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < chips.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: compactProof ? 17 : 21,
                  thickness: 1,
                  indent: compactProof ? 4 : 6,
                  endIndent: compactProof ? 4 : 6,
                  color: p.border,
                ),
              Expanded(
                child: compactProof
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: _proofItemCompact(
                          context,
                          chips[i].$1,
                          chips[i].$2,
                          chips[i].$3,
                          isMobile: isMobile,
                        ),
                      )
                    : _proofItemBalanced(
                        context,
                        chips[i].$1,
                        chips[i].$2,
                        chips[i].$3,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Three-up strip on narrow screens: icon on top, copy centered (desktop-like, compact).
  Widget _proofItemCompact(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    required bool isMobile,
  }) {
    final p = context.portfolio;
    final iconBox = isMobile ? 32.0 : 36.0;
    final titleSize = isMobile ? 11.5 : 11.0;
    final valueSize = isMobile ? 11.0 : 10.5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconBox,
          height: iconBox,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF3B82F6).withValues(alpha: 0.14),
            border: Border.all(
              color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF60A5FA),
            size: isMobile ? 17 : 19,
          ),
        ),
        SizedBox(height: isMobile ? 7 : 8),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: p.textPrimary,
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        SizedBox(height: isMobile ? 3 : 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: p.textMuted,
            fontSize: valueSize,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  /// Desktop only: each [Expanded] column uses full width — icon + text align the same in all three cells.
  Widget _proofItemBalanced(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final p = context.portfolio;
    const iconSize = 36.0;
    const gap = 10.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF3B82F6).withValues(alpha: 0.14),
              border: Border.all(
                color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF60A5FA),
              size: 20,
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: p.textPrimary,
                    fontSize: PortfolioFontSizes.secondary,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: p.textMuted,
                    fontSize: PortfolioFontSizes.label,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(BuildContext context, bool isMobile) {
    final p = context.portfolio;
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
          color: p.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: p.border),
        ),
        child: isMobile
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(context, 3, '', 'Live Store\nApps', isMobile),
                      _divider(context),
                      _statItem(context, 2, '', 'In Release\nPipeline', isMobile),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(context, 12, '+', 'Projects\n& Demos', isMobile),
                      _divider(context),
                      _statItem(context, 1, '', 'Hackathon\nAward', isMobile),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(context, 3, '', 'Live Store\nApps', isMobile),
                  _divider(context),
                  _statItem(context, 2, '', 'In Release\nPipeline', isMobile),
                  _divider(context),
                  _statItem(context, 12, '+', 'Projects\n& Demos', isMobile),
                  _divider(context),
                  _statItem(context, 1, '', 'Hackathon\nAward', isMobile),
                ],
              ),
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    int target,
    String suffix,
    String label,
    bool isMobile,
  ) {
    final p = context.portfolio;
    return Column(
      children: [
        CounterNumber(
          key: ValueKey('counter_$target$label'),
          target: target,
          suffix: suffix,
          style: TextStyle(
            fontSize: isMobile ? 28 : 42,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 11 : 13,
            color: p.textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) => Container(
    width: 1,
    height: 50,
    color: context.portfolio.border,
  );

  Widget _footer(BuildContext context, bool isMobile) {
    final p = context.portfolio;
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      child: Center(
        child: Column(
          children: [
            Text(
              'Built with Flutter for production-quality delivery',
              style: TextStyle(
                color: p.textMuted,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2026 Phyo Wai Kyaw. All rights reserved.',
              style: TextStyle(
                color: p.textMuted.withValues(alpha: 0.8),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                HoverButton(
                  label: 'View Work',
                  icon: Icons.folder_open_outlined,
                  isMobile: isMobile,
                  filled: false,
                  accent: true,
                  onTap: () => context.go('/work?section=apps'),
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
            ),
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
  final FaIconData icon;
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
