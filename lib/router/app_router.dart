import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:go_router/go_router.dart';
import '../screens/landing_screen.dart';
import '../screens/production_app_detail_screen.dart';
import '../theme/portfolio_theme.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => _NotFoundScreen(path: state.uri.toString()),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (c, s) => NoTransitionPage<void>(
        key: s.pageKey,
        child: LandingScreen(
          initialSection: sectionFromQuery(s.uri.queryParameters['section']),
        ),
      ),
    ),
    GoRoute(
      path: '/portfolio/:slug',
      pageBuilder: (c, s) => NoTransitionPage<void>(
        key: s.pageKey,
        child: ProductionAppDetailScreen(
          slug: s.pathParameters['slug']!,
        ),
      ),
    ),
    GoRoute(
      path: '/skills',
      redirect: (_, __) => '/?section=expertise',
    ),
    GoRoute(
      path: '/work',
      redirect: (_, __) => '/?section=portfolio',
    ),
    GoRoute(
      path: '/apps',
      redirect: (_, __) => '/?section=portfolio',
    ),
    GoRoute(
      path: '/projects',
      redirect: (_, __) => '/?section=portfolio',
    ),
    GoRoute(
      path: '/about',
      redirect: (_, __) => '/?section=about',
    ),
    GoRoute(
      path: '/profile',
      redirect: (_, __) => '/?section=about',
    ),
    GoRoute(
      path: '/experience',
      redirect: (_, __) => '/?section=resume',
    ),
    GoRoute(
      path: '/resume',
      redirect: (_, __) => '/?section=resume',
    ),
    GoRoute(
      path: '/contact',
      redirect: (_, __) => '/?section=contact',
    ),
    GoRoute(
      path: '/testimonials',
      redirect: (_, __) => '/?section=contact',
    ),
    GoRoute(
      path: '/awards',
      redirect: (_, __) => '/?section=about',
    ),
  ],
);

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Scaffold(
      backgroundColor: p.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Page not found', style: TextStyle(color: p.textPrimary, fontSize: 20)),
            const SizedBox(height: 8),
            Text(path, style: TextStyle(color: p.textMuted, fontSize: PortfolioFontSizes.secondary)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
