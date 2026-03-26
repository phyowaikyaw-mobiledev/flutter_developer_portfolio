import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/skills_screen.dart';
import '../screens/apps_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/experience_screen.dart';
import '../screens/awards_screen.dart';
import '../screens/testimonials_screen.dart';
import '../screens/contact_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (c, s) => _slide(s, const HomeScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (c, s) => _slide(s, const ProfileScreen()),
        ),
        GoRoute(
          path: '/skills',
          pageBuilder: (c, s) => _slide(s, const SkillsScreen()),
        ),
        GoRoute(
          path: '/apps',
          pageBuilder: (c, s) => _slide(s, const AppsScreen()),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (c, s) => _slide(s, const ProjectsScreen()),
        ),
        GoRoute(
          path: '/experience',
          pageBuilder: (c, s) => _slide(s, const ExperienceScreen()),
        ),
        GoRoute(
          path: '/awards',
          pageBuilder: (c, s) => _slide(s, const AwardsScreen()),
        ),
        GoRoute(
          path: '/testimonials',
          pageBuilder: (c, s) => _slide(s, const TestimonialsScreen()),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (c, s) => _slide(s, const ContactScreen()),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// ── Shell ─────────────────────────────────────────────────────────────────────
class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    appBar: const _PortfolioAppBar(),
    body: child,
  );
}

// ── Nav items list ────────────────────────────────────────────────────────────
const _navItems = [
  ('~/', '/'),
  ('Profile', '/profile'),
  ('Skills', '/skills'),
  ('Apps', '/apps'),
  ('Projects', '/projects'),
  ('Experience', '/experience'),
  ('Awards', '/awards'),
  ('Testimonials', '/testimonials'),
  ('Contact', '/contact'),
];

// ── AppBar ────────────────────────────────────────────────────────────────────
class _PortfolioAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _PortfolioAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<_PortfolioAppBar> createState() => _PortfolioAppBarState();
}

class _PortfolioAppBarState extends State<_PortfolioAppBar>
    with SingleTickerProviderStateMixin {
  int _idx = 0;
  String _text = '';
  bool _cursor = true;
  double _opacity = 1.0;
  Timer? _typingTimer, _cursorTimer;

  final _texts = ['Phyo Wai Kyaw', 'Flutter Developer', 'Mobile Developer'];
  final _avatars = [
    'assets/images/andrew.jpg',
    'assets/images/flutter_icon.png',
    'assets/images/3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startTyping();
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => mounted ? setState(() => _cursor = !_cursor) : null,
    );
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 20), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      final cur = _texts[_idx];
      setState(() {
        if (_text.length < cur.length) {
          _text = cur.substring(0, _text.length + 1);
        } else {
          t.cancel();
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (!mounted) return;
            setState(() => _opacity = 0.0);
            Future.delayed(const Duration(milliseconds: 350), () {
              if (!mounted) return;
              setState(() {
                _idx = (_idx + 1) % _texts.length;
                _text = '';
                _opacity = 1.0;
              });
              Future.delayed(const Duration(milliseconds: 80), () {
                if (mounted) _startTyping();
              });
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Breakpoints:
    //   < 768  → mobile  → hamburger menu
    //   768–1100 → tablet → hamburger menu  ← FIX
    //   > 1100 → desktop → full nav row
    final isDesktop = width >= 1100;
    final loc = GoRouterState.of(context).uri.toString();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27).withValues(alpha: 0.96),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
            blurRadius: 30,
          ),
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Logo ──
              GestureDetector(
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        key: ValueKey(_idx),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF3B82F6,
                              ).withValues(alpha: 0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            _avatars[_idx],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 350),
                      child: Text(
                        _text,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _cursor ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: Text(
                        '_',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Nav: desktop full row / tablet+mobile hamburger ──
              if (isDesktop)
                Row(
                  children: [
                    for (final e in _navItems)
                      _NavBtn(label: e.$1, route: e.$2, current: loc),
                  ],
                )
              else
                _HamburgerMenu(currentLoc: loc),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hamburger menu (mobile + tablet) ─────────────────────────────────────────
class _HamburgerMenu extends StatefulWidget {
  final String currentLoc;

  const _HamburgerMenu({required this.currentLoc});

  @override
  State<_HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<_HamburgerMenu>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _removeOverlay();
    _ctrl.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _toggle() {
    if (_open) {
      _ctrl.reverse().then((_) {
        _removeOverlay();
        setState(() => _open = false);
      });
    } else {
      setState(() => _open = true);
      _showOverlay();
      _ctrl.forward();
    }
  }

  void _close() {
    _ctrl.reverse().then((_) {
      _removeOverlay();
      setState(() => _open = false);
    });
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // Tap-outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Dropdown panel
            Positioned(
              top: offset.dy + size.height,
              right: 12,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1530),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.08),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _navItems.map((e) {
                            final active = widget.currentLoc == e.$2;
                            return _DropdownItem(
                              label: e.$1,
                              route: e.$2,
                              active: active,
                              onTap: () {
                                _close();
                                context.go(e.$2);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlay!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _open
              ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: _open
                ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _open ? Icons.close_rounded : Icons.menu_rounded,
            key: ValueKey(_open),
            color: _open ? const Color(0xFF3B82F6) : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ── Dropdown menu item ────────────────────────────────────────────────────────
class _DropdownItem extends StatefulWidget {
  final String label, route;
  final bool active;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.label,
    required this.route,
    required this.active,
    required this.onTap,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: widget.active
                ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                : (_h
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.08)
                      : Colors.transparent),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF1E3A6E).withValues(alpha: 0.4),
              ),
            ),
          ),
          child: Row(
            children: [
              if (widget.active)
                Container(
                  width: 3,
                  height: 16,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(width: 13),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.active
                      ? const Color(0xFF3B82F6)
                      : (_h ? Colors.white : Colors.white70),
                  fontSize: widget.label == '~/' ? 16 : 14,
                  fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: widget.label == '~/' ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav Button (desktop only) ─────────────────────────────────────────────────
class _NavBtn extends StatefulWidget {
  final String label, route, current;

  const _NavBtn({
    required this.label,
    required this.route,
    required this.current,
  });

  @override
  State<_NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<_NavBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.current == widget.route;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: active
                ? const Color(0xFF3B82F6).withValues(alpha: 0.18)
                : (_h
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.08)
                      : Colors.transparent),
            border: Border.all(
              color: active
                  ? const Color(0xFF3B82F6).withValues(alpha: 0.7)
                  : (_h
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                        : Colors.transparent),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: active
                  ? const Color(0xFF3B82F6)
                  : (_h ? Colors.white : Colors.white60),
              fontSize: widget.label == '~/' ? 16 : 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              fontFamily: widget.label == '~/' ? 'monospace' : null,
            ),
          ),
        ),
      ),
    );
  }
}
