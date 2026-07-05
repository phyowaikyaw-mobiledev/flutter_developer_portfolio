import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class PortfolioColors extends ThemeExtension<PortfolioColors> {
  const PortfolioColors({
    required this.background,
    required this.cardBg,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.navBarBg,
    required this.accentTeal,
    required this.activeGreen,
  });

  final Color background;
  final Color cardBg;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color navBarBg;
  final Color accentTeal;
  final Color activeGreen;

  static const dark = PortfolioColors(
    background: AppColors.background,
    cardBg: AppColors.cardBg,
    border: AppColors.border,
    textPrimary: Colors.white,
    textMuted: AppColors.textMuted,
    navBarBg: AppColors.background,
    accentTeal: AppColors.accentTeal,
    activeGreen: AppColors.activeGreen,
  );

  static const light = PortfolioColors(
    background: Color(0xFFF4F4F5),
    cardBg: Color(0xFFFFFFFF),
    border: Color(0xFFE4E4E7),
    textPrimary: Color(0xFF18181B),
    textMuted: Color(0xFF71717A),
    navBarBg: Color(0xFFF4F4F5),
    accentTeal: Color(0xFF0D9488),
    activeGreen: Color(0xFF16A34A),
  );

  @override
  PortfolioColors copyWith({
    Color? background,
    Color? cardBg,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? navBarBg,
    Color? accentTeal,
    Color? activeGreen,
  }) {
    return PortfolioColors(
      background: background ?? this.background,
      cardBg: cardBg ?? this.cardBg,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      navBarBg: navBarBg ?? this.navBarBg,
      accentTeal: accentTeal ?? this.accentTeal,
      activeGreen: activeGreen ?? this.activeGreen,
    );
  }

  @override
  PortfolioColors lerp(ThemeExtension<PortfolioColors>? other, double t) {
    if (other is! PortfolioColors) return this;
    return PortfolioColors(
      background: Color.lerp(background, other.background, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      activeGreen: Color.lerp(activeGreen, other.activeGreen, t)!,
    );
  }
}

extension PortfolioThemeContext on BuildContext {
  PortfolioColors get portfolio =>
      Theme.of(this).extension<PortfolioColors>() ?? PortfolioColors.dark;
}

TextStyle? _bumpSize(TextStyle? style, double add) {
  if (style == null) return null;
  return style.copyWith(fontSize: (style.fontSize ?? 14) + add);
}

TextTheme _portfolioTextTheme(Brightness brightness) {
  final base = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;
  final inter = GoogleFonts.interTextTheme(base);
  const add = 2.0;

  final bumped = inter.copyWith(
    displayLarge: _bumpSize(inter.displayLarge, add),
    displayMedium: _bumpSize(inter.displayMedium, add),
    displaySmall: _bumpSize(inter.displaySmall, add),
    headlineLarge: _bumpSize(inter.headlineLarge, add),
    headlineMedium: _bumpSize(inter.headlineMedium, add),
    headlineSmall: GoogleFonts.sourceSerif4(
      textStyle: _bumpSize(inter.headlineSmall, add)?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
    titleLarge: GoogleFonts.sourceSerif4(
      textStyle: _bumpSize(inter.titleLarge, add)?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
    titleMedium: _bumpSize(inter.titleMedium, add),
    titleSmall: _bumpSize(inter.titleSmall, add),
    bodyLarge: _bumpSize(inter.bodyLarge, add),
    bodyMedium: _bumpSize(inter.bodyMedium, add),
    bodySmall: _bumpSize(inter.bodySmall, add),
    labelLarge: _bumpSize(inter.labelLarge, add),
    labelMedium: _bumpSize(inter.labelMedium, add),
    labelSmall: _bumpSize(inter.labelSmall, add),
  );

  return bumped;
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: _portfolioTextTheme(Brightness.dark),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      onSurface: Colors.white,
    ),
    extensions: const [PortfolioColors.dark],
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: PortfolioColors.light.background,
    textTheme: _portfolioTextTheme(Brightness.light),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: AppColors.primaryLight,
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0F172A),
    ),
    extensions: const [PortfolioColors.light],
  );
}
