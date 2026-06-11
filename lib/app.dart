import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/portfolio_scroll_behavior.dart';
import 'utils/constants.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phyo Wai Kyaw - Flutter Developer',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const PortfolioScrollBehavior(),
      routerConfig: appRouter,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
          surface: AppColors.surface,
        ),
      ),
    );
  }
}
