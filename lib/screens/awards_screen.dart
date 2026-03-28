import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/reveal_animator.dart';

class AwardsScreen extends StatelessWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40, vertical: isMobile ? 80 : 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(children: [
                SectionTitle(title: 'Awards & Achievements', isMobile: isMobile),
                SizedBox(height: isMobile ? 20 : 30),
                RevealAnimator(child: _AwardCard(isMobile: isMobile)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Particle model ────────────────────────────────────────────────────────────
class _Particle {
  final double x;      // 0..1 relative to card width
  double y;            // 0..1 relative to card height (animates upward)
  final double size;
  final Color color;
  final double speed;
  final double wobble; // horizontal sine amplitude
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.wobble,
    required this.phase,
  });
}

// ── Award Card ────────────────────────────────────────────────────────────────
class _AwardCard extends StatefulWidget {
  final bool isMobile;
  const _AwardCard({required this.isMobile});
  @override
  State<_AwardCard> createState() => _AwardCardState();
}

class _AwardCardState extends State<_AwardCard> with TickerProviderStateMixin {
  bool _hovered = false;

  // Trophy spin + scale
  late AnimationController _trophyCtrl;
  late Animation<double> _trophySpin;
  late Animation<double> _trophyScale;

  // Border gradient rotation
  late AnimationController _borderCtrl;

  // Trophy glow pulse
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  // Particle system
  late AnimationController _particleCtrl;
  final List<_Particle> _particles = [];
  final _rng = math.Random();

  static const _gold = Color(0xFFFFD700);
  static const _amber = Color(0xFFFFA500);
  static const _goldLight = Color(0xFFFFF176);

  @override
  void initState() {
    super.initState();

    _trophyCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600)
    );

    _trophySpin = Tween(begin: -0.1, end: 0.1).animate(
        CurvedAnimation(
            parent: _trophyCtrl,
            curve: Curves.easeInOut
        )
    );

    _trophyScale = Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
            parent: _trophyCtrl,
            curve: Curves.elasticOut
        )
    );

    _borderCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat();

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _pulse = Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..addListener(_tickParticles);
  }

  void _spawnParticles() {
    _particles.clear();
    const colors = [_gold, _amber, _goldLight, Colors.white];
    for (int i = 0; i < 28; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: 0.75 + _rng.nextDouble() * 0.25, // start near bottom
        size: 3 + _rng.nextDouble() * 5,
        color: colors[_rng.nextInt(colors.length)],
        speed: 0.003 + _rng.nextDouble() * 0.006,
        wobble: 0.01 + _rng.nextDouble() * 0.025,
        phase: _rng.nextDouble() * math.pi * 2,
      ));
    }
  }

  void _tickParticles() {
    if (!mounted) return;
    final t = _particleCtrl.value * math.pi * 6;
    setState(() {
      for (final p in _particles) {
        p.y -= p.speed;
      }
      _particles.removeWhere((p) => p.y < -0.05);
    });
    if (t != t) {}// suppress unused warning
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _trophyCtrl.forward(from: 0);
    _spawnParticles();
    _particleCtrl.forward(from: 0);
  }

  void _onExit() {
    setState(() => _hovered = false);
    _particleCtrl.stop();
    setState(() => _particles.clear());
  }

  @override
  void dispose() {
    _trophyCtrl.dispose();
    _borderCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      // Mobile: tap toggles
      child: GestureDetector(
        onTap: widget.isMobile
            ? () => _hovered ? _onExit() : _onEnter()
            : null,
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [_trophyCtrl, _borderCtrl, _pulseCtrl, _particleCtrl]),
          builder: (context, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                // Background warms up on hover
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _hovered
                      ? [
                    _gold.withValues(alpha: 0.18),
                    const Color(0xFF1A0F00).withValues(alpha: 0.9),
                    _amber.withValues(alpha: 0.08),
                  ]
                      : [
                    _gold.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
                // Animated rotating border on hover, static on idle
                boxShadow: _hovered
                    ? [
                  BoxShadow(
                    color: _gold.withValues(
                        alpha: 0.25 + 0.2 * _pulse.value),
                    blurRadius: 40 + 20 * _pulse.value,
                    spreadRadius: 2 + 4 * _pulse.value,
                  ),
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.08),
                    blurRadius: 80,
                    spreadRadius: 10,
                  ),
                ]
                    : [
                  BoxShadow(
                      color: _gold.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 2),
                  BoxShadow(
                      color: _gold.withValues(alpha: 0.05),
                      blurRadius: 60,
                      spreadRadius: 10),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── Animated rotating border overlay ──────────────────
                  if (_hovered)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _RotatingBorderPainter(
                            progress: _borderCtrl.value,
                            radius: 24,
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: _gold.withValues(alpha: 0.4), width: 2),
                          ),
                        ),
                      ),
                    ),

                  // ── Floating particles ────────────────────────────────
                  if (_particles.isNotEmpty)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: LayoutBuilder(builder: (_, constraints) {
                          return CustomPaint(
                            painter: _ParticlePainter(
                              particles: _particles,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              tick: _particleCtrl.value,
                            ),
                          );
                        }),
                      ),
                    ),

                  // ── Main card content ─────────────────────────────────
                  Padding(
                    padding: EdgeInsets.all(
                        widget.isMobile ? 24 : 40),
                    child: Column(children: [
                      Row(children: [
                        // Trophy with spin + scale + glow
                        Transform.rotate(
                          angle: _trophySpin.value,
                          child: Transform.scale(
                            scale: _trophyScale.value,
                            child: Container(
                              padding: EdgeInsets.all(
                                  widget.isMobile ? 16 : 20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [_gold, _amber]),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _gold.withValues(
                                        alpha: _hovered
                                            ? 0.5 + 0.3 * _pulse.value
                                            : 0.5),
                                    blurRadius: _hovered
                                        ? 20 + 20 * _pulse.value
                                        : 20,
                                    spreadRadius: _hovered
                                        ? 2 + 4 * _pulse.value
                                        : 2,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.emoji_events,
                                  color: Colors.white,
                                  size: widget.isMobile ? 32 : 48),
                            ),
                          ),
                        ),
                        SizedBox(width: widget.isMobile ? 16 : 24),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('1st Runner Up',
                                    style: TextStyle(
                                      fontSize: widget.isMobile ? 22 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: _gold,
                                      shadows: _hovered
                                          ? [
                                        Shadow(
                                            color:
                                            _gold.withValues(alpha: 0.8),
                                            blurRadius: 12)
                                      ]
                                          : [],
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                    'Oway Travel Hackathon 2020 — Mandalay',
                                    style: TextStyle(
                                        fontSize: widget.isMobile ? 16 : 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                    'Organized by Phandeeyar Foundation | Myanmar',
                                    style: TextStyle(
                                        fontSize: widget.isMobile ? 12 : 14,
                                        color: Colors.white
                                            .withValues(alpha: 0.65))),
                              ]),
                        ),
                      ]),
                      SizedBox(height: widget.isMobile ? 24 : 32),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                        decoration: BoxDecoration(
                          color: _gold.withValues(
                              alpha: _hovered ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: _gold.withValues(
                                  alpha: _hovered ? 0.5 : 0.25)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(Icons.card_giftcard,
                                    color: _gold,
                                    size: widget.isMobile ? 20 : 24),
                                const SizedBox(width: 10),
                                Text('\$1,000 AWS Cloud Credits',
                                    style: TextStyle(
                                        fontSize: widget.isMobile ? 14 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ]),
                              SizedBox(height: widget.isMobile ? 12 : 16),
                              _detail('Achievement',
                                  '1st Runner Up among 20+ competing teams',
                                  widget.isMobile),
                              _detail('Project',
                                  'Developed functional travel application prototype under strict time constraints',
                                  widget.isMobile),
                              _detail('Skills Demonstrated',
                                  'Teamwork, problem-solving, rapid prototyping, and presentation skills',
                                  widget.isMobile),
                            ]),
                      ),
                      SizedBox(height: widget.isMobile ? 24 : 32),
                      Text('Hackathon Memories',
                          style: TextStyle(
                              fontSize: widget.isMobile ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: _gold)),
                      SizedBox(height: widget.isMobile ? 16 : 20),
                      widget.isMobile
                          ? Column(children: [
                        _photo('assets/images/hackathon_award.jpg',
                            'Award Ceremony', widget.isMobile),
                        const SizedBox(height: 16),
                        _photo('assets/images/hackathon_team.jpg',
                            'Team Heaven', widget.isMobile),
                      ])
                          : Row(children: [
                        Expanded(
                            child: _photo(
                                'assets/images/hackathon_award.jpg',
                                'Award Ceremony',
                                widget.isMobile)),
                        const SizedBox(width: 20),
                        Expanded(
                            child: _photo(
                                'assets/images/hackathon_team.jpg',
                                'Team Heaven',
                                widget.isMobile)),
                      ]),
                    ]),
                  ),

                  // Subtle luxury polish: top shine + corner accents
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _hovered ? 0.34 : 0.2,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _gold.withValues(alpha: 0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IgnorePointer(
                      child: _CornerAccent(color: _gold, hovered: _hovered),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IgnorePointer(
                      child: Transform.flip(
                        flipX: true,
                        child: _CornerAccent(color: _gold, hovered: _hovered),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _detail(String label, String value, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: EdgeInsets.only(top: isMobile ? 6 : 7),
            width: 6, height: 6,
            decoration: const BoxDecoration(
                color: _gold, shape: BoxShape.circle)),
        SizedBox(width: isMobile ? 10 : 12),
        Expanded(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextSpan(
                  text: value,
                  style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: Colors.white.withValues(alpha: 0.8))),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _photo(String path, String caption, bool isMobile) {
    return Column(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isMobile ? 200 : 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: _gold.withValues(alpha: _hovered ? 0.7 : 0.3),
              width: _hovered ? 2.5 : 2),
          boxShadow: [
            BoxShadow(
                color: _gold.withValues(
                    alpha: _hovered ? 0.2 : 0.08),
                blurRadius: _hovered ? 30 : 20)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(path,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.white.withValues(alpha: 0.05),
                child: Center(
                    child: Icon(Icons.image,
                        size: isMobile ? 40 : 60,
                        color: Colors.white.withValues(alpha: 0.3))),
              )),
        ),
      ),
      const SizedBox(height: 8),
      Text(caption,
          style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.white.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic)),
    ]);
  }
}

class _CornerAccent extends StatelessWidget {
  final Color color;
  final bool hovered;

  const _CornerAccent({required this.color, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(
        painter: _CornerAccentPainter(
          color: color.withValues(alpha: hovered ? 0.75 : 0.52),
        ),
      ),
    );
  }
}

class _CornerAccentPainter extends CustomPainter {
  final Color color;

  const _CornerAccentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.55, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerAccentPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ── Rotating gradient border painter ─────────────────────────────────────────
class _RotatingBorderPainter extends CustomPainter {
  final double progress; // 0..1 loops
  final double radius;
  const _RotatingBorderPainter(
      {required this.progress, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect =
    RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Rotating sweep gradient border
    final angle = progress * 2 * math.pi;
    final gradient = SweepGradient(
      startAngle: angle,
      endAngle: angle + math.pi * 2,
      colors: const [
        Color(0xFFFFD700),
        Color(0xFFFFA500),
        Color(0xFFFFF176),
        Color(0xFFFFD700),
        Colors.transparent,
        Colors.transparent,
        Color(0xFFFFD700),
      ],
      stops: const [0.0, 0.15, 0.3, 0.45, 0.5, 0.85, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RotatingBorderPainter old) =>
      old.progress != progress;
}

// ── Particle painter ──────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double width, height, tick;
  const _ParticlePainter({
    required this.particles,
    required this.width,
    required this.height,
    required this.tick,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final wobbleX =
          math.sin(tick * math.pi * 4 + p.phase) * p.wobble * size.width;
      final px = p.x * size.width + wobbleX;
      final py = p.y * size.height;
      final opacity = (p.y * 3).clamp(0.0, 1.0); // fade in near top

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill;

      // Alternate between circle and diamond shapes
      final idx = particles.indexOf(p);
      if (idx % 3 == 0) {
        // Diamond
        final path = Path()
          ..moveTo(px, py - p.size)
          ..lineTo(px + p.size * 0.6, py)
          ..lineTo(px, py + p.size)
          ..lineTo(px - p.size * 0.6, py)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(Offset(px, py), p.size * 0.6, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}