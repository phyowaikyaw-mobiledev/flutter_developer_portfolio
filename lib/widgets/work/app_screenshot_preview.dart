import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';

class AppScreenshotPreview extends StatelessWidget {
  const AppScreenshotPreview({super.key, this.imageAsset});

  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageAsset != null
          ? Image.asset(
              imageAsset!,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => _placeholder(p),
            )
          : _placeholder(p),
    );
  }

  Widget _placeholder(PortfolioColors p) {
    return ColoredBox(
      color: p.border.withValues(alpha: 0.3),
      child: Center(
        child: Icon(Icons.image_outlined, size: 40, color: p.textMuted),
      ),
    );
  }
}
