import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

/// Architecture case study for senior engineer review.
class CaseStudyScreen extends StatelessWidget {
  const CaseStudyScreen({super.key, this.embeddedInWork = false});

  final bool embeddedInWork;

  static const _accent = Color(0xFF14B8A6);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final body = SingleChildScrollView(
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: embeddedInWork
              ? (isMobile ? 20 : 28)
              : (isMobile ? 80 : 100),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: 'How I Build',
                  isMobile: isMobile,
                  subtitle:
                      'Architecture decisions behind DrZon Medical Service — a production healthcare app shipped to both stores.',
                ),
                SizedBox(height: isMobile ? 20 : 28),
                RevealAnimator(
                  child: _problemCard(isMobile),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                RevealAnimator(
                  delay: const Duration(milliseconds: 80),
                  child: _layerCard(isMobile),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                RevealAnimator(
                  delay: const Duration(milliseconds: 120),
                  child: _decisionsCard(isMobile),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                RevealAnimator(
                  delay: const Duration(milliseconds: 160),
                  child: _releaseCard(isMobile),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (embeddedInWork) {
      return ColoredBox(color: AppColors.background, child: body);
    }
    return Scaffold(backgroundColor: AppColors.background, body: body);
  }

  Widget _problemCard(bool isMobile) {
    return ShimmerCard(
      glowColor: _accent,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Problem',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deliver patient-facing healthcare flows for Myanmar and English — hospital referrals, medical records, appointments, and localized content — with maintainable modules ready for long-term feature growth.',
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _layerCard(bool isMobile) {
    const layers = [
      ('Presentation', 'Flutter widgets, navigation, responsive layouts'),
      ('State', 'BLoC / Cubit for feature-level state and side effects'),
      ('Domain', 'Repository interfaces and use-case boundaries'),
      ('Data', 'Dio REST client, DTO mapping, error handling'),
      ('l10n', 'ARB-based localization for MM/English market content'),
    ];

    return ShimmerCard(
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layered architecture',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          for (final layer in layers) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: '${layer.$1}: ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: layer.$2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _decisionsCard(bool isMobile) {
    const items = [
      'Repository pattern keeps API changes isolated from UI widgets.',
      'Dio interceptors centralize auth headers, timeouts, and error mapping.',
      'Feature modules grouped by domain (appointments, records, referrals) for review-friendly PRs.',
      'Localization extracted to ARB files — content updates without widget rewrites.',
      'Unit tests on production app data models and release configuration.',
    ];

    return ShimmerCard(
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Engineering decisions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 15,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.white.withValues(alpha: 0.78),
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
    );
  }

  Widget _releaseCard(bool isMobile) {
    return ShimmerCard(
      glowColor: _accent,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Release checklist',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Store builds validated on Android and iOS · l10n strings reviewed for MM/English · API error states handled in patient flows · code reviewed under senior-led sprint standards before release.',
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
