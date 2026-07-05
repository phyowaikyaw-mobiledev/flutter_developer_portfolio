import 'package:flutter/material.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/common/zeel_section_header.dart';

class AwardsSection extends StatelessWidget {
  const AwardsSection({super.key});

  static const _gold = Color(0xFFEAB308);

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(title: 'Awards'),
        SizedBox(height: isMobile ? 16 : 20),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 18 : 24),
          decoration: BoxDecoration(
            color: p.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isMobile ? 52 : 64,
                    height: isMobile ? 52 : 64,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _gold.withValues(alpha: 0.4)),
                    ),
                    child: Icon(
                      Icons.emoji_events_outlined,
                      color: _gold,
                      size: isMobile ? 28 : 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1st Runner Up',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 26,
                            fontWeight: FontWeight.bold,
                            color: _gold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Oway Travel Hackathon 2020 — Mandalay',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: p.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organized by Phandeeyar Foundation | Myanmar',
                          style: TextStyle(fontSize: PortfolioFontSizes.label, color: p.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),
              _detail(
                p,
                'Result',
                '1st Runner Up among 20+ competing teams',
              ),
              _detail(
                p,
                'Project',
                'Developed a functional Flutter App travel prototype under strict time constraints (2020)',
              ),
              _detail(
                p,
                'Skills Demonstrated',
                'Teamwork, problem-solving, rapid prototyping, and presentation skills',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: _gold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '\$1,000 AWS Cloud Credits',
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.secondary,
                        fontWeight: FontWeight.w600,
                        color: p.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Text(
                'Hackathon Memories',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: p.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              isMobile
                  ? Column(
                      children: [
                        _photo(p, 'assets/images/hackathon_award.jpg', 'Award Ceremony'),
                        const SizedBox(height: 12),
                        _photo(p, 'assets/images/hackathon_team.jpg', 'Team Heaven'),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _photo(
                            p,
                            'assets/images/hackathon_award.jpg',
                            'Award Ceremony',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _photo(
                            p,
                            'assets/images/hackathon_team.jpg',
                            'Team Heaven',
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detail(PortfolioColors p, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: PortfolioFontSizes.caption,
              fontWeight: FontWeight.w600,
              color: p.accentTeal,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: p.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(PortfolioColors p, String asset, String caption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: p.border,
                child: Icon(Icons.image_outlined, color: p.textMuted),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(caption, style: TextStyle(fontSize: PortfolioFontSizes.caption, color: p.textMuted)),
      ],
    );
  }
}
