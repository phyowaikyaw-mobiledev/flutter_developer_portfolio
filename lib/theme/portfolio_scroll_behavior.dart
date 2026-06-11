import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Enables drag-to-scroll for carousels with mouse & trackpad on web/desktop,
/// not only touch (default [MaterialScrollBehavior] is more restrictive).
class PortfolioScrollBehavior extends MaterialScrollBehavior {
  const PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
