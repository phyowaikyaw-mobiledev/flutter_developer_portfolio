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

/// Fixed bottom nav bar used on mobile in place of [PillSectionNav], which
/// lives inside the content card and gets horizontally scrolled/cut off at
/// narrow widths. This floats above the very bottom edge of the screen via
/// [LandingScreen]'s `Scaffold.bottomNavigationBar`, matching a native
/// app-style tab bar.
class SectionBottomNav extends StatelessWidget {
  const SectionBottomNav({
    super.key,
    required this.active,
    required this.onTap,
  });

  final PortfolioSection active;
  final ValueChanged<PortfolioSection> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    // Scaffold.bottomNavigationBar is deliberately laid out with a loose but
    // very large maxHeight (the full Scaffold height) so custom bars can pick
    // their own size. Without an explicit height here, that generous bound
    // flows down to each _BottomNavItem's AnimatedContainer(alignment: ...),
    // whose internal Align fills the entire bounded height it's given
    // (Align only shrink-wraps when heightFactor is set or maxHeight is
    // literally infinite) — stretching every pill to nearly full screen
    // height. Fixing the height here clamps that bound before it reaches it.
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: p.navBarBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: p.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              for (final (label, section) in kPillNavItems)
                Expanded(
                  child: _BottomNavItem(
                    label: label,
                    selected: active == section,
                    onTap: () => onTap(section),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? p.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: selected ? Border.all(color: p.border) : null,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: PortfolioFontSizes.caption,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? p.textPrimary : p.textMuted,
              ),
            ),
          ),
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
