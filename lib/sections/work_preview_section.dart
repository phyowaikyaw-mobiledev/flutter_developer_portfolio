import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/production_apps.dart';
import '../models/production_app.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/common/zeel_section_header.dart';
import '../widgets/work/app_screenshot_preview.dart';
import '../widgets/work/store_platform_badges.dart';
import '../widgets/work/vertical_aware_horizontal_carousel.dart';

class WorkPreviewSection extends StatefulWidget {
  const WorkPreviewSection({super.key});

  @override
  State<WorkPreviewSection> createState() => _WorkPreviewSectionState();
}

class _WorkPreviewSectionState extends State<WorkPreviewSection> {
  double _scrollProgress = 0;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  double _cardWidth(double maxWidth, bool isMobile) {
    if (isMobile) return maxWidth * 0.78;
    return (maxWidth - 32) / 3.15;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final apps = kProductionApps;
    final separatorWidth = isMobile ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(
          title: "Here's Some Of My Work",
          subtitle:
              "Don't just take my word for it — here's a look at what I've built 🚀",
        ),
        SizedBox(height: isMobile ? 16 : 24),
        SizedBox(
          height: isMobile ? 540 : 580,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = _cardWidth(constraints.maxWidth, isMobile);
              return VerticalAwareHorizontalCarousel(
                itemExtent: cardWidth,
                separatorWidth: separatorWidth,
                itemCount: apps.length,
                onProgressChanged: (progress) {
                  if (progress != _scrollProgress) {
                    setState(() => _scrollProgress = progress);
                  }
                },
                itemBuilder: (_, i) => _PreviewCard(
                  app: apps[i],
                  onLaunch: _launch,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _progressBar(p),
      ],
    );
  }

  Widget _progressBar(PortfolioColors p) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: _scrollProgress,
        minHeight: 4,
        backgroundColor: p.border,
        color: p.accentTeal,
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.app,
    required this.onLaunch,
  });

  static const _descFontSize = PortfolioFontSizes.label;
  static const _descLineHeight = 1.5;
  static const _descLines = 5;
  static const _descHeight = _descFontSize * _descLineHeight * _descLines;
  static const _badgeRowHeight = 36.0;

  final ProductionApp app;
  final Future<void> Function(String url) onLaunch;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final screenshot = app.gallery.isNotEmpty ? app.gallery.first : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (app.iconAsset != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    app.iconAsset!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(app.icon, color: AppColors.primary),
                  ),
                )
              else
                Icon(app.icon, color: AppColors.primary, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      app.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                        color: p.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: _descHeight,
            child: Text(
              app.description,
              maxLines: _descLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _descFontSize,
                color: p.textMuted,
                height: _descLineHeight,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: _badgeRowHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StorePlatformBadges(
                playUrl: app.playUrl,
                appStoreUrl: app.appStoreUrl,
                releaseStatus: app.releaseStatus,
                onLaunch: onLaunch,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AppScreenshotPreview(imageAsset: screenshot),
          ),
        ],
      ),
    );
  }
}
