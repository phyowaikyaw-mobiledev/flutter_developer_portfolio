import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';

class GoogleMapEmbed extends StatefulWidget {
  const GoogleMapEmbed({
    super.key,
    required this.embedUrl,
    required this.openUrl,
    this.height = 360,
  });

  final String embedUrl;
  final String openUrl;
  final double height;

  @override
  State<GoogleMapEmbed> createState() => _GoogleMapEmbedState();
}

class _GoogleMapEmbedState extends State<GoogleMapEmbed> {
  static int _viewCounter = 0;
  late final String _viewType;

  // Click-to-activate: by default the map behaves like a static card (hover
  // + scroll pass through to the page's Scrollable, same as the old
  // permanent-overlay fix). Clicking down anywhere on it "engages" the map,
  // removing the overlay so the iframe underneath gets direct pointer/wheel
  // events for live drag-to-pan and scroll-to-zoom - exactly like interacting
  // with Google Maps directly. Moving the mouse off the widget disengages it
  // again, so the next hover safely defaults back to scroll-through.
  bool _engaged = false;

  @override
  void initState() {
    super.initState();
    _viewType = 'google-map-embed-${_viewCounter++}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final iframe = html.IFrameElement()
        ..src = widget.embedUrl
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..allowFullscreen = true;
      iframe.setAttribute('loading', 'lazy');
      return iframe;
    });
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: MouseRegion(
          onExit: (_) {
            if (_engaged) setState(() => _engaged = false);
          },
          child: Stack(
            children: [
              HtmlElementView(viewType: _viewType),
              // The iframe above is a platform view: while un-engaged, pointer
              // /wheel events over it would go straight to the embedded Google
              // Maps page (which grabs wheel scroll for its own zoom),
              // bypassing Flutter's scrolling entirely. This transparent
              // overlay is an ordinary Flutter widget instead, so it owns
              // interaction over the map by default - wheel/drag events
              // bubble into the page's scrollable like any other card.
              // Pressing down "engages" the map, removing this overlay so the
              // iframe gets live drag-to-pan/scroll-to-zoom directly.
              if (!_engaged)
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (_) => setState(() => _engaged = true),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              // Always tappable regardless of engaged state, independent of
              // hover-exit (which doesn't apply on mobile/touch), so there's
              // still a guaranteed one-tap way to open the full map.
              Positioned(
                right: 12,
                bottom: 12,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _launch(widget.openUrl),
                    child: _openInMapsHint(p),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _openInMapsHint(PortfolioColors p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.open_in_new, size: 16, color: p.textPrimary),
          const SizedBox(width: 6),
          Text(
            'Open in Maps',
            style: TextStyle(
              fontSize: PortfolioFontSizes.label,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
