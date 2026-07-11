import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/production_apps.dart';
import '../models/production_app.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/tech_tag.dart';
import '../widgets/work/store_platform_badges.dart';

class ProductionAppDetailScreen extends StatelessWidget {
  const ProductionAppDetailScreen({super.key, required this.slug});

  final String slug;

  ProductionApp? get _app => productionAppBySlug(slug);

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final app = _app;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    if (app == null) {
      return Scaffold(
        backgroundColor: p.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Project not found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: p.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/?section=portfolio'),
                child: const Text('Back to Portfolio'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: p.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, p),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 48,
                  vertical: isMobile ? 16 : 32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: isMobile
                        ? _mobileLayout(context, p, app)
                        : _desktopLayout(context, p, app),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, PortfolioColors p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/?section=portfolio'),
            icon: Icon(Icons.arrow_back, color: p.textPrimary),
            tooltip: 'Back to Portfolio',
          ),
          Text(
            'Portfolio',
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: p.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout(
    BuildContext context,
    PortfolioColors p,
    ProductionApp app,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 220, child: _heroCard(p, app, isMobile: false)),
        const SizedBox(width: 40),
        Expanded(child: _detailBody(context, p, app, isMobile: false)),
      ],
    );
  }

  Widget _mobileLayout(
    BuildContext context,
    PortfolioColors p,
    ProductionApp app,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroCard(p, app, isMobile: true),
        const SizedBox(height: 28),
        _detailBody(context, p, app, isMobile: true),
      ],
    );
  }

  Widget _heroCard(PortfolioColors p, ProductionApp app, {required bool isMobile}) {
    final iconSize = isMobile ? 72.0 : 80.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _appIcon(p, app, size: iconSize),
        const SizedBox(height: 14),
        Text(
          app.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusBadge(label: app.releaseStatus.label, color: app.statusColor),
            if (app.companyBadge != null) CompanyBadge(label: app.companyBadge!),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          app.role,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textMuted,
          ),
        ),
        const SizedBox(height: 16),
        StorePlatformBadges(
          playUrl: app.playUrl,
          appStoreUrl: app.appStoreUrl,
          releaseStatus: app.releaseStatus,
          onLaunch: _launch,
        ),
      ],
    );
  }

  Widget _appIcon(PortfolioColors p, ProductionApp app, {required double size}) {
    const radius = 16.0;

    if (app.fullBleedIcon && app.iconAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          app.iconAsset!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(app.icon, size: size * 0.5, color: p.textMuted),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: p.border.withValues(alpha: 0.35)),
      ),
      padding: EdgeInsets.all(size * 0.16),
      child: app.iconAsset != null
          ? Image.asset(
              app.iconAsset!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(app.icon, size: size * 0.45, color: p.textMuted),
            )
          : Icon(app.icon, size: size * 0.45, color: p.textMuted),
    );
  }

  Widget _detailBody(
    BuildContext context,
    PortfolioColors p,
    ProductionApp app, {
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(p, 'Overview', app.description),
        if (app.keyContributionPoints != null &&
            app.keyContributionPoints!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _bulletSection(p, 'My Contribution', app.keyContributionPoints!),
        ] else if (app.keyContribution != null) ...[
          const SizedBox(height: 24),
          _section(p, 'My Contribution', app.keyContribution!),
        ],
        if (app.impact != null) ...[
          const SizedBox(height: 24),
          _section(p, 'Impact', app.impact!),
        ],
        const SizedBox(height: 24),
        Text(
          'Tech Stack',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: app.tags
              .map((t) => TechTag(label: t, isMobile: isMobile))
              .toList(),
        ),
        if (app.challenges != null && app.challenges!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _challengesSection(p, app.challenges!),
        ],
        if (app.keyFeatures != null && app.keyFeatures!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _bulletSection(p, 'Key Features', app.keyFeatures!),
        ],
        if (app.gallery.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(
            'Screenshots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: isMobile ? 360 : 420,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: app.gallery.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: p.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    app.gallery[i],
                    height: isMobile ? 360 : 420,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => SizedBox(
                      width: 200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: p.textMuted,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _section(PortfolioColors p, String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _bulletSection(PortfolioColors p, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 10),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: p.accentTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      color: p.textMuted,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _challengesSection(
    PortfolioColors p,
    List<ProductionAppChallenge> challenges,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenges & Solutions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...challenges.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.title,
                  style: TextStyle(
                    fontSize: PortfolioFontSizes.secondary,
                    fontWeight: FontWeight.w600,
                    color: p.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  c.solution,
                  style: TextStyle(
                    fontSize: PortfolioFontSizes.secondary,
                    color: p.textMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
