import 'package:flutter/material.dart';

/// Drop-in replacement for a plain Container that adds:
/// • hover lift (translateY)
/// • animated glow border
/// • shimmer light-sweep on hover
class ShimmerCard extends StatefulWidget {
  final Widget child;
  final BoxDecoration decoration;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;

  const ShimmerCard({
    super.key,
    required this.child,
    required this.decoration,
    this.glowColor = const Color(0xFF3B82F6),
    this.padding,
  });

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _shimmerCtrl.forward(from: 0);
  }

  void _onExit() => setState(() => _hovered = false);

  @override
  Widget build(BuildContext context) {
    final radius =
        (widget.decoration.borderRadius as BorderRadius?)?.topLeft.x ?? 20.0;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: widget.decoration.copyWith(
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: widget.glowColor.withValues(alpha: 0.45),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: widget.glowColor.withValues(alpha: 0.15),
              blurRadius: 60,
              spreadRadius: 8,
            ),
          ]
              : widget.decoration.boxShadow,
          border: _hovered
              ? Border.all(
            color: widget.glowColor.withValues(alpha: 0.75),
            width: 1.5,
          )
              : widget.decoration.border,
        ),
        // ── FIX: Stack with two separate layers ──────────────────────────
        // Layer 1 → child with padding — NO ClipRRect, so icon corners and
        //           tag borders are never chopped.
        // Layer 2 → shimmer overlay — its own ClipRRect so the sweep stays
        //           inside card bounds without touching children at all.
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Content layer — padding applied here, fully unclipped
            Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: widget.child,
            ),

            // Shimmer overlay layer — clipped independently
            if (_hovered)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _shimmerAnim,
                      builder: (_, __) => Transform(
                        transform: Matrix4.skewX(-0.3)
                          ..translate(_shimmerAnim.value * 400),
                        child: Container(
                          width: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.07),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}