import 'package:flutter/material.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/tech_tag.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  SectionTitle(title: 'Profile', isMobile: isMobile),
                  SizedBox(height: isMobile ? 20 : 30),
                  isMobile
                      ? Column(
                          children: [
                            _bioCard(isMobile),
                            const SizedBox(height: 20),
                            _infoCard(
                              'Current Focus',
                              Icons.code,
                              _focus,
                              isMobile,
                              delay: 100,
                            ),
                            const SizedBox(height: 15),
                            _infoCard(
                              'Career Goal',
                              Icons.flag,
                              _goal,
                              isMobile,
                              delay: 200,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _bioCard(isMobile)),
                            const SizedBox(width: 40),
                            Expanded(
                              child: Column(
                                children: [
                                  _infoCard(
                                    'Current Focus',
                                    Icons.code,
                                    _focus,
                                    isMobile,
                                    delay: 150,
                                  ),
                                  const SizedBox(height: 15),
                                  _infoCard(
                                    'Career Goal',
                                    Icons.flag,
                                    _goal,
                                    isMobile,
                                    delay: 300,
                                  ),
                                ],
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

  Widget _bioCard(bool isMobile) {
    return RevealAnimator(
      child: ShimmerCard(
        glowColor: const Color(0xFF3B82F6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          ),
        ),
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello! I'm Phyo Wai Kyaw",
              style: TextStyle(
                fontSize: isMobile ? 22 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            Text(
              'Flutter Developer with 1+ year of production experience, building cross-platform mobile applications that ship to real users on Google Play & App Store. Proficient in Flutter, Dart, Firebase, REST APIs, and modern state management — writing clean, scalable code in Agile environments.',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.65,
              ),
            ),
            SizedBox(height: isMobile ? 14 : 18),
            Text(
              'Experienced in remote collaboration with distributed teams, delivering features independently while maintaining clear communication. Proven problem-solver — 1st Runner Up at Oway Travel Hackathon 2020 — and active tech community builder. Open to remote opportunities worldwide.',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.65,
              ),
            ),
            SizedBox(height: isMobile ? 20 : 28),
            Text(
              'Tech Stack:',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // FIX: clipBehavior: Clip.none — prevents Wrap from clipping
            // tag borders at row edges (especially bottom-left of new rows)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              clipBehavior: Clip.none,
              children: [
                'Flutter',
                'Dart',
                'Firebase',
                'GetX',
                'BLoC',
                'Provider',
                'Dio',
                'REST API',
                'Hive',
                'SQLite',
                'Git',
                'Postman',
              ].map((t) => TechTag(label: t, isMobile: isMobile)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    String title,
    IconData icon,
    List<String> pts,
    bool isMobile, {
    int delay = 0,
  }) {
    return RevealAnimator(
      delay: Duration(milliseconds: delay),
      child: ShimmerCard(
        glowColor: const Color(0xFF3B82F6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // FIX: wrap icon in OverflowBox so ShimmerCard's ClipRRect
                // (radius=20) cannot cut the icon box corners (radius=10).
                // The icon box sits fully inside the card padding so it is
                // visually unclipped while the card edge still clips correctly.
                UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      ),
                      // FIX: uniform borderRadius(10) on all corners — no clipping
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...pts.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _focus = [
    'Building production apps at Root Studio Asia',
    'REST API integration with Dio & Clean Architecture',
    'Localization (flutter_gen-l10n)',
    'Code reviews & Agile team workflow',
  ];
  static const _goal = [
    'Contributing to meaningful Flutter projects',
    'Continuous learning and professional growth',
    'Building scalable production-ready apps',
    'Team collaboration and knowledge sharing',
  ];
}
