import 'package:flutter/material.dart';

/// Scroll-triggered entrance animation widget
/// Slide+Fade from bottom, Scale spring, Stagger via [delay]
class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.7, curve: Curves.easeOut)),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(scale: _scale, child: child),
        ),
      ),
      child: widget.child,
    );
  }
}

/// Shimmer sweep effect over a child widget
class ShimmerCard extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  const ShimmerCard({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _shimmerCtrl.forward(from: 0);
  }

  void _onExit(_) => setState(() => _hovered = false);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _shimmerCtrl,
        builder: (_, child) {
          return Stack(
            children: [
              child!,
              if (_shimmerCtrl.value > 0 && _shimmerCtrl.value < 1)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: widget.borderRadius,
                    child: _ShimmerOverlay(progress: _shimmerCtrl.value),
                  ),
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _ShimmerOverlay extends StatelessWidget {
  final double progress;
  const _ShimmerOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    final x = -1.5 + progress * 3.0;
    return ShaderMask(
      blendMode: BlendMode.srcOver,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment(x - 0.3, -1),
        end: Alignment(x + 0.3, 1),
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(rect),
      child: Container(color: Colors.white),
    );
  }
}

/// Floating lift + glow border card hover wrapper
class HoverLiftCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final BorderRadius borderRadius;
  const HoverLiftCard({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF3B82F6),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _lift;
  late Animation<double> _glow;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _lift = Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _glow = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _lift.value),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor
                      .withValues(alpha: 0.12 + _glow.value * 0.25),
                  blurRadius: 8 + _glow.value * 24,
                  spreadRadius: _glow.value * 2,
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

/// Animated number counter  e.g. 0 → 12
class AnimatedCounter extends StatefulWidget {
  final int target;
  final String suffix;
  final TextStyle style;
  final Duration duration;
  const AnimatedCounter({
    super.key,
    required this.target,
    required this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.target.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Text(
        '${_anim.value.round()}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}
