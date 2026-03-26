import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Global set to remember which counters have already animated.
// Key = counter's unique key string → stays alive across navigations.
final _completedCounters = <String>{};

class CounterNumber extends StatefulWidget {
  final int target;
  final String suffix;
  final TextStyle style;
  final Duration duration;

  const CounterNumber({
    super.key,
    required this.target,
    this.suffix = '',
    required this.style,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<CounterNumber> createState() => _CounterNumberState();
}

class _CounterNumberState extends State<CounterNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  // Stable key string derived from widget.key or target+suffix
  String get _id =>
      widget.key != null ? widget.key.toString() : '${widget.target}${widget.suffix}';

  bool get _alreadyDone => _completedCounters.contains(_id);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutExpo)
        .drive(Tween(begin: 0.0, end: widget.target.toDouble()));

    // If this counter already completed before, jump straight to end value.
    if (_alreadyDone) {
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _trigger() {
    if (_alreadyDone) return; // already counted once — do nothing
    _completedCounters.add(_id);
    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? ValueKey(_id),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) _trigger();
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Text(
          '${_anim.value.round()}${widget.suffix}',
          style: widget.style,
        ),
      ),
    );
  }
}