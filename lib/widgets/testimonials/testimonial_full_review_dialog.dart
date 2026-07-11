import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/testimonial_model.dart';
import '../../theme/portfolio_theme.dart';

void showTestimonialFullReviewDialog(
  BuildContext context,
  TestimonialModel testimonial,
) {
  final p = context.portfolio;
  final subtitle = [
    if (testimonial.role.isNotEmpty) testimonial.role,
    if (testimonial.company.isNotEmpty) testimonial.company,
  ].join(' · ');

  showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 560),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: p.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    testimonial.name,
                    style: TextStyle(
                      color: p.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: Icon(Icons.close_rounded, color: p.textMuted),
                  tooltip: 'Close',
                ),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: p.accentTeal,
                  fontSize: PortfolioFontSizes.label,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Divider(color: p.border, height: 1),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  testimonial.text,
                  style: TextStyle(
                    color: p.textMuted,
                    fontSize: 14,
                    height: 1.65,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(foregroundColor: p.accentTeal),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget testimonialAvatar(
  TestimonialModel testimonial,
  PortfolioColors p, {
  double radius = 16,
}) {
  final base64 = testimonial.avatarBase64;
  if (base64 != null && base64.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: MemoryImage(base64Decode(base64)),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: p.accentTeal.withValues(alpha: 0.15),
    child: Text(
      testimonial.initials,
      style: TextStyle(
        color: p.accentTeal,
        fontSize: radius * 0.45,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
