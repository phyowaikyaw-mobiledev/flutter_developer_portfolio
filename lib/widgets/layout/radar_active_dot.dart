import 'package:flutter/material.dart';

class RadarActiveDot extends StatefulWidget {
  const RadarActiveDot({
    super.key,
    required this.color,
    required this.borderColor,
    this.dotSize = 14,
    this.maxSpread = 26,
    this.ringCount = 2,
  });

  final Color color;
  final Color borderColor;
  final double dotSize;
  final double maxSpread;
  final int ringCount;

  @override
  State<RadarActiveDot> createState() => _RadarActiveDotState();
}

class _RadarActiveDotState extends State<RadarActiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasSize = widget.maxSpread + widget.dotSize + 4;

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < widget.ringCount; i++)
                _rippleRing(phaseOffset: i / widget.ringCount),
              _centerDot(),
            ],
          );
        },
      ),
    );
  }

  /// Rings centered on dot; spread outward from the inside corner.
  Widget _rippleRing({required double phaseOffset}) {
    final progress = (_ctrl.value + phaseOffset) % 1.0;
    final size = widget.dotSize + (progress * widget.maxSpread);
    final opacity = (1 - progress) * 0.55;
    final dotCenter = widget.dotSize / 2;

    return Positioned(
      right: dotCenter - size / 2,
      bottom: dotCenter - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: opacity),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _centerDot() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          border: Border.all(color: widget.borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.45),
              blurRadius: 6,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
