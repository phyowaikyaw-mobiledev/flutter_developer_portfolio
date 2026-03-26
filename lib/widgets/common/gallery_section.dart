import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../carousel_dialog.dart';

class GallerySection extends StatelessWidget {
  final List<String> images;
  final Color accentColor;
  final bool isMobile;

  const GallerySection({
    super.key,
    required this.images,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ── Gallery header ──
      Row(children: [
        // gradient accent bar
        Container(
          width: 3, height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [accentColor, accentColor.withValues(alpha: 0.3)],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.5), blurRadius: 6)],
          ),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (b) => LinearGradient(
            colors: [accentColor, accentColor.withValues(alpha: 0.7)],
          ).createShader(b),
          child: const Text('GALLERY',
            style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: 2.0,
            )),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              accentColor.withValues(alpha: 0.4), Colors.transparent,
            ]),
          ),
        )),
        const SizedBox(width: 8),
        // image count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
          ),
          child: Text('${images.length} photos',
            style: TextStyle(fontSize: 10, color: accentColor, fontWeight: FontWeight.w600)),
        ),
      ]),
      const SizedBox(height: 12),
      // ── Gallery scroll ──
      SizedBox(
        height: isMobile ? 160 : 185,
        child: ScrollConfiguration(
          behavior: _DragBehavior(),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (ctx, i) => _GalleryThumb(
              path: images[i],
              index: i,
              total: images.length,
              accentColor: accentColor,
              isMobile: isMobile,
              onTap: () => showDialog(
                context: ctx,
                barrierColor: Colors.black.withValues(alpha: 0.92),
                builder: (_) => CarouselDialog(images: images, initialIndex: i),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _GalleryThumb extends StatefulWidget {
  final String path;
  final int index, total;
  final Color accentColor;
  final bool isMobile;
  final VoidCallback onTap;
  const _GalleryThumb({
    required this.path, required this.index, required this.total,
    required this.accentColor, required this.isMobile, required this.onTap,
  });
  @override State<_GalleryThumb> createState() => _GalleryThumbState();
}

class _GalleryThumbState extends State<_GalleryThumb>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // phone screenshot ratio ~9:19.5
    final w = widget.isMobile ? 80.0 : 95.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) { setState(() => _hovered = true); _ctrl.forward(); },
      onExit:  (_) { setState(() => _hovered = false); _ctrl.reverse(); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 10),
            width: w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? widget.accentColor
                    : Colors.white.withValues(alpha: 0.15),
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.4),
                        blurRadius: 16, spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Stack(children: [
              // full image
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset(
                  widget.path,
                  width: w, height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
                    child: Center(child: Icon(Icons.image_outlined,
                        color: Colors.white38, size: isMobile ? 22 : 28)),
                  ),
                ),
              ),
              // hover overlay
              if (_hovered)
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.zoom_in_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ),
              // index chip
              Positioned(
                bottom: 6, right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${widget.index + 1}/${widget.total}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  bool get isMobile => widget.isMobile;
}

class _DragBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch, PointerDeviceKind.mouse,
    PointerDeviceKind.stylus, PointerDeviceKind.trackpad,
  };
}
