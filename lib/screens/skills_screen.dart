import 'package:flutter/material.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  static final _skills = [
    [
      'Mobile Development',
      Icons.phone_android,
      [
        'Flutter',
        'Dart',
        'Material Design',
        'Cupertino Widgets',
        'Responsive UI',
      ],
      const Color(0xFF1E40AF),
      const Color(0xFF3B82F6),
    ],
    [
      'State Management',
      Icons.settings,
      ['GetX', 'BLoC', 'Provider', 'Riverpod (Learning)'],
      const Color(0xFF3B82F6),
      const Color(0xFF1E40AF),
    ],
    [
      'Backend & Integration',
      Icons.cloud,
      ['Firebase', 'REST API', 'Dio', 'Retrofit', 'JSON Parsing', 'Postman'],
      const Color(0xFF1E40AF),
      const Color(0xFF3B82F6),
    ],
    [
      'Database & Storage',
      Icons.storage,
      ['Firestore', 'Hive', 'SQLite', 'Realm DB', 'Local Storage'],
      const Color(0xFF3B82F6),
      const Color(0xFF1E40AF),
    ],
    [
      'Development Tools',
      Icons.build,
      ['Git', 'GitHub', 'Android Studio', 'VS Code', 'Flutter DevTools'],
      const Color(0xFF1E40AF),
      const Color(0xFF3B82F6),
    ],
    [
      'Architecture & Patterns',
      Icons.architecture,
      [
        'MVC',
        'Clean Architecture',
        'Repository Pattern',
        'Navigation & Routing',
      ],
      const Color(0xFF3B82F6),
      const Color(0xFF1E40AF),
    ],
    [
      'AI-Augmented Dev',
      Icons.auto_awesome,
      ['Claude AI', 'Cursor', 'AI Code Review', 'AI Architecture'],
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    // Use 1 column on mobile, 2 columns on tablet+desktop
    final crossCount = isMobile ? 1 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: isMobile ? 80 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  SectionTitle(title: 'Technical Skills', isMobile: isMobile),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    'Technologies I work with every day',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 36),

                  // FIX: Replace GridView (fixed height) with a two-column
                  // Wrap-based layout so cards grow to fit their content.
                  // This prevents overflow when tags wrap onto extra lines.
                  if (isMobile)
                    // Single column — just a Column
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
                                  title: e.value[0] as String,
                                  icon: e.value[1] as IconData,
                                  tags: e.value[2] as List<String>,
                                  primary: e.value[3] as Color,
                                  secondary: e.value[4] as Color,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    // Two columns — pair up items manually so height is intrinsic
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

// ── Two-column layout with intrinsic heights ──────────────────────────────────
class _TwoColumnGrid extends StatelessWidget {
  final List<List<dynamic>> skills;

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
                    title: left[0] as String,
                    icon: left[1] as IconData,
                    tags: left[2] as List<String>,
                    primary: left[3] as Color,
                    secondary: left[4] as Color,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              if (right != null)
                Expanded(
                  child: RevealAnimator(
                    delay: Duration(milliseconds: 60 * (i ~/ 2) + 30),
                    child: _SkillCard(
                      title: right[0] as String,
                      icon: right[1] as IconData,
                      tags: right[2] as List<String>,
                      primary: right[3] as Color,
                      secondary: right[4] as Color,
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

// ── Skill Card ────────────────────────────────────────────────────────────────
class _SkillCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> tags;
  final Color primary, secondary;

  const _SkillCard({
    required this.title,
    required this.icon,
    required this.tags,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerCard(
      glowColor: primary,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.1),
            secondary.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, secondary]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          // Title + tags — Expanded so Wrap can use full available width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // FIX: clipBehavior: Clip.none prevents tag borders being clipped
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  clipBehavior: Clip.none,
                  children: tags
                      .map((t) => _Tag(label: t, primary: primary))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tag ───────────────────────────────────────────────────────────────────────
class _Tag extends StatefulWidget {
  final String label;
  final Color primary;

  const _Tag({required this.label, required this.primary});

  @override
  State<_Tag> createState() => _TagState();
}

class _TagState extends State<_Tag> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.primary.withValues(alpha: _h ? 0.35 : 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _h ? widget.primary : widget.primary.withValues(alpha: 0.4),
            width: _h ? 1.5 : 1,
          ),
          boxShadow: _h
              ? [
                  BoxShadow(
                    color: widget.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            color: _h ? Colors.white : Colors.white.withValues(alpha: 0.85),
            fontWeight: _h ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
