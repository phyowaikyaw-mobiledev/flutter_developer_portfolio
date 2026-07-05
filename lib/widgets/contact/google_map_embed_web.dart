import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}
