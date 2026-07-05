import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Column(
      children: [
        const Divider(height: 48),
        Text(
          'Copyright © ${DateTime.now().year} Phyo Wai Kyaw',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: PortfolioFontSizes.label, color: p.textMuted),
        ),
      ],
    );
  }
}
