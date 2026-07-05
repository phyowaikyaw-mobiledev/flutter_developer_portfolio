import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class GoogleMapEmbed extends StatelessWidget {
  const GoogleMapEmbed({
    super.key,
    required this.embedUrl,
    required this.openUrl,
    this.height = 360,
  });

  final String embedUrl;
  final String openUrl;
  final double height;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: Image.network(
              AppStrings.mapStaticPreviewUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: p.background,
                child: Center(
                  child: Icon(Icons.map_outlined, size: 48, color: p.textMuted),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: FilledButton.icon(
              onPressed: () => _launch(openUrl),
              style: FilledButton.styleFrom(
                backgroundColor: p.cardBg,
                foregroundColor: p.textPrimary,
              ),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Open in Maps'),
            ),
          ),
        ],
      ),
    );
  }
}
