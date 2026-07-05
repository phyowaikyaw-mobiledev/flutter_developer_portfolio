import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import 'apps_screen.dart';
import 'projects_screen.dart';
import 'awards_screen.dart';
import 'case_study_screen.dart';

/// Single route combining production apps, projects, awards, and case study.
/// Deep links: /work?section=apps | projects | awards | case-study
class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>
    with SingleTickerProviderStateMixin {
  static const _sectionKeys = ['apps', 'projects', 'awards', 'case-study'];
  static const _tabLabels = [
    'Production apps',
    'Projects',
    'Awards',
    'How I build',
  ];

  static const _shellAppBarHeight = 70.0;

  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
    _tab.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tab.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tab.removeListener(_onTabChanged);
    _tab.dispose();
    super.dispose();
  }

  void _applySectionFromRoute() {
    final sec = GoRouterState.of(context).uri.queryParameters['section'];
    final idx = _sectionKeys.indexOf(sec ?? '');
    final i = idx >= 0 ? idx : 0;
    if (_tab.index != i) _tab.index = i;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applySectionFromRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final underAppBar =
        MediaQuery.paddingOf(context).top + _shellAppBarHeight - 10;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: underAppBar),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
            child: Row(
              children: [
                Icon(
                  Icons.layers_outlined,
                  size: 17,
                  color: AppColors.primaryLight.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 8),
                Text(
                  'WORK',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.42),
                  ),
                ),
                const Spacer(),
                Text(
                  _tabLabels[_tab.index],
                  style: const TextStyle(
                    fontSize: PortfolioFontSizes.label,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF93C5FD),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFF0D1530),
            elevation: 0,
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              onTap: (i) {
                _tab.animateTo(i);
                context.go('/work?section=${_sectionKeys[i]}');
              },
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: const Color(0xFF93C5FD),
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: PortfolioFontSizes.secondary,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: PortfolioFontSizes.secondary,
              ),
              tabs: const [
                Tab(text: 'Production apps'),
                Tab(text: 'Projects'),
                Tab(text: 'Awards'),
                Tab(text: 'How I build'),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: const [
                AppsScreen(embeddedInWork: true),
                ProjectsScreen(embeddedInWork: true),
                AwardsScreen(embeddedInWork: true),
                CaseStudyScreen(embeddedInWork: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
