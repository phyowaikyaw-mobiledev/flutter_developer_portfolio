import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import 'profile_screen.dart';
import 'skills_screen.dart';
import 'testimonials_screen.dart';

/// Profile, skills, and testimonials in one recruiter-friendly hub.
/// Deep links: /about?section=profile | skills | testimonials
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  static const _sectionKeys = ['profile', 'skills', 'testimonials'];
  static const _tabLabels = ['Profile', 'Skills', 'Testimonials'];
  static const _shellAppBarHeight = 70.0;

  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
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
                  Icons.person_outline,
                  size: 17,
                  color: AppColors.primaryLight.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 8),
                Text(
                  'ABOUT',
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF93C5FD),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFF0D1530),
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              onTap: (i) {
                _tab.animateTo(i);
                context.go('/about?section=${_sectionKeys[i]}');
              },
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: const Color(0xFF93C5FD),
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Skills'),
                Tab(text: 'Testimonials'),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: const [
                ProfileScreen(embeddedInAbout: true),
                SkillsScreen(embeddedInAbout: true),
                TestimonialsScreen(embeddedInAbout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
