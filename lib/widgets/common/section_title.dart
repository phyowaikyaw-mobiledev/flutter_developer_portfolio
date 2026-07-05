import 'package:flutter/material.dart';
import 'reveal_animator.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isMobile;
  final String? subtitle;
  const SectionTitle({
    super.key,
    required this.title,
    required this.isMobile,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return RevealAnimator(
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: isMobile ? 3 : 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: p.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: isMobile ? 10 : 14),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                color: p.textMuted,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: isMobile ? 16 : 24),
          Container(
            width: isMobile ? 64 : 80,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
