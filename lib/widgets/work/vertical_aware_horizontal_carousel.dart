import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _ScrollAxis { undecided, horizontal, vertical }

/// Native horizontal [ListView] with axis-lock so vertical page scroll
/// passes through while horizontal swipes use real scroll physics.
class VerticalAwareHorizontalCarousel extends StatefulWidget {
  const VerticalAwareHorizontalCarousel({
    super.key,
    required this.itemExtent,
    required this.separatorWidth,
    required this.itemCount,
    required this.itemBuilder,
    this.onProgressChanged,
  });

  final double itemExtent;
  final double separatorWidth;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ValueChanged<double>? onProgressChanged;

  @override
  State<VerticalAwareHorizontalCarousel> createState() =>
      _VerticalAwareHorizontalCarouselState();
}

class _VerticalAwareHorizontalCarouselState
    extends State<VerticalAwareHorizontalCarousel> {
  static const _sessionIdleMs = 120;
  static const _lockThreshold = 6.0;

  final _scrollController = ScrollController();

  Timer? _sessionIdleTimer;
  double _accumDx = 0;
  double _accumDy = 0;
  _ScrollAxis _lockedAxis = _ScrollAxis.undecided;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _sessionIdleTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final progress =
        max > 0 ? (_scrollController.offset / max).clamp(0.0, 1.0).toDouble() : 0.0;
    widget.onProgressChanged?.call(progress);
  }

  void _resetSessionState() {
    if (_lockedAxis == _ScrollAxis.undecided &&
        _accumDx == 0 &&
        _accumDy == 0) {
      return;
    }
    setState(() {
      _lockedAxis = _ScrollAxis.undecided;
      _accumDx = 0;
      _accumDy = 0;
    });
  }

  void _onSessionIdle() {
    _resetSessionState();
  }

  void _scheduleSessionEnd() {
    _sessionIdleTimer?.cancel();
    _sessionIdleTimer = Timer(
      const Duration(milliseconds: _sessionIdleMs),
      _onSessionIdle,
    );
  }

  void _lockAxis(_ScrollAxis axis) {
    if (_lockedAxis == axis) return;
    setState(() => _lockedAxis = axis);
  }

  void _updateAxisLockFromScroll(PointerScrollEvent event) {
    final dy = event.scrollDelta.dy;
    final dx = event.scrollDelta.dx;
    final shift = HardwareKeyboard.instance.isShiftPressed;

    if (shift && dy != 0) {
      _lockAxis(_ScrollAxis.horizontal);
      _scheduleSessionEnd();
      return;
    }

    if (_lockedAxis == _ScrollAxis.vertical) {
      _scheduleSessionEnd();
      return;
    }

    if (_lockedAxis == _ScrollAxis.horizontal) {
      _scheduleSessionEnd();
      return;
    }

    _accumDx += dx;
    _accumDy += dy;

    if (_accumDx.abs() >= _lockThreshold || _accumDy.abs() >= _lockThreshold) {
      if (_accumDx.abs() >= _accumDy.abs()) {
        _lockAxis(_ScrollAxis.horizontal);
      } else {
        _lockAxis(_ScrollAxis.vertical);
      }
      _accumDx = 0;
      _accumDy = 0;
    }

    _scheduleSessionEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _updateAxisLockFromScroll(event);
        }
      },
      child: IgnorePointer(
        ignoring: _lockedAxis == _ScrollAxis.vertical,
        child: ScrollConfiguration(
          behavior: const _CarouselDragBehavior(),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            clipBehavior: Clip.hardEdge,
            itemCount: widget.itemCount,
            separatorBuilder: (_, __) =>
                SizedBox(width: widget.separatorWidth),
            itemBuilder: (context, index) => SizedBox(
              width: widget.itemExtent,
              child: widget.itemBuilder(context, index),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselDragBehavior extends MaterialScrollBehavior {
  const _CarouselDragBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
