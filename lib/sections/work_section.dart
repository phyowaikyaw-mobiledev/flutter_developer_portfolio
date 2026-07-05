import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/production_apps.dart';
import '../../models/production_app.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/common/gallery_section.dart';
import '../../widgets/common/zeel_section_header.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  String _filter = 'All';

  static const _filters = ['All', 'Live', 'Launching Soon'];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  List<ProductionApp> get _filtered {
    switch (_filter) {
      case 'Live':
        return kProductionApps
            .where((a) => a.releaseStatus == AppReleaseStatus.live)
            .toList();
      case 'Launching Soon':
        return kProductionApps
            .where((a) => a.releaseStatus.isUpcoming)
            .toList();
      default:
        return kProductionApps;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final apps = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(
          title: "Here's Some Of My Work",
          subtitle:
              "Don't just take my word for it — here's a look at what I've built 🚀",
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filters.map((f) => _filterChip(p, f)).toList(),
        ),
        SizedBox(height: isMobile ? 20 : 28),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.8 : 0.95,
          ),
          itemCount: apps.length,
          itemBuilder: (_, i) => _WorkCard(app: apps[i], onLaunch: _launch),
        ),
      ],
    );
  }

  Widget _filterChip(PortfolioColors p, String label) {
    final selected = _filter == label;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = label),
      backgroundColor: p.background,
      selectedColor: p.accentTeal.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: PortfolioFontSizes.label,
        color: selected ? p.textPrimary : p.textMuted,
      ),
      side: BorderSide(color: selected ? p.accentTeal : p.border),
      showCheckmark: false,
    );
  }
}

class _WorkCard extends StatefulWidget {
  const _WorkCard({required this.app, required this.onLaunch});

  final ProductionApp app;
  final Future<void> Function(String) onLaunch;

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _expanded = false;

  ProductionApp get app => widget.app;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isLive = app.isLive;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: app.iconAsset != null
                    ? Image.asset(
                        app.iconAsset!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _iconFallback(),
                      )
                    : _iconFallback(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: p.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mobile Applications',
                      style: TextStyle(fontSize: PortfolioFontSizes.caption, color: p.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: app.statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              app.releaseStatus.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: app.statusColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              app.description,
              maxLines: _expanded ? 20 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: PortfolioFontSizes.label,
                color: p.textMuted,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: app.tags
                .take(3)
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: p.border),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(fontSize: 10, color: p.textMuted),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (isLive && app.playUrl != null)
                _storeBtn(
                  p,
                  label: 'Play',
                  onTap: () => widget.onLaunch(app.playUrl!),
                ),
              if (isLive && app.playUrl != null && app.appStoreUrl != null)
                const SizedBox(width: 8),
              if (isLive && app.appStoreUrl != null)
                _storeBtn(
                  p,
                  label: 'iOS',
                  onTap: () => widget.onLaunch(app.appStoreUrl!),
                ),
              const Spacer(),
              if (app.gallery.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  style: TextButton.styleFrom(
                    foregroundColor: p.accentTeal,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _expanded ? 'Less' : 'More',
                    style: const TextStyle(fontSize: PortfolioFontSizes.label),
                  ),
                ),
            ],
          ),
          if (_expanded && app.gallery.isNotEmpty) ...[
            const SizedBox(height: 10),
            GallerySection(
              images: app.gallery,
              accentColor: AppColors.primary,
              isMobile: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconFallback() => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(app.icon, color: AppColors.primary, size: 24),
      );

  Widget _storeBtn(
    PortfolioColors p, {
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: p.accentTeal.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: PortfolioFontSizes.caption,
            fontWeight: FontWeight.w600,
            color: p.accentTeal,
          ),
        ),
      ),
    );
  }
}
