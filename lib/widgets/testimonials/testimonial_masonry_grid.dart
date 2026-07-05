import 'package:flutter/material.dart';
import '../../models/testimonial_model.dart';
import 'testimonial_card.dart';

class TestimonialMasonryGrid extends StatelessWidget {
  const TestimonialMasonryGrid({
    super.key,
    required this.testimonials,
  });

  final List<TestimonialModel> testimonials;

  @override
  Widget build(BuildContext context) {
    if (testimonials.isEmpty) return const SizedBox.shrink();

    final isMobile = MediaQuery.sizeOf(context).width < 768;

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < testimonials.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            TestimonialCard(
              key: ValueKey(testimonials[i].id),
              testimonial: testimonials[i],
            ),
          ],
        ],
      );
    }

    final left = <TestimonialModel>[];
    final right = <TestimonialModel>[];
    for (int i = 0; i < testimonials.length; i++) {
      if (i.isEven) {
        left.add(testimonials[i]);
      } else {
        right.add(testimonials[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < left.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                TestimonialCard(
                  key: ValueKey(left[i].id),
                  testimonial: left[i],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < right.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                TestimonialCard(
                  key: ValueKey(right[i].id),
                  testimonial: right[i],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
