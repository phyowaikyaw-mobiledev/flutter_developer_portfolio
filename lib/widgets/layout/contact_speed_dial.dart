import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';

const _kTeamsPurple = Color(0xFF6264A7);
const _kTelegramBlue = Color(0xFF26A5E4);
const _kClosedRed = Color(0xFFEF4444);
const _kMobileBreakpoint = 900.0;

class ContactSpeedDial extends StatefulWidget {
  const ContactSpeedDial({super.key});

  @override
  State<ContactSpeedDial> createState() => _ContactSpeedDialState();
}

class _ContactSpeedDialState extends State<ContactSpeedDial>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < _kMobileBreakpoint;
    final fabSize = isMobile ? 44.0 : 56.0;
    final itemSize = isMobile ? 38.0 : 44.0;
    final itemGap = isMobile ? 8.0 : 10.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          ScaleTransition(
            scale: _scale,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _DialItem(
                  size: itemSize,
                  label: 'MS Teams',
                  glowColor: _kTeamsPurple,
                  background: _kTeamsPurple,
                  icon: Image.asset(
                    'assets/icons/contact/teams.png',
                    width: itemSize * 0.59,
                    height: itemSize * 0.59,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: itemSize * 0.5,
                    ),
                  ),
                  onTap: () => _launch(AppStrings.teamsChat),
                ),
                SizedBox(height: itemGap),
                _DialItem(
                  size: itemSize,
                  label: 'Telegram',
                  glowColor: _kTelegramBlue,
                  background: Colors.transparent,
                  icon: FaIcon(
                    FontAwesomeIcons.telegram,
                    color: _kTelegramBlue,
                    size: itemSize * 0.86,
                  ),
                  onTap: () => _launch(AppStrings.telegram),
                ),
                SizedBox(height: itemGap),
                _DialItem(
                  size: itemSize,
                  label: 'Email',
                  glowColor: Colors.white,
                  background: const Color(0xFFF4F4F5),
                  icon: Icon(
                    Icons.email_outlined,
                    color: const Color(0xFF1E1E1E),
                    size: itemSize * 0.45,
                  ),
                  onTap: () => _launch('mailto:${AppStrings.email}'),
                ),
                SizedBox(height: isMobile ? 10 : 12),
              ],
            ),
          ),
        ],
        Stack(
          alignment: Alignment.center,
          children: [
            if (!_open) _RadarPulse(color: AppColors.primary, size: fabSize),
            _MainDialButton(
              open: _open,
              size: fabSize,
              iconSize: isMobile ? 20 : 24,
              onTap: _toggle,
            ),
          ],
        ),
      ],
    );
  }
}

/// The main FAB, reimplemented as a plain [Material] circle (instead of
/// [FloatingActionButton]) so its diameter can shrink on mobile - the stock
/// widget enforces a fixed 56/40px size via its own internal constraints.
/// Turns red with a close icon when open, so it doubles as the dial's only
/// close affordance (no separate close item needed).
class _MainDialButton extends StatelessWidget {
  const _MainDialButton({
    required this.open,
    required this.size,
    required this.iconSize,
    required this.onTap,
  });

  final bool open;
  final double size;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: open ? _kClosedRed : AppColors.primary,
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            open ? Icons.close : Icons.chat_bubble_outline,
            color: Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

/// Idle-state attention ripple behind the collapsed FAB - reuses the same
/// expanding-ring mechanic as the avatar's `RadarActiveDot`, but centered
/// behind a bigger button rather than corner-anchored on a small dot, so
/// it's kept as its own widget instead of extending that one. Rings hug
/// close to the button edge rather than ballooning outward.
class _RadarPulse extends StatefulWidget {
  const _RadarPulse({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<_RadarPulse>
    with SingleTickerProviderStateMixin {
  static const _ringCount = 2;
  static const _maxSpread = 9.0;

  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasSize = widget.size + _maxSpread * 2;
    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < _ringCount; i++) _ring(i / _ringCount),
          ],
        ),
      ),
    );
  }

  Widget _ring(double phaseOffset) {
    final progress = (_ctrl.value + phaseOffset) % 1.0;
    final size = widget.size + progress * _maxSpread * 2;
    final opacity = (1 - progress) * 0.6;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.color.withValues(alpha: opacity),
          width: 2,
        ),
      ),
    );
  }
}

/// A single expanded speed-dial button with a hover-revealed label pill and
/// brand-colored glow, matching the reference design.
class _DialItem extends StatefulWidget {
  const _DialItem({
    required this.size,
    required this.label,
    required this.icon,
    required this.background,
    required this.glowColor,
    required this.onTap,
  });

  final double size;
  final String label;
  final Widget icon;
  final Color background;
  final Color glowColor;
  final VoidCallback onTap;

  @override
  State<_DialItem> createState() => _DialItemState();
}

class _DialItemState extends State<_DialItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _hovered ? 1 : 0,
            child: _hovered
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _labelPill(),
                  )
                : const SizedBox.shrink(),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.background,
                  border: widget.background == Colors.transparent
                      ? null
                      : Border.all(color: const Color(0xFF3A3A3A)),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: widget.glowColor.withValues(alpha: 0.55),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(child: widget.icon),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Text(
        widget.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
