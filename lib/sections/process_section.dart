import 'package:flutter/material.dart';
import '../data/process_steps.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/common/zeel_section_header.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(
          title: 'How I Ship Apps',
          subtitle:
              'Four steps I follow on every production app — from first brief to store listing.',
        ),
        SizedBox(height: isMobile ? 24 : 32),
        if (isMobile)
          const _MobileTimeline()
        else
          const _DesktopTimeline(),
      ],
    );
  }
}

class _DesktopTimeline extends StatelessWidget {
  const _DesktopTimeline();

  static const _badgeSize = 40.0;
  static const _columnPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Stack(
      children: [
        Positioned(
          left: _columnPadding + _badgeSize / 2,
          right: _columnPadding + _badgeSize / 2,
          top: _badgeSize / 2 - 1,
          child: Container(height: 2, color: p.border),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < kProcessSteps.length; i++)
                Expanded(
                  child: _DesktopStepColumn(
                    step: kProcessSteps[i],
                    colors: p,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopStepColumn extends StatelessWidget {
  const _DesktopStepColumn({
    required this.step,
    required this.colors,
  });

  final ProcessStep step;
  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: _DesktopTimeline._columnPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NumberCircle(number: step.number),
          const SizedBox(height: 20),
          Icon(step.icon, size: 22, color: AppColors.accentTeal),
          const SizedBox(height: 12),
          Text(
            step.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            maxLines: 3,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: colors.textMuted,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileTimeline extends StatelessWidget {
  const _MobileTimeline();

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Column(
      children: [
        for (var i = 0; i < kProcessSteps.length; i++) ...[
          if (i > 0) const SizedBox(height: 20),
          _MobileStepRow(
            step: kProcessSteps[i],
            colors: p,
            isLast: i == kProcessSteps.length - 1,
          ),
        ],
      ],
    );
  }
}

class _NumberCircle extends StatelessWidget {
  const _NumberCircle({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final label = number.toString().padLeft(2, '0');

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentTeal.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: PortfolioFontSizes.secondary,
          fontWeight: FontWeight.w700,
          color: AppColors.accentTeal,
        ),
      ),
    );
  }
}

class _MobileStepRow extends StatelessWidget {
  const _MobileStepRow({
    required this.step,
    required this.colors,
    required this.isLast,
  });

  final ProcessStep step;
  final PortfolioColors colors;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                _NumberCircle(number: step.number),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: colors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(step.icon, size: 22, color: AppColors.accentTeal),
                  const SizedBox(height: 10),
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      color: colors.textMuted,
                      height: 1.55,
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
}
