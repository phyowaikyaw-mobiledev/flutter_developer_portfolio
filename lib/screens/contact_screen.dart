import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/shimmer_card.dart';
import '../utils/constants.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
      backgroundColor: const Color(0xFF0A0E27),
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
                const Color(0xFF0F172A),
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
                          const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      "💬 Let's Connect",
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: const Color(0xFF60A5FA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 15 : 20),
                  SectionTitle(title: 'Get In Touch', isMobile: isMobile),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text(
                    "Have a project in mind or want to collaborate?\nLet's create something amazing together!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt,
                        color: Colors.amber,
                        size: isMobile ? 16 : 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Usually responds within 24 hours',
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 15,
                          color: Colors.amber.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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

  Widget _desktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _contactCard(
                Icons.email_outlined,
                'Email',
                AppStrings.email,
                'Drop me an email anytime',
                _openGmail,
                const Color(0xFF3B82F6),
                const Color(0xFF60A5FA),
              ),
              const SizedBox(height: 16),
              _contactCard(
                Icons.phone_outlined,
                'Phone',
                '+66-626-509163',
                'Call me directly',
                () => _launch('tel:+66626509163'),
                const Color(0xFF10B981),
                const Color(0xFF34D399),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _contactCard(
                      FontAwesomeIcons.github,
                      'GitHub',
                      'phyowaikyaw-mobiledev',
                      'Check out my projects',
                      () => _launch(AppStrings.github),
                      const Color(0xFF6366F1),
                      const Color(0xFF818CF8),
                      isFa: true,
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
                      const Color(0xFF8B5CF6),
                      const Color(0xFFA78BFA),
                      isFa: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _opportunityCard()),
      ],
    );
  }

  Widget _mobileLayout(bool isMobile) {
    return Column(
      children: [
        _contactCard(
          Icons.email_outlined,
          'Email',
          AppStrings.email,
          'Drop me an email anytime',
          _openGmail,
          const Color(0xFF3B82F6),
          const Color(0xFF60A5FA),
        ),
        const SizedBox(height: 15),
        _contactCard(
          Icons.phone_outlined,
          'Phone',
          '+66-626-509163',
          'Call me directly',
          () => _launch('tel:+66626509163'),
          const Color(0xFF10B981),
          const Color(0xFF34D399),
        ),
        const SizedBox(height: 15),
        _contactCard(
          FontAwesomeIcons.github,
          'GitHub',
          'phyowaikyaw-mobiledev',
          'Check out my projects',
          () => _launch(AppStrings.github),
          const Color(0xFF6366F1),
          const Color(0xFF818CF8),
          isFa: true,
        ),
        const SizedBox(height: 15),
        _contactCard(
          FontAwesomeIcons.linkedin,
          'LinkedIn',
          'phyowaikyaw-dev',
          "Let's connect professionally",
          () => _launch(AppStrings.linkedin),
          const Color(0xFF8B5CF6),
          const Color(0xFFA78BFA),
          isFa: true,
        ),
        const SizedBox(height: 20),
        _opportunityCard(),
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
  }) {
    return _HoverCard(
      onTap: onTap,
      builder: (context, isHover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: isHover
              ? (Matrix4.identity()
                  ..translate(0, -4)
                  ..scale(1.02))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(24),
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
              color: primary.withValues(alpha: isHover ? 0.6 : 0.3),
              width: 1.5,
            ),
            boxShadow: isHover
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primary, secondary]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isHover
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.6),
                            blurRadius: 16,
                          ),
                        ]
                      : [],
                ),
                child: isFa
                    ? FaIcon(icon as IconData, color: Colors.white, size: 28)
                    : Icon(icon as IconData, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
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
                    ? (Matrix4.identity()..translate(4, 0))
                    : Matrix4.identity(),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: primary.withValues(alpha: 0.8),
                  size: 18,
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
              ? (Matrix4.identity()
                  ..translate(0, -6)
                  ..scale(1.02))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(
                  0xFF3B82F6,
                ).withValues(alpha: isHover ? 0.25 : 0.15),
                const Color(
                  0xFF8B5CF6,
                ).withValues(alpha: isHover ? 0.25 : 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(
                0xFF3B82F6,
              ).withValues(alpha: isHover ? 0.7 : 0.4),
              width: 2,
            ),
            boxShadow: isHover
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
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
                  color: const Color(
                    0xFF3B82F6,
                  ).withValues(alpha: isHover ? 0.35 : 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Color(0xFF60A5FA),
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
                'Currently seeking exciting roles and projects where I can contribute and grow as a Flutter developer',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ...[
                '💼  Flutter Developer roles',
                '🌏  Remote work opportunities',
                '🚀  Freelance projects',
                '💻  Open-source contributions',
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openGmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
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
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
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
