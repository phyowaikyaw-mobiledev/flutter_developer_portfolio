import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/production_apps.dart';
import '../models/production_app.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/zeel_section_header.dart';
import '../widgets/common/zeel_text_filters.dart';

class PortfolioGridSection extends StatefulWidget {
  const PortfolioGridSection({super.key});

  @override
  State<PortfolioGridSection> createState() => _PortfolioGridSectionState();
}

class _PortfolioGridSectionState extends State<PortfolioGridSection> {
  static const _allFilter = 'All';

  static final _filters = [
    _allFilter,
    AppIndustry.retailCommerce.filterLabel,
    AppIndustry.logisticsSecurity.filterLabel,
    AppIndustry.healthcare.filterLabel,
  ];

  String _filter = _allFilter;

  List<ProductionApp> get _filtered {
    if (_filter == _allFilter) return kProductionApps;

    final industry = AppIndustry.values.firstWhere(
      (i) => i.filterLabel == _filter,
    );
    return kProductionApps.where((a) => a.industry == industry).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final apps = _filtered;
    final p = context.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(title: 'Portfolio'),
        const SizedBox(height: 16),
        ZeelTextFilters(
          options: _filters,
          selected: _filter,
          onSelected: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 12),
        Text(
          'Production Apps',
          style: TextStyle(
            fontSize: PortfolioFontSizes.label,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: p.textMuted,
          ),
        ),
        SizedBox(height: isMobile ? 16 : 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            mainAxisExtent: isMobile ? 218 : 238,
            mainAxisSpacing: isMobile ? 16 : 20,
            crossAxisSpacing: isMobile ? 14 : 18,
          ),
          itemCount: apps.length,
          itemBuilder: (_, i) => _AppIconTile(
            app: apps[i],
            isMobile: isMobile,
            onTap: () => context.push('/portfolio/${apps[i].slug}'),
          ),
        ),
      ],
    );
  }
}

class _AppIconTile extends StatefulWidget {
  const _AppIconTile({
    required this.app,
    required this.isMobile,
    required this.onTap,
  });

  final ProductionApp app;
  final bool isMobile;
  final VoidCallback onTap;

  static const _titleHeight = 34.0;
  static const _badgeHeight = 26.0;
  static const _iconRadius = 14.0;

  @override
  State<_AppIconTile> createState() => _AppIconTileState();
}

class _AppIconTileState extends State<_AppIconTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final hovered = _hovered && !widget.isMobile;
    final app = widget.app;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: p.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hovered
                  ? p.accentTeal.withValues(alpha: 0.65)
                  : p.border.withValues(alpha: 0.45),
            ),
            boxShadow: hovered
                ? [
                    BoxShadow(
                      color: p.accentTeal.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _iconSquare(p, app),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: _AppIconTile._titleHeight,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    app.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: p.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: _AppIconTile._badgeHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(
                    label: app.releaseStatus.label,
                    color: app.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconSquare(PortfolioColors p, ProductionApp app) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (app.fullBleedIcon)
          ClipRRect(
            borderRadius: BorderRadius.circular(_AppIconTile._iconRadius),
            child: app.iconAsset != null
                ? Image.asset(
                    app.iconAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      app.icon,
                      size: 40,
                      color: p.textMuted,
                    ),
                  )
                : Icon(app.icon, size: 40, color: p.textMuted),
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_AppIconTile._iconRadius),
              border: Border.all(color: p.border.withValues(alpha: 0.25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: app.iconAsset != null
                  ? Image.asset(
                      app.iconAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        app.icon,
                        size: 40,
                        color: p.textMuted,
                      ),
                    )
                  : Icon(app.icon, size: 40, color: p.textMuted),
            ),
          ),
        if (_hovered)
          AnimatedOpacity(
            opacity: _hovered ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(_AppIconTile._iconRadius),
              ),
              child: const Center(
                child: Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
