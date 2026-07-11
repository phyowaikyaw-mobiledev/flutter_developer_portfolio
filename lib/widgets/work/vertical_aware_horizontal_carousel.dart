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
      _claimHorizontalWheelEvent(event, dy);
      _scheduleSessionEnd();
      return;
    }

    if (_lockedAxis == _ScrollAxis.vertical) {
      _scheduleSessionEnd();
      return;
    }

    if (_lockedAxis == _ScrollAxis.horizontal) {
      _claimHorizontalWheelEvent(event, dx);
      _scheduleSessionEnd();
      return;
    }

    _accumDx += dx;
    _accumDy += dy;

    if (_accumDx.abs() >= _lockThreshold || _accumDy.abs() >= _lockThreshold) {
      if (_accumDx.abs() >= _accumDy.abs()) {
        _lockAxis(_ScrollAxis.horizontal);
        _claimHorizontalWheelEvent(event, dx);
      } else {
        _lockAxis(_ScrollAxis.vertical);
      }
      _accumDx = 0;
      _accumDy = 0;
    }

    _scheduleSessionEnd();
  }

  // Real trackpad swipes are never perfectly axis-aligned, so a "horizontal"
  // gesture still carries a small residual dy on every tick. Without this,
  // the ancestor page Scrollable independently registers with the resolver
  // for the very same event and reacts to that leftover dy, making the page
  // jitter up/down while the carousel is being swiped sideways. Registering
  // here (we're deeper in the tree than the ancestor) claims the event first,
  // so the ancestor's own registration for it becomes a no-op — see
  // PointerSignalResolver: "the first registered handler... corresponds to
  // the widget that's deepest in the widget hierarchy".
  void _claimHorizontalWheelEvent(PointerScrollEvent event, double dx) {
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {});
    _applyHorizontalWheelDelta(dx);
  }

  // --- Touch/mouse-drag/stylus pan handling ---
  //
  // The wheel-only path above only ever fires for trackpad/mouse-wheel
  // signals, so touch drags never lock an axis there. This pan-based path
  // handles all pointer kinds and drives scrolling manually: once locked
  // horizontal it scrolls this carousel directly, and once locked vertical
  // it forwards the delta to the ancestor page scrollable so the page keeps
  // scrolling instead of getting stuck under the carousel.

  void _onPanDown(DragDownDetails details) {
    _sessionIdleTimer?.cancel();
    _accumDx = 0;
    _accumDy = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _sessionIdleTimer?.cancel();
    final dx = details.delta.dx;
    final dy = details.delta.dy;

    if (_lockedAxis == _ScrollAxis.undecided) {
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
      } else {
        _scheduleSessionEnd();
        return;
      }
    }

    if (_lockedAxis == _ScrollAxis.horizontal) {
      _applyHorizontalDelta(dx);
    } else if (_lockedAxis == _ScrollAxis.vertical) {
      _applyVerticalDeltaToAncestor(dy);
    }

    _scheduleSessionEnd();
  }

  void _onPanEnd(DragEndDetails details) {
    if (_lockedAxis == _ScrollAxis.horizontal && _scrollController.hasClients) {
      final position = _scrollController.position;
      final flingDistance = -details.velocity.pixelsPerSecond.dx * 0.3;
      final target = (position.pixels + flingDistance)
          .clamp(position.minScrollExtent, position.maxScrollExtent);
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
    // Vertical case: we stop driving the ancestor position here and let its
    // own ballistic physics (from the user's next gesture) take over.
    _scheduleSessionEnd();
  }

  void _applyHorizontalDelta(double dx) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (position.pixels - dx)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    _scrollController.jumpTo(target);
  }

  // Wheel/trackpad scroll deltas use the opposite sign convention from pan
  // deltas: native Scrollable applies `pixels + delta` for PointerScrollEvent
  // (see Scrollable._targetScrollOffsetForPointerScroll), vs `pixels - dx`
  // for drag deltas above. Needed because NeverScrollableScrollPhysics below
  // also disables the ListView's own native pointer-signal scroll handling
  // (Scrollable._receivedPointerSignal gates on physics.shouldAcceptUserOffset),
  // so we have to drive the scroll ourselves here too.
  void _applyHorizontalWheelDelta(double dx) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (position.pixels + dx)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    _scrollController.jumpTo(target);
  }

  void _applyVerticalDeltaToAncestor(double dy) {
    final scrollable = Scrollable.of(context, axis: Axis.vertical);
    final position = scrollable.position;
    final target = (position.pixels - dy)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    position.jumpTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            _updateAxisLockFromScroll(event);
          }
        },
        child: IgnorePointer(
          ignoring: _lockedAxis == _ScrollAxis.vertical,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
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
