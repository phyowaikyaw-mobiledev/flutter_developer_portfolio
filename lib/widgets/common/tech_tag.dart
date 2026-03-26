import 'package:flutter/material.dart';

class TechTag extends StatefulWidget {
  final String label;
  final bool isMobile;
  const TechTag({super.key, required this.label, required this.isMobile});
  @override State<TechTag> createState() => _TechTagState();
}

class _TechTagState extends State<TechTag> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit:  (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _h
              ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
              : const Color(0xFF1E40AF).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _h ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6).withValues(alpha: 0.5)),
          boxShadow: _h
              ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.25), blurRadius: 8)]
              : [],
        ),
        child: Text(widget.label, style: TextStyle(
          fontSize: widget.isMobile ? 12 : 13,
          color: _h ? Colors.white : Colors.white.withValues(alpha: 0.85),
          fontWeight: _h ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}
