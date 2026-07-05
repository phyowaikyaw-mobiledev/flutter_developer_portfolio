import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/portfolio_scroll_behavior.dart';
import 'theme/portfolio_theme.dart';
import 'theme/theme_controller.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Phyo Wai Kyaw - Flutter Developer',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const PortfolioScrollBehavior(),
          routerConfig: appRouter,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeController.mode,
        );
      },
    );
  }
}
