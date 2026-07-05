import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/testimonial_model.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/testimonial_relationship.dart';
import 'testimonial_full_review_dialog.dart';

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key, required this.testimonial});

  final TestimonialModel testimonial;

  static const _previewLines = 4;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final relationship = testimonialRelationshipLabel(testimonial);
    final company = testimonial.company.isNotEmpty
        ? testimonial.company
        : testimonial.role;
    final showReadMore = testimonial.text.length > 180;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: p.accentTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: p.accentTeal.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  relationship.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.5,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w700,
                    color: p.accentTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            company,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            testimonial.text,
            maxLines: _previewLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: p.textMuted,
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (showReadMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  showTestimonialFullReviewDialog(context, testimonial),
              child: Text(
                'Read full review',
                style: TextStyle(
                  fontSize: PortfolioFontSizes.label,
                  color: p.accentTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              testimonialAvatar(testimonial, p),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.label,
                        fontWeight: FontWeight.w600,
                        color: p.textPrimary,
                      ),
                    ),
                    Text(
                      testimonial.role,
                      style: TextStyle(fontSize: PortfolioFontSizes.caption, color: p.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
