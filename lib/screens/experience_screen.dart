import 'package:flutter/material.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/tech_tag.dart';
import '../widgets/carousel_dialog.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 80 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SectionTitle(
                    title: 'Professional Experience',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  RevealAnimator(
                    child: _ExpCard(
                      title: 'Junior Flutter Developer',
                      company: 'Root Studio Asia — Yangon, Myanmar (Remote)',
                      period: 'Jan 2026 – Present',
                      points: const [
                        'Building production-grade mobile applications used by real users',
                        'Developing and maintaining notification system with REST API integration using Dio',
                        'Implementing clean architecture with repository pattern and l10n localization',
                        'Collaborating in code reviews with senior developer following Agile workflow',
                        'Integrating Firebase services and managing app state with modern solutions',
                        'Writing clean, well-documented, maintainable Dart/Flutter code',
                      ],
                      tags: const [
                        'Flutter',
                        'Dart',
                        'Dio',
                        'REST API',
                        'Firebase',
                        'Clean Architecture',
                        'l10n',
                        'Git',
                      ],
                      icon: Icons.work,
                      logoAsset: 'assets/images/rootstudio_logo.jpg',
                      isMobile: isMobile,
                      accentColor: const Color(0xFF3B82F6),
                    ),
                  ),
                  SizedBox(height: isMobile ? 15 : 20),
                  RevealAnimator(
                    delay: const Duration(milliseconds: 150),
                    child: _ExpCard(
                      title: 'Flutter Developer — Self-Study & Mentorship',
                      company:
                          'Senior Developer Mentorship + Independent Projects',
                      period: '2024 – 2025',
                      points: const [
                        'Learned Flutter & Dart under structured guidance of a senior developer',
                        'Built 12+ personal projects independently — e-commerce, LMS, healthcare, social media UI and more',
                        'Practiced state management solutions (GetX, BLoC, Provider) through real project implementations',
                        'Studied Clean Architecture, REST API integration, and Firebase services hands-on',
                        'Regular code reviews with senior developer to improve code quality and best practices',
                        'Grew from beginner to production-ready developer through disciplined self-learning',
                      ],
                      tags: const [
                        'Flutter',
                        'Dart',
                        'Firebase',
                        'GetX',
                        'BLoC',
                        'Clean Architecture',
                        'REST API',
                        'Self-Learning',
                      ],
                      icon: Icons.menu_book,
                      isMobile: isMobile,
                      accentColor: const Color(0xFF7C3AED),
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 60),
                  SectionTitle(
                    title: 'Education & Certifications',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 6 : 10),
                  Text(
                    'Academic background and professional credentials',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 36),
                  isMobile
                      ? Column(
                          children: [
                            RevealAnimator(child: _UniCard(isMobile: isMobile)),
                            const SizedBox(height: 20),
                            RevealAnimator(
                              delay: const Duration(milliseconds: 120),
                              child: _KMDCard(isMobile: isMobile),
                            ),
                            const SizedBox(height: 20),
                            RevealAnimator(
                              delay: const Duration(milliseconds: 240),
                              child: _WebDevCard(isMobile: isMobile),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RevealAnimator(
                                child: _UniCard(isMobile: isMobile),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: RevealAnimator(
                                delay: const Duration(milliseconds: 100),
                                child: _KMDCard(isMobile: isMobile),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RevealAnimator(
                                delay: const Duration(milliseconds: 200),
                                child: _WebDevCard(isMobile: isMobile),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Experience Card ───────────────────────────────────────────────────────────
class _ExpCard extends StatelessWidget {
  final String title, company, period;
  final List<String> points, tags;
  final IconData icon;
  final String? logoAsset;
  final bool isMobile;
  final Color accentColor;

  const _ExpCard({
    required this.title,
    required this.company,
    required this.period,
    required this.points,
    required this.tags,
    required this.icon,
    required this.isMobile,
    required this.accentColor,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerCard(
      glowColor: accentColor,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: logoAsset != null
                    ? Image.asset(
                        logoAsset!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _iconBox(accentColor),
                      )
                    : _iconBox(accentColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.6)),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...points.map(
            (pt) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pt,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((t) => TechTag(label: t, isMobile: isMobile))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _iconBox(Color color) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: Colors.white, size: 26),
  );
}

// ── Education shared helpers ──────────────────────────────────────────────────

Widget _logoBox(String asset) => Container(
  width: 72,
  height: 72,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
        child: const Icon(Icons.school, color: Color(0xFF3B82F6), size: 36),
      ),
    ),
  ),
);

Widget _dateRow(String t) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      Icons.calendar_today_outlined,
      size: 12,
      color: Colors.white.withValues(alpha: 0.35),
    ),
    const SizedBox(width: 4),
    Text(
      t,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withValues(alpha: 0.45),
      ),
    ),
  ],
);

Widget _pill(String label, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: color.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: color.withValues(alpha: 0.5)),
  ),
  child: Text(
    label,
    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
  ),
);

Widget _checkItem(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 7),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(
        Icons.check_circle_outline,
        size: 14,
        color: Color(0xFF3B82F6),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    ],
  ),
);

// ── University Card ───────────────────────────────────────────────────────────
class _UniCard extends StatelessWidget {
  final bool isMobile;

  const _UniCard({required this.isMobile});

  static const _accent = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return ShimmerCard(
      glowColor: _accent,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/computer_university.jpg'),
          const SizedBox(height: 14),
          const Text(
            'University of Computer, Mandalay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Computer Science Major',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow('2018 – 2021'),
          const SizedBox(height: 8),
          _pill('2nd Year Completed', _accent),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 13,
                  color: Colors.orange.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Studies paused due to COVID-19 and Myanmar's political situation.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          ...[
            'Data Structures & Algorithms',
            'Database Management Systems',
            'Software Engineering Principles',
            'Object-Oriented Programming',
            'Computer Architecture',
            'Web Development Foundations',
          ].map(_checkItem),
        ],
      ),
    );
  }
}

// ── KMD Card ──────────────────────────────────────────────────────────────────
class _KMDCard extends StatelessWidget {
  final bool isMobile;

  const _KMDCard({required this.isMobile});

  static const _accent = Color(0xFFFFD700);

  static const _certs = [
    {
      'title': 'Software Engineering — VB.Net',
      'image': 'assets/images/cert_se.jpg',
    },
    {
      'title': 'Problem Solving with Programming',
      'image': 'assets/images/cert_ps.jpg',
    },
    {
      'title': 'Practical A+ Hardware & Networking',
      'image': 'assets/images/cert_hw.jpg',
    },
    {
      'title': 'Microsoft PowerPoint Advanced',
      'image': 'assets/images/cert_ppt.jpg',
    },
    {'title': 'Computer Basic', 'image': 'assets/images/cert_basic.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final allImages = _certs.map((c) => c['image']!).toList();
    return ShimmerCard(
      glowColor: _accent,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: 0.07),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/kmd_logo.jpg'),
          const SizedBox(height: 14),
          const Text(
            'KMD Education Center',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Technical Certifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow('Multiple Dates'),
          const SizedBox(height: 8),
          _pill('5 Certificates', _accent),
          const SizedBox(height: 20),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 170,
            ),
            itemCount: _certs.length,
            itemBuilder: (ctx, i) => _CertCard(
              title: _certs[i]['title']!,
              imagePath: _certs[i]['image']!,
              onTap: () => showDialog(
                context: ctx,
                barrierColor: Colors.black.withValues(alpha: 0.92),
                builder: (_) =>
                    CarouselDialog(images: allImages, initialIndex: i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Web Dev Card ──────────────────────────────────────────────────────────────
class _WebDevCard extends StatelessWidget {
  final bool isMobile;

  const _WebDevCard({required this.isMobile});

  static const _accent = Colors.green;

  @override
  Widget build(BuildContext context) {
    return ShimmerCard(
      glowColor: _accent,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: 0.07),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/computer_university.jpg'),
          const SizedBox(height: 14),
          const Text(
            'University of Computer, Mandalay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Web Development Foundation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow('Certified'),
          const SizedBox(height: 8),
          _pill('Certified', _accent),
          const SizedBox(height: 14),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          ...[
            'HTML & CSS',
            'Bootstrap Framework',
            'JavaScript Fundamentals',
            'Responsive Web Design',
          ].map(_checkItem),
          const SizedBox(height: 16),
          _CertCard(
            title: 'Web Dev Foundation Certificate',
            imagePath: 'assets/images/cert_webdev.jpg',
            fullWidth: true,
            accentColor: _accent,
            onTap: () => showDialog(
              context: context,
              barrierColor: Colors.black.withValues(alpha: 0.92),
              builder: (_) => CarouselDialog(
                images: ['assets/images/cert_webdev.jpg'],
                initialIndex: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cert Card ─────────────────────────────────────────────────────────────────
class _CertCard extends StatefulWidget {
  final String title, imagePath;
  final VoidCallback onTap;
  final bool fullWidth;
  final Color accentColor;

  const _CertCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.fullWidth = false,
    this.accentColor = const Color(0xFF3B82F6),
  });

  @override
  State<_CertCard> createState() => _CertCardState();
}

class _CertCardState extends State<_CertCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _h ? -4 : 0, 0),
          height: widget.fullWidth ? 130 : null,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _h
                  ? widget.accentColor.withValues(alpha: 0.8)
                  : const Color(0xFF1E3A6E).withValues(alpha: 0.8),
              width: _h ? 1.5 : 1,
            ),
            boxShadow: _h
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                    ),
                  ]
                : [],
          ),
          child: widget.fullWidth
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
                      if (_h) _overlay(),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            ),
                            if (_h) _overlay(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A1020),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(11),
                        ),
                      ),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFF1E40AF).withValues(alpha: 0.2),
    child: Center(
      child: Icon(
        Icons.workspace_premium,
        color: const Color(0xFFFFD700).withValues(alpha: 0.6),
        size: 32,
      ),
    ),
  );

  Widget _overlay() => Container(
    color: Colors.black.withValues(alpha: 0.4),
    child: const Center(
      child: Icon(Icons.zoom_in_rounded, color: Colors.white, size: 28),
    ),
  );
}
