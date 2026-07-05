import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

enum PortfolioSection { about, expertise, resume, portfolio, contact }

const kPillNavItems = <(String, PortfolioSection)>[
  ('About', PortfolioSection.about),
  ('Expertise', PortfolioSection.expertise),
  ('Resume', PortfolioSection.resume),
  ('Portfolio', PortfolioSection.portfolio),
  ('Contact', PortfolioSection.contact),
];

class PillSectionNav extends StatelessWidget {
  const PillSectionNav({
    super.key,
    required this.active,
    required this.onTap,
  });

  final PortfolioSection active;
  final ValueChanged<PortfolioSection> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: p.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (label, section) in kPillNavItems) ...[
              _PillItem(
                label: label,
                selected: active == section,
                onTap: () => onTap(section),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  const _PillItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? p.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: selected ? Border.all(color: p.border) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? p.textPrimary : p.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
