import 'package:flutter/material.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../utils/constants.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  static const _skills = [
    (
      'Mobile Development',
      Icons.phone_android,
      ['Flutter', 'Dart', 'Material Design', 'Cupertino Widgets', 'Responsive UI'],
    ),
    (
      'State Management',
      Icons.settings,
      ['GetX', 'BLoC', 'Provider', 'Riverpod (Learning)'],
    ),
    (
      'Backend & Integration',
      Icons.cloud,
      ['Firebase', 'REST API', 'Dio', 'Retrofit', 'JSON Parsing', 'Postman'],
    ),
    (
      'Database & Storage',
      Icons.storage,
      ['Firestore', 'Hive', 'SQLite', 'Realm DB', 'Local Storage'],
    ),
    (
      'Development Tools',
      Icons.build,
      ['Git', 'GitHub', 'Android Studio', 'VS Code', 'Flutter DevTools'],
    ),
    (
      'Architecture & Patterns',
      Icons.architecture,
      ['MVC', 'Clean Architecture', 'Repository Pattern', 'Navigation & Routing'],
    ),
    (
      'Tools I use daily',
      Icons.terminal,
      ['Claude', 'Cursor', 'Git workflow', 'Code review'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final p = context.portfolio;
    final underAppBar = MediaQuery.paddingOf(context).top + 60;

    return Scaffold(
      backgroundColor: p.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 16 : 32,
            underAppBar + (isMobile ? 20 : 32),
            isMobile ? 16 : 32,
            isMobile ? 40 : 60,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  SectionTitle(
                    title: 'Technical Skills',
                    isMobile: isMobile,
                    subtitle:
                        'Technologies I use to build and ship Flutter apps.',
                  ),
                  SizedBox(height: isMobile ? 24 : 36),
                  if (isMobile)
                    Column(
                      children: _skills
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: RevealAnimator(
                                delay: Duration(milliseconds: 60 * e.key),
                                child: _SkillCard(
                                  title: e.value.$1,
                                  icon: e.value.$2,
                                  tags: e.value.$3,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    _TwoColumnGrid(skills: _skills),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TwoColumnGrid extends StatelessWidget {
  final List<(String, IconData, List<String>)> skills;

  const _TwoColumnGrid({required this.skills});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < skills.length; i += 2) {
      final left = skills[i];
      final right = i + 1 < skills.length ? skills[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RevealAnimator(
                  delay: Duration(milliseconds: 60 * (i ~/ 2)),
                  child: _SkillCard(
                    title: left.$1,
                    icon: left.$2,
                    tags: left.$3,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              if (right != null)
                Expanded(
                  child: RevealAnimator(
                    delay: Duration(milliseconds: 60 * (i ~/ 2) + 30),
                    child: _SkillCard(
                      title: right.$1,
                      icon: right.$2,
                      tags: right.$3,
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < skills.length) rows.add(const SizedBox(height: 20));
    }
    return Column(children: rows);
  }
}

class _SkillCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> tags;

  const _SkillCard({
    required this.title,
    required this.icon,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return ShimmerCard(
      glowColor: AppColors.primary,
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  clipBehavior: Clip.none,
                  children: tags.map((t) => _Tag(label: t)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatefulWidget {
  final String label;

  const _Tag({required this.label});

  @override
  State<_Tag> createState() => _TagState();
}

class _TagState extends State<_Tag> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: _h ? 0.18 : 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: _h ? 0.5 : 0.25),
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textPrimary.withValues(alpha: _h ? 1 : 0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
