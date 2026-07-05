import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class ZeelSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showAccent;

  const ZeelSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showAccent = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.sourceSerif4(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: p.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (showAccent) ...[
          const SizedBox(height: 8),
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.accentTeal,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16,
              color: p.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
