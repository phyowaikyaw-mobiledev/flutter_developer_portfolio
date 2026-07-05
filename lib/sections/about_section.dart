import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/common/zeel_section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  TextStyle _body(PortfolioColors p) => TextStyle(
        fontSize: PortfolioFontSizes.body,
        color: p.textMuted,
        height: 1.75,
      );

  TextStyle _highlight(PortfolioColors p) => TextStyle(
        fontSize: PortfolioFontSizes.body,
        color: p.textPrimary,
        fontWeight: FontWeight.w600,
        height: 1.75,
      );

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(title: 'About Me'),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            style: _body(p),
            children: [
              const TextSpan(text: "I'm a "),
              TextSpan(text: 'production Flutter developer', style: _highlight(p)),
              const TextSpan(
                text: ' with hands-on experience shipping ',
              ),
              TextSpan(text: 'Android & iOS apps', style: _highlight(p)),
              const TextSpan(
                text: ' through full-cycle delivery — from architecture and API '
                'integration to ',
              ),
              TextSpan(text: 'Play Store & App Store', style: _highlight(p)),
              const TextSpan(text: ' release.'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text.rich(
          TextSpan(
            style: _body(p),
            children: [
              const TextSpan(text: 'Strong in '),
              TextSpan(text: 'Clean Architecture', style: _highlight(p)),
              const TextSpan(text: ' and '),
              TextSpan(text: 'Layered Architecture', style: _highlight(p)),
              const TextSpan(
                text: ', REST API integration with Dio, cross-platform ',
              ),
              TextSpan(text: 'localization (MM/English)', style: _highlight(p)),
              const TextSpan(
                text: ', and remote collaboration with engineering teams.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Leverages AI-powered development tooling (Claude, Cursor) to accelerate '
          'productivity and maintain high code quality.',
          style: _body(p),
        ),
      ],
    );
  }
}
