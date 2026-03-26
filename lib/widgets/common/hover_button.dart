import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isMobile, filled, accent;
  final VoidCallback onTap;
  const HoverButton({super.key, required this.label, required this.icon,
    required this.isMobile, required this.filled, required this.onTap,
    this.accent = false});
  @override State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit:  (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _h ? -3 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 24 : 28,
            vertical:   widget.isMobile ? 12 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.filled
                ? (_h ? const Color(0xFF2563EB) : const Color(0xFF3B82F6))
                : (_h
                    ? (widget.accent
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.1))
                    : Colors.transparent),
            border: widget.filled ? null : Border.all(
              color: widget.accent
                  ? const Color(0xFF3B82F6)
                  : (_h ? Colors.white : Colors.white70),
              width: 1.5),
            boxShadow: _h && widget.filled
                ? [BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                    blurRadius: 20, offset: const Offset(0, 6))]
                : [],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, size: 16,
              color: widget.filled ? Colors.white
                  : (widget.accent ? const Color(0xFF3B82F6) : Colors.white)),
            const SizedBox(width: 8),
            Text(widget.label, style: TextStyle(
              fontSize: widget.isMobile ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: widget.filled ? Colors.white
                  : (widget.accent ? const Color(0xFF3B82F6) : Colors.white),
            )),
          ]),
        ),
      ),
    );
  }
}
