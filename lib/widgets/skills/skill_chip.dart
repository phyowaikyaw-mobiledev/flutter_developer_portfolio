import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/skills_data.dart';
import '../../theme/portfolio_theme.dart';
import '../../theme/theme_controller.dart';
import '../../utils/constants.dart';

const _lightOnDarkAssets = {
  '$kSkillIconDir/apple.svg',
  '$kSkillIconDir/github.svg',
  '$kSkillIconDir/anthropic.svg',
  '$kSkillIconDir/cursor.svg',
  '$kSkillIconDir/vercel.svg',
  '$kSkillIconDir/testinglibrary.svg',
  '$kSkillIconDir/googlechrome.svg',
  '$kSkillIconDir/gradle.svg',
};

bool _svgNeedsLightTint(String svg) {
  final lower = svg.toLowerCase();
  if (!lower.contains('fill=')) return true;
  const darkFills = ['#000', '#181717', '#191919', '#02303a', '#414141'];
  return darkFills.any(lower.contains);
}

class SkillChip extends StatelessWidget {
  const SkillChip({super.key, required this.item});

  final SkillItem item;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: _SkillLogo(
              asset: item.logoAsset,
              mutedColor: p.textMuted,
              isDarkMode: themeController.isDark,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.name,
            style: TextStyle(
              fontSize: PortfolioFontSizes.label,
              fontWeight: FontWeight.w500,
              color: p.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillLogo extends StatelessWidget {
  const _SkillLogo({
    required this.asset,
    required this.mutedColor,
    required this.isDarkMode,
  });

  final String asset;
  final Color mutedColor;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final fallback = _NeutralPlaceholder(color: mutedColor);
    final lower = asset.toLowerCase();

    if (lower.endsWith('.svg')) {
      return _SafeSvgAsset(
        asset: asset,
        width: 18,
        height: 18,
        fallback: fallback,
        isDarkMode: isDarkMode,
      );
    }

    return Image.asset(
      asset,
      width: 18,
      height: 18,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _SafeSvgAsset extends StatefulWidget {
  const _SafeSvgAsset({
    required this.asset,
    required this.width,
    required this.height,
    required this.fallback,
    required this.isDarkMode,
  });

  final String asset;
  final double width;
  final double height;
  final Widget fallback;
  final bool isDarkMode;

  @override
  State<_SafeSvgAsset> createState() => _SafeSvgAssetState();
}

class _SafeSvgAssetState extends State<_SafeSvgAsset> {
  String? _svgData;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.asset).then((data) {
      if (!mounted) return;
      if (data.trim().isEmpty) {
        setState(() => _failed = true);
        return;
      }
      setState(() => _svgData = data);
    }).catchError((_) {
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.fallback;
    final data = _svgData;
    if (data == null) return widget.fallback;

    final lightOnDark = widget.isDarkMode &&
        (_lightOnDarkAssets.contains(widget.asset) || _svgNeedsLightTint(data));

    try {
      return SvgPicture.string(
        data,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        colorFilter: lightOnDark
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : null,
        placeholderBuilder: (_) => widget.fallback,
      );
    } catch (_) {
      return widget.fallback;
    }
  }
}

class _NeutralPlaceholder extends StatelessWidget {
  const _NeutralPlaceholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
