import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Card wrapper with subtle hover lift and primary glow border.
class ShimmerCard extends StatefulWidget {
  final Widget child;
  final BoxDecoration decoration;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;
  final bool enableEffects;

  const ShimmerCard({
    super.key,
    required this.child,
    required this.decoration,
    this.glowColor = AppColors.primary,
    this.padding,
    this.enableEffects = true,
  });

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final effectsOn = widget.enableEffects && !reduceMotion;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (effectsOn) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, effectsOn && _hovered ? -2.0 : 0.0),
        decoration: widget.decoration.copyWith(
          boxShadow: effectsOn && _hovered
              ? [
                  BoxShadow(
                    color: widget.glowColor.withValues(alpha: 0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : widget.decoration.boxShadow,
          border: effectsOn && _hovered
              ? Border.all(
                  color: widget.glowColor.withValues(alpha: 0.45),
                  width: 1.25,
                )
              : widget.decoration.border,
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        ),
      ),
    );
  }
}
