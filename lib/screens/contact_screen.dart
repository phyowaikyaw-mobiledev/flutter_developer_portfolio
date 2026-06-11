import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/reveal_animator.dart';
import '../utils/constants.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const _emailPrimary = Color(0xFF3B82F6);
  static const _emailSecondary = Color(0xFF60A5FA);
  static const _phonePrimary = Color(0xFF10B981);
  static const _phoneSecondary = Color(0xFF34D399);
  static const _githubPrimary = Color(0xFF64748B);
  static const _githubSecondary = Color(0xFF94A3B8);
  static const _linkedinPrimary = Color(0xFF0A66C2);
  static const _linkedinSecondary = Color(0xFF378FE9);

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openGmail() {
    const email = AppStrings.email;
    const subject = 'Portfolio Contact - Flutter Developer Opportunity';
    const body =
        'Hello Phyo Wai Kyaw,\n\nI came across your portfolio and would like to connect with you.\n\nBest regards,';
    _launch(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 80 : 100,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface,
                const Color(0xFF1E293B).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.purple.withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Professional Contact',
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 15 : 20),
                  SectionTitle(
                    title: 'Get In Touch',
                    isMobile: isMobile,
                    subtitle:
                        'Email and professional links — no inquiry form. Open to Flutter roles and product-focused teams.',
                  ),
                  const SizedBox(height: 14),
                  _credibilityChips(isMobile),
                  SizedBox(height: isMobile ? 30 : 40),
                  isMobile ? _mobileLayout(isMobile) : _desktopLayout(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _credibilityChips(bool isMobile) {
    final chips = [
      (Icons.location_on_outlined, 'Based in Chonburi, Thailand'),
      (Icons.public_outlined, 'Open to remote / hybrid roles'),
      (Icons.schedule_outlined, 'Typical response: within 24 hours'),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (chip) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 14,
                vertical: isMobile ? 7 : 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip.$1,
                    color: const Color(0xFF93C5FD),
                    size: isMobile ? 13 : 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    chip.$2,
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: const Color(0xFF93C5FD),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _desktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              RevealAnimator(
                child: _contactCard(
                  Icons.email_outlined,
                  'Email',
                  AppStrings.email,
                  'Drop me an email anytime',
                  _openGmail,
                  _emailPrimary,
                  _emailSecondary,
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(height: 16),
              RevealAnimator(
                delay: const Duration(milliseconds: 80),
                child: _contactCard(
                  Icons.phone_outlined,
                  'Phone',
                  AppStrings.phone,
                  'Call me directly',
                  () => _launch(AppStrings.phoneTel),
                  _phonePrimary,
                  _phoneSecondary,
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(height: 16),
              RevealAnimator(
                delay: const Duration(milliseconds: 160),
                child: Row(
                  children: [
                    Expanded(
                      child: _contactCard(
                        FontAwesomeIcons.github,
                        'GitHub',
                        'phyowaikyaw-mobiledev',
                        'Check out my projects',
                        () => _launch(AppStrings.github),
                        _githubPrimary,
                        _githubSecondary,
                        isFa: true,
                        isMobile: isMobile,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _contactCard(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        'phyowaikyaw-dev',
                        "Let's connect professionally",
                        () => _launch(AppStrings.linkedin),
                        _linkedinPrimary,
                        _linkedinSecondary,
                        isFa: true,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: RevealAnimator(
            delay: const Duration(milliseconds: 120),
            child: _opportunityCard(),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout(bool isMobile) {
    return Column(
      children: [
        RevealAnimator(
          child: _contactCard(
            Icons.email_outlined,
            'Email',
            AppStrings.email,
            'Drop me an email anytime',
            _openGmail,
            _emailPrimary,
            _emailSecondary,
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 15),
        RevealAnimator(
          delay: const Duration(milliseconds: 80),
          child: _contactCard(
            Icons.phone_outlined,
            'Phone',
            AppStrings.phone,
            'Call me directly',
            () => _launch(AppStrings.phoneTel),
            _phonePrimary,
            _phoneSecondary,
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 15),
        RevealAnimator(
          delay: const Duration(milliseconds: 120),
          child: _contactCard(
            FontAwesomeIcons.github,
            'GitHub',
            'phyowaikyaw-mobiledev',
            'Check out my projects',
            () => _launch(AppStrings.github),
            _githubPrimary,
            _githubSecondary,
            isFa: true,
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 15),
        RevealAnimator(
          delay: const Duration(milliseconds: 160),
          child: _contactCard(
            FontAwesomeIcons.linkedin,
            'LinkedIn',
            'phyowaikyaw-dev',
            "Let's connect professionally",
            () => _launch(AppStrings.linkedin),
            _linkedinPrimary,
            _linkedinSecondary,
            isFa: true,
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 20),
        RevealAnimator(
          delay: const Duration(milliseconds: 200),
          child: _opportunityCard(),
        ),
      ],
    );
  }

  Widget _contactCard(
    dynamic icon,
    String title,
    String value,
    String subtitle,
    VoidCallback onTap,
    Color primary,
    Color secondary, {
    bool isFa = false,
    required bool isMobile,
  }) {
    return _HoverCard(
      onTap: onTap,
      builder: (context, isHover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: isHover
              ? (Matrix4.identity()..translate(0.0, -3.0))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary.withValues(alpha: isHover ? 0.2 : 0.1),
                secondary.withValues(alpha: isHover ? 0.1 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primary.withValues(alpha: isHover ? 0.55 : 0.28),
              width: 1.5,
            ),
            boxShadow: isHover
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primary, secondary]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isHover
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ]
                      : [],
                ),
                child: isFa
                    ? FaIcon(icon as FaIconData, color: Colors.white, size: 24)
                    : Icon(icon as IconData, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHover
                    ? (Matrix4.identity()..translate(4.0, 0.0))
                    : Matrix4.identity(),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: primary.withValues(alpha: 0.8),
                  size: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _opportunityCard() {
    return _HoverCard(
      onTap: _openGmail,
      builder: (context, isHover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: isHover
              ? (Matrix4.identity()..translate(0.0, -3.0))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: isHover ? 0.25 : 0.15),
                AppColors.primaryLight.withValues(alpha: isHover ? 0.2 : 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isHover ? 0.65 : 0.4),
              width: 2,
            ),
            boxShadow: isHover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isHover ? 0.35 : 0.2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: AppColors.primaryLight,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Open to Opportunities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Currently open to roles and projects where I can deliver product value and continue growing as a Flutter engineer.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ...[
                'Flutter developer roles — 3 apps live on both stores',
                'Remote or hybrid collaboration opportunities',
                'Freelance product delivery engagements',
                'Long-term engineering growth environments',
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF93C5FD),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text(
                  'Preferred stack: Flutter, Firebase, Dio, BLoC, REST API',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openGmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Email Me',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isHover) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Opens Gmail with a pre-filled professional subject',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget Function(BuildContext, bool isHover) builder;
  final VoidCallback onTap;

  const _HoverCard({required this.builder, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(context, isHover),
      ),
    );
  }
}
