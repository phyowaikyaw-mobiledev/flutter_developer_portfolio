import 'package:flutter/material.dart';
import '../../data/skills_data.dart';
import '../../theme/portfolio_theme.dart';
import '../../widgets/common/zeel_section_header.dart';
import '../../widgets/common/zeel_text_filters.dart';
import '../../widgets/skills/skill_chip.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _filter = 'All';

  List<SkillCategory> get _visible {
    final f = skillFilterFromLabel(_filter);
    if (f == SkillFilter.all) return kSkillCategories;
    return kSkillCategories.where((c) => c.filter == f).toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final categories = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(title: 'Tech Expertise'),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.menu_book_outlined, size: 16, color: p.accentTeal),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mobile Application Development',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: p.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZeelTextFilters(
          options: kSkillFilters,
          selected: _filter,
          onSelected: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 24),
        ...List.generate(categories.length, (i) {
          final cat = categories[i];
          final isLast = i == categories.length - 1;
          return _TimelineCategory(
            category: cat,
            isLast: isLast,
          );
        }),
      ],
    );
  }
}

class _TimelineCategory extends StatelessWidget {
  const _TimelineCategory({
    required this.category,
    required this.isLast,
  });

  final SkillCategory category;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: p.accentTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: p.accentTeal.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 4, left: 4),
                  width: 2,
                  height: 28,
                  color: p.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: category.skills
                      .map((item) => SkillChip(item: item))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
