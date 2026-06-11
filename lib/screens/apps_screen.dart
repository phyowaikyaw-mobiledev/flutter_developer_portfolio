import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/production_apps.dart';
import '../models/production_app.dart';
import '../utils/constants.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/gallery_section.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key, this.embeddedInWork = false});

  /// When shown inside [WorkScreen] tabs, skip extra top inset (shell + tab bar).
  final bool embeddedInWork;

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final liveApps = kProductionApps
        .where((a) => a.releaseStatus == AppReleaseStatus.live)
        .toList();
    final launchingApps = kProductionApps
        .where(
          (a) =>
              a.releaseStatus == AppReleaseStatus.launchingSoon && !a.fullWidth,
        )
        .toList();
    final fullWidthLaunching = kProductionApps
        .where(
          (a) =>
              a.releaseStatus == AppReleaseStatus.launchingSoon && a.fullWidth,
        )
        .toList();

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
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                SectionTitle(
                  title: 'Production Apps',
                  isMobile: isMobile,
                  subtitle:
                      'Real products I helped ship for business users, with performance and maintainability in mind.',
                ),
                SizedBox(height: isMobile ? 28 : 40),
                _catLabel('Published & Live', Colors.green, isMobile),
                const SizedBox(height: 16),
                _appGrid(isMobile, liveApps),
                SizedBox(height: isMobile ? 28 : 36),
                _catLabel('Launching Soon', Colors.orange, isMobile),
                const SizedBox(height: 16),
                _appGrid(isMobile, launchingApps),
                for (final app in fullWidthLaunching) ...[
                  SizedBox(height: isMobile ? 16 : 20),
                  RevealAnimator(
                    delay: const Duration(milliseconds: 100),
                    child: _AppCard(
                      app: app,
                      isMobile: isMobile,
                      launch: _launch,
                    ),
                  ),
                ],
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

  Widget _catLabel(String label, Color color, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(height: 1, color: color.withValues(alpha: 0.2)),
        ),
      ],
    );
  }

  Widget _appGrid(bool isMobile, List<ProductionApp> apps) {
    if (apps.isEmpty) return const SizedBox.shrink();

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < apps.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _AppCard(app: apps[i], isMobile: isMobile, launch: _launch),
          ],
        ],
      );
    }

    if (apps.length == 1) {
      return _AppCard(app: apps[0], isMobile: isMobile, launch: _launch);
    }

    if (apps.length == 2 || apps.length == 3) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < apps.length; i++) ...[
              if (i > 0) SizedBox(width: apps.length == 3 ? 16 : 20),
              Expanded(
                child: _AppCard(
                  app: apps[i],
                  isMobile: isMobile,
                  launch: _launch,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < apps.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _AppCard(app: apps[i], isMobile: isMobile, launch: _launch),
        ],
      ],
    );
  }
}

class _AppCard extends StatefulWidget {
  final ProductionApp app;
  final bool isMobile;
  final void Function(String) launch;

  const _AppCard({
    required this.app,
    required this.isMobile,
    required this.launch,
  });

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _showGallery = false;

  ProductionApp get app => widget.app;
  bool get isMobile => widget.isMobile;

  @override
  Widget build(BuildContext context) {
    return RevealAnimator(
      child: ShimmerCard(
        glowColor: app.statusColor,
        enableEffects: true,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.07),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: app.statusColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: app.iconAsset != null
                      ? Image.asset(
                          app.iconAsset!,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _iconFallback(),
                        )
                      : _iconFallback(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.title,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          StatusBadge(
                            label: app.isLive ? 'Live' : 'Launching Soon',
                            color: app.statusColor,
                          ),
                          StatusBadge(
                            label: app.role,
                            color: AppColors.primary,
                          ),
                          if (app.companyBadge != null)
                            CompanyBadge(label: app.companyBadge!),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (app.keyContribution != null) ...[
              const SizedBox(height: 12),
              Text(
                app.keyContribution!,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              app.description,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.55,
              ),
            ),
            if (app.impact != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.insights_rounded,
                        color: AppColors.primaryLight,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        app.impact!,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,
                          color: Colors.white.withValues(alpha: 0.84),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: app.tags.map((t) => _techTag(t)).toList(),
            ),
            if (app.isLive) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  if (app.playUrl != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => widget.launch(app.playUrl!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text(
                          'Play Store',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    if (app.appStoreUrl != null) const SizedBox(width: 10),
                  ],
                  if (app.appStoreUrl != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => widget.launch(app.appStoreUrl!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryLight,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.apple, size: 16),
                        label: const Text(
                          'App Store',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (app.gallery.isNotEmpty) ...[
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: () => setState(() => _showGallery = !_showGallery),
                icon: Icon(
                  _showGallery
                      ? Icons.expand_less
                      : Icons.photo_library_outlined,
                  size: 16,
                ),
                label: Text(
                  _showGallery
                      ? 'Hide screenshots'
                      : 'View screenshots (${app.gallery.length})',
                  style: const TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                ),
              ),
              if (_showGallery) ...[
                const SizedBox(height: 8),
                GallerySection(
                  images: app.gallery,
                  accentColor: app.statusColor,
                  isMobile: isMobile,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _iconFallback() => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDark, AppColors.primary],
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(app.icon, color: Colors.white, size: 26),
  );

  Widget _techTag(String tag) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.primaryDark.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
    ),
    child: Text(
      tag,
      style: TextStyle(fontSize: isMobile ? 12 : 13, color: Colors.white),
    ),
  );
}
