import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CarouselDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const CarouselDialog({super.key, required this.images, required this.initialIndex});
  @override State<CarouselDialog> createState() => _CarouselDialogState();
}

class _CarouselDialogState extends State<CarouselDialog> {
  late int _cur;
  late PageController _ctrl;
  @override void initState() {
    super.initState();
    _cur = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.93),
        body: SafeArea(child: Stack(children: [
          Center(child: GestureDetector(
            onTap: () {},
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: PageView.builder(
                  controller: _ctrl, itemCount: total,
                  onPageChanged: (i) => setState(() => _cur = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(widget.images[i], fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.white38, size: 60))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(total, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _cur ? 28 : 8, height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: i == _cur
                        ? const LinearGradient(colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)])
                        : null,
                    color: i == _cur ? null : Colors.white.withValues(alpha: 0.25),
                    boxShadow: i == _cur
                        ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.6), blurRadius: 8)]
                        : null,
                  ),
                ))),
              const SizedBox(height: 10),
              Text('${_cur + 1} / $total',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: PortfolioFontSizes.secondary)),
            ]),
          )),
          Positioned(top: 16, right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20)),
            )),
          if (total > 1) ...[
            Positioned(left: 10, top: 0, bottom: 0, child: Center(
              child: GestureDetector(
                onTap: () { if (_cur > 0) _ctrl.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut); },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _cur > 0
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    boxShadow: _cur > 0
                        ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.4), blurRadius: 12)]
                        : [],
                  ),
                  child: Icon(Icons.chevron_left,
                    color: _cur > 0 ? Colors.white : Colors.white30, size: 26)),
              ))),
            Positioned(right: 10, top: 0, bottom: 0, child: Center(
              child: GestureDetector(
                onTap: () { if (_cur < total - 1) _ctrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut); },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _cur < total - 1
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    boxShadow: _cur < total - 1
                        ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.4), blurRadius: 12)]
                        : [],
                  ),
                  child: Icon(Icons.chevron_right,
                    color: _cur < total - 1 ? Colors.white : Colors.white30, size: 26)),
              ))),
          ],
        ])),
      ),
    );
  }
}
