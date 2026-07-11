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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TagChip(label: relationship.toUpperCase(), p: p),
                    _VerifiedChip(p: p),
                  ],
                ),
              ),
              Icon(
                Icons.format_quote,
                size: 28,
                color: p.accentTeal.withValues(alpha: 0.22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AvatarWithRing(testimonial: testimonial, p: p),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.body,
                        fontWeight: FontWeight.bold,
                        color: p.textPrimary,
                      ),
                    ),
                    if (testimonial.role.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        testimonial.role,
                        style: TextStyle(
                          fontSize: PortfolioFontSizes.label,
                          fontWeight: FontWeight.w500,
                          color: p.accentTeal,
                        ),
                      ),
                    ],
                    if (testimonial.company.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        testimonial.company,
                        style: TextStyle(
                          fontSize: PortfolioFontSizes.caption,
                          color: p.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: p.border, height: 1),
          const SizedBox(height: 14),
          Text(
            testimonial.text,
            maxLines: _previewLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: p.textMuted,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: p.border, height: 1),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => showTestimonialFullReviewDialog(context, testimonial),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read full review',
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.label,
                      color: p.accentTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    size: 14,
                    color: p.accentTeal,
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.p});

  final String label;
  final PortfolioColors p;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: p.accentTeal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.accentTeal.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w700,
          color: p.accentTeal,
        ),
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.p});

  final PortfolioColors p;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: p.accentTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.accentTeal.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 12,
            color: p.accentTeal,
          ),
          const SizedBox(width: 4),
          Text(
            'VERIFIED',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w700,
              color: p.accentTeal,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWithRing extends StatelessWidget {
  const _AvatarWithRing({required this.testimonial, required this.p});

  final TestimonialModel testimonial;
  final PortfolioColors p;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: p.accentTeal.withValues(alpha: 0.55),
          width: 2,
        ),
      ),
      child: testimonialAvatar(testimonial, p, radius: 22),
    );
  }
}
