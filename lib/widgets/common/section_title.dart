import 'package:flutter/material.dart';
import 'reveal_animator.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isMobile;
  final String? subtitle;
  const SectionTitle({
    super.key,
    required this.title,
    required this.isMobile,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return RevealAnimator(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
            ).createShader(b),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: isMobile ? 10 : 14),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                color: Colors.white.withValues(alpha: 0.62),
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: isMobile ? 16 : 24),
          Container(
            width: isMobile ? 80 : 120,
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
