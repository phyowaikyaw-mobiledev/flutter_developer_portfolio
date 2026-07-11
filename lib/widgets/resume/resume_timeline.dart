import 'package:flutter/material.dart';
import '../../models/production_app.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class ResumeTimelineSection extends StatelessWidget {
  const ResumeTimelineSection({
    super.key,
    required this.icon,
    required this.title,
    required this.entries,
  });

  final IconData icon;
  final String title;
  final List<ResumeTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: p.accentTeal),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: p.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...entries,
      ],
    );
  }
}

class ResumeTimelineEntry extends StatelessWidget {
  const ResumeTimelineEntry({
    super.key,
    required this.child,
    this.isLast = false,
  });

  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.accentTeal,
                    border: Border.all(
                      color: p.accentTeal.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 4, left: 5),
                  width: 2,
                  height: 28,
                  color: p.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: child,
          ),
        ),
      ],
    );
  }
}

class ResumeOrgHeader extends StatelessWidget {
  const ResumeOrgHeader({
    super.key,
    required this.logoAsset,
    required this.orgName,
    required this.subtitle,
    required this.period,
    this.trailing,
    this.subtitleTrailing,
  });

  final String logoAsset;
  final String orgName;
  final String subtitle;
  final String period;
  final Widget? trailing;
  final Widget? subtitleTrailing;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            logoAsset,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 40,
              height: 40,
              color: p.background,
              child: Icon(Icons.business_outlined, size: 20, color: p.textMuted),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      orgName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: p.textPrimary,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.secondary,
                        color: p.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (subtitleTrailing != null) ...[
                    const SizedBox(width: 8),
                    subtitleTrailing!,
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                period,
                style: TextStyle(fontSize: PortfolioFontSizes.label, color: p.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ResumeSectionLabel extends StatelessWidget {
  const ResumeSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: PortfolioFontSizes.caption,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: p.textMuted,
        ),
      ),
    );
  }
}

class ResumeEvidenceButton extends StatelessWidget {
  const ResumeEvidenceButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.description_outlined,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: p.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: p.accentTeal.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: p.accentTeal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      fontWeight: FontWeight.w600,
                      color: p.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 12, color: p.accentTeal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResumeCertRoadmapEntry extends StatelessWidget {
  const ResumeCertRoadmapEntry({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.onView,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final String date;
  final VoidCallback onView;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.accentTeal.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.accentTeal,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 4, left: 6),
                  width: 2,
                  height: 72,
                  color: p.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      fontWeight: FontWeight.w700,
                      color: p.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.label,
                      color: p.textMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: PortfolioFontSizes.caption, color: p.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onView,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: p.accentTeal,
                        side: BorderSide(color: p.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'View',
                        style: TextStyle(
                          fontSize: PortfolioFontSizes.label,
                          fontWeight: FontWeight.w600,
                        ),
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
}

class ResumeShippedRows extends StatelessWidget {
  const ResumeShippedRows({
    super.key,
    required this.row1,
    required this.row2,
  });

  final List<ProductionApp> row1;
  final List<ProductionApp> row2;

  Widget _row(List<ProductionApp> apps) {
    return Row(
      children: [
        for (var i = 0; i < apps.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: ResumeShippedChip(app: apps[i], expanded: true)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(row1),
        const SizedBox(height: 8),
        _row(row2),
      ],
    );
  }
}

class ResumeShippedChip extends StatelessWidget {
  const ResumeShippedChip({
    super.key,
    required this.app,
    this.expanded = false,
  });

  final ProductionApp app;
  final bool expanded;

  String get _shortTitle {
    final t = app.title;
    if (t.contains('Phone King Plus Customer')) return 'PK Customer';
    if (t.contains('Phone King Plus Admin')) return 'PK Admin';
    if (t.contains('DrZon')) return 'DrZon Medical Service';
    if (t.contains('TeeXpress')) return 'TeeXpress';
    if (t.contains('PAN Aesthetic')) return 'PAN Aesthetic';
    if (t.contains('VIE Pharma')) return 'VIE Pharma';
    return t.split(' ').take(2).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Container(
      width: expanded ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (app.iconAsset != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    app.iconAsset!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(app.icon, size: 18, color: p.textMuted),
                  ),
                )
              else
                Icon(app.icon, size: 18, color: p.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _shortTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: PortfolioFontSizes.caption,
                    fontWeight: FontWeight.w600,
                    color: p.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: app.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  app.releaseStatus.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, color: app.statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResumeOngoingBadge extends StatelessWidget {
  const ResumeOngoingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.activeGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.activeGreen.withValues(alpha: 0.4),
        ),
      ),
      child: const Text(
        'Ongoing',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.activeGreen,
        ),
      ),
    );
  }
}

class ResumeBulletList extends StatelessWidget {
  const ResumeBulletList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final point in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: p.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      color: p.textMuted,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
