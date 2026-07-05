import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import 'profile_screen.dart';
import 'testimonials_screen.dart';

/// Profile and testimonials hub.
/// Deep links: /about?section=profile | testimonials
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  static const _sectionKeys = ['profile', 'testimonials'];
  static const _tabLabels = ['Profile', 'Testimonials'];
  static const _shellAppBarHeight = 70.0;

  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
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
    if (sec == 'skills') {
      context.go('/skills');
      return;
    }
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
    final p = context.portfolio;

    return Scaffold(
      backgroundColor: p.background,
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
                    color: p.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  _tabLabels[_tab.index],
                  style: const TextStyle(
                    fontSize: PortfolioFontSizes.label,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: p.cardBg,
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
              labelColor: AppColors.primaryLight,
              unselectedLabelColor: p.textMuted,
              tabs: const [
                Tab(text: 'Profile'),
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
                TestimonialsScreen(embeddedInAbout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
