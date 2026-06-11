import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.embeddedInAbout = false});

  final bool embeddedInAbout;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final body = SingleChildScrollView(
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: embeddedInAbout
                ? (isMobile ? 20 : 28)
                : (isMobile ? 80 : 100),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SectionTitle(
                    title: 'Profile',
                    isMobile: isMobile,
                    subtitle:
                        'Product-minded Flutter developer focused on shipping reliable mobile experiences.',
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  _recruiterSnapshot(isMobile),
                  SizedBox(height: isMobile ? 20 : 30),
                  isMobile
                      ? Column(
                          children: [
                            _bioCard(isMobile),
                            const SizedBox(height: 20),
                            _infoCard(
                              'Professional Focus',
                              Icons.work_outline,
                              _focus,
                              isMobile,
                              delay: 100,
                            ),
                            const SizedBox(height: 15),
                            _infoCard(
                              'Strategic Direction',
                              Icons.trending_up_rounded,
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
                                    'Professional Focus',
                                    Icons.work_outline,
                                    _focus,
                                    isMobile,
                                    delay: 150,
                                  ),
                                  const SizedBox(height: 15),
                                  _infoCard(
                                    'Strategic Direction',
                                    Icons.trending_up_rounded,
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
    );

    if (embeddedInAbout) {
      return ColoredBox(color: AppColors.background, child: body);
    }
    return Scaffold(backgroundColor: AppColors.background, body: body);
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
              'Professional Summary',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            Text(
              'Flutter developer with production experience shipping apps to Google Play and the App Store — including DrZon Medical Service (healthcare) and Phone King Plus (retail loyalty).',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withValues(alpha: 0.84),
                height: 1.65,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 14),
            Text(
              'Strong in API integration, architecture discipline, and remote collaboration with engineering teams.',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withValues(alpha: 0.84),
                height: 1.65,
              ),
            ),
            SizedBox(height: isMobile ? 14 : 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _ProfilePill(label: 'Paid production since Jan 2026'),
                _ProfilePill(label: '3 apps live on both stores'),
                _ProfilePill(label: 'Remote sprint collaboration'),
                _ProfilePill(label: 'Hackathon Runner-up 2020'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recruiterSnapshot(bool isMobile) {
    final items = [
      ('Primary Role', 'Flutter Developer', Icons.badge_outlined),
      ('Experience', 'Paid prod · Jan 2026', Icons.timeline_outlined),
      ('Work Style', 'Remote collaboration', Icons.groups_2_outlined),
      ('Availability', 'Open to opportunities', Icons.event_available_outlined),
    ];

    return RevealAnimator(
      delay: const Duration(milliseconds: 60),
      child: Container(
        width: double.infinity,
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
              Colors.white.withValues(alpha: 0.055),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
          ),
        ),
        child: isMobile
            ? Column(
                children: items
                    .map(
                      (it) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _snapshotItem(it.$1, it.$2, it.$3 as IconData),
                      ),
                    )
                    .toList(),
              )
            : Row(
                children: items
                    .map(
                      (it) => Expanded(
                        child: _snapshotItem(it.$1, it.$2, it.$3 as IconData),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  Widget _snapshotItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFF93C5FD)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.58),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
    'Shipping store-ready Flutter features with review-ready PRs',
    'REST API integration with Dio and repository-layer discipline',
    'Remote sprint delivery with code reviews and senior-led standards',
    'Localization and maintainable module structure for product growth',
  ];
  static const _goal = [
    'Deliver reliable Flutter features for international product teams',
    'Ship documented API contracts and test-friendly module boundaries',
    'Contribute to team quality through reviews and consistent Git workflow',
    'Grow ownership of features from implementation through store release',
  ];
}

class _ProfilePill extends StatelessWidget {
  final String label;
  const _ProfilePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF93C5FD),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
