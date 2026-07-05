import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class ZeelTextFilters extends StatelessWidget {
  const ZeelTextFilters({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      children: options.map((opt) {
        final active = opt == selected;
        return InkWell(
          onTap: () => onSelected(opt),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: PortfolioFontSizes.secondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? p.textPrimary : p.textMuted,
                decoration: active
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: p.accentTeal,
                decorationThickness: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
