import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/career_milestones.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class MilestonesSection extends StatelessWidget {
  const MilestonesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🚀', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'Production Milestones',
              style: GoogleFonts.sourceSerif4(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: p.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 20 : 24),
        _summaryRow(p, isMobile),
        SizedBox(height: isMobile ? 24 : 28),
        ...kCareerMilestoneGroups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _groupCard(p, group, isMobile),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(PortfolioColors p, bool isMobile) {
    final items = [
      (kCareerMilestoneSummary.years, 'YEARS OF\nEXPERIENCE'),
      (kCareerMilestoneSummary.productionApps, 'PRODUCTION\nAPPS'),
      (kCareerMilestoneSummary.liveReleases, 'LIVE STORE\nRELEASES'),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _summaryItem(p, items[i].$1, items[i].$2),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(child: _summaryItem(p, items[i].$1, items[i].$2)),
        ],
      ],
    );
  }

  Widget _summaryItem(PortfolioColors p, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            fontWeight: FontWeight.w600,
            color: p.textMuted,
            letterSpacing: 1.1,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _groupCard(
    PortfolioColors p,
    CareerMilestoneGroup group,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.label,
                style: TextStyle(
                  fontSize: PortfolioFontSizes.secondary,
                  fontWeight: FontWeight.w600,
                  color: p.textMuted,
                  letterSpacing: 0.3,
                ),
              ),
              if (group.subtitle != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('·', style: TextStyle(color: p.textMuted)),
                ),
                Expanded(
                  child: Text(
                    group.subtitle!,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      fontWeight: FontWeight.w600,
                      color: p.accentTeal,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ...group.apps.map(
            (app) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _appRow(p, app),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appRow(PortfolioColors p, CareerMilestoneApp app) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: app.iconAsset != null
              ? Image.asset(
                  app.iconAsset!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _iconPlaceholder(p),
                )
              : _iconPlaceholder(p),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            app.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: p.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconPlaceholder(PortfolioColors p) {
    return Container(
      width: 36,
      height: 36,
      color: p.border,
      child: Icon(Icons.apps, size: 18, color: p.textMuted),
    );
  }
}
