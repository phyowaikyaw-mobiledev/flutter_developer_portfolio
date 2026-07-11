import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/testimonial_model.dart';
import '../../services/firestore_service.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/common/zeel_section_header.dart';
import '../../widgets/testimonials/testimonial_masonry_grid.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final _service = FirestoreService();
  List<TestimonialModel> _testimonials = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _service.loadTestimonials();
      if (mounted) setState(() => _testimonials = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(
          title: 'What Collaborators Say',
          subtitle:
              'From teammates, clients, mentors, and peers I have shipped with.',
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.go('/testimonials'),
          icon: Icon(Icons.rate_review_outlined, color: p.accentTeal, size: 18),
          label: Text(
            'Worked with me? Share your feedback',
            style: TextStyle(
              color: p.accentTeal,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: p.accentTeal.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_testimonials.isEmpty)
          _emptyState(p)
        else
          TestimonialMasonryGrid(testimonials: _testimonials),
      ],
    );
  }

  Widget _emptyState(PortfolioColors p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote_outlined, color: p.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            'No testimonials yet.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Feedback from collaborators will appear here.',
            style: TextStyle(fontSize: PortfolioFontSizes.secondary, color: p.textMuted),
          ),
        ],
      ),
    );
  }
}
