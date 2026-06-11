import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/work_screen.dart';
import '../screens/experience_screen.dart';
import '../screens/contact_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => _NotFoundScreen(path: state.uri.toString()),
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (c, s) => _slide(s, const HomeScreen()),
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (c, s) => _slide(s, const AboutScreen()),
        ),
        GoRoute(path: '/profile', redirect: (c, s) => '/about?section=profile'),
        GoRoute(path: '/skills', redirect: (c, s) => '/about?section=skills'),
        GoRoute(
          path: '/work',
          pageBuilder: (c, s) => _slide(s, const WorkScreen()),
        ),
        GoRoute(path: '/apps', redirect: (c, s) => '/work?section=apps'),
        GoRoute(
          path: '/projects',
          redirect: (c, s) => '/work?section=projects',
        ),
        GoRoute(
          path: '/experience',
          pageBuilder: (c, s) => _slide(s, const ExperienceScreen()),
        ),
        GoRoute(path: '/awards', redirect: (c, s) => '/work?section=awards'),
        GoRoute(
          path: '/testimonials',
          redirect: (c, s) => '/about?section=testimonials',
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
  ('Work', '/work'),
  ('Experience', '/experience'),
  ('About', '/about'),
  ('Contact', '/contact'),
];

bool _navMatches(Uri loc, String target) {
  switch (target) {
    case '/':
      return loc.path == '/' || loc.path.isEmpty;
    case '/work':
      return loc.path == '/work';
    case '/experience':
      return loc.path == '/experience';
    case '/about':
      return loc.path == '/about';
    default:
      return loc.path == target;
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _PortfolioAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _PortfolioAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<_PortfolioAppBar> createState() => _PortfolioAppBarState();
}

class _PortfolioAppBarState extends State<_PortfolioAppBar> {
  static const _staticTitle = 'Phyo Wai Kyaw · Flutter Developer';
  static const _nameText = 'Phyo Wai Kyaw';
  static const _roleTexts = ['Flutter Developer', 'Mobile Developer'];

  int _idx = 0;
  int _roleIdx = 0;

  String get _currentTarget =>
      _idx == 0 ? _nameText : _roleTexts[_roleIdx];

  String get _brandAvatarAsset {
    if (_reducedMotion || _idx == 0) return 'assets/images/phyo.jpg';
    return _roleIdx == 0
        ? 'assets/images/flutter_icon.png'
        : 'assets/images/3.png';
  }
  String _displayText = '';
  bool _showCaret = false;
  bool _caretVisible = true;
  double _opacity = 1.0;
  bool _reducedMotion = false;
  bool _typingInitialized = false;

  Timer? _typingTimer;
  Timer? _caretTimer;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _caretTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted || !_showCaret) return;
      setState(() => _caretVisible = !_caretVisible);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldReduce = MediaQuery.of(context).disableAnimations;
    if (_typingInitialized && shouldReduce == _reducedMotion) return;

    _typingInitialized = true;
    _reducedMotion = shouldReduce;
    _cancelTypingTimers();

    if (_reducedMotion) {
      setState(() {
        _displayText = _staticTitle;
        _showCaret = false;
        _opacity = 1.0;
      });
      return;
    }

    setState(() {
      _idx = 0;
      _roleIdx = 0;
      _displayText = '';
      _showCaret = true;
      _opacity = 1.0;
    });
    _startTypingCurrent();
  }

  void _cancelTypingTimers() {
    _typingTimer?.cancel();
    _holdTimer?.cancel();
  }

  int _charDelayFor(int index) => index == 0 ? 22 : 26;

  void _startTypingCurrent() {
    if (_reducedMotion || !mounted) return;

    _typingTimer?.cancel();
    _holdTimer?.cancel();

    _typingTimer = Timer.periodic(
      Duration(milliseconds: _charDelayFor(_idx)),
      (t) {
        if (!mounted || _reducedMotion) {
          t.cancel();
          return;
        }
        final target = _currentTarget;
        setState(() {
          if (_displayText.length < target.length) {
            _displayText = target.substring(0, _displayText.length + 1);
            _showCaret = true;
          } else {
            t.cancel();
            _showCaret = false;
            _holdTimer = Timer(
              const Duration(milliseconds: 2200),
              _fadeToNextPhrase,
            );
          }
        });
      },
    );
  }

  void _fadeToNextPhrase() {
    if (!mounted || _reducedMotion) return;
    setState(() => _opacity = 0.0);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted || _reducedMotion) return;
      setState(() {
        if (_idx == 0) {
          _idx = 1;
        } else {
          _idx = 0;
          _roleIdx = (_roleIdx + 1) % _roleTexts.length;
        }
        _displayText = '';
        _opacity = 1.0;
        _showCaret = true;
      });
      _startTypingCurrent();
    });
  }

  @override
  void dispose() {
    _cancelTypingTimers();
    _caretTimer?.cancel();
    super.dispose();
  }

  Widget _caret(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _caretVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 100),
      child: Text(
        '|',
        style: TextStyle(
          fontSize: isDesktop ? 17 : 15,
          fontWeight: FontWeight.w300,
          color: const Color(0xFF60A5FA),
        ),
      ),
    );
  }

  Widget _typingTitle({required bool isDesktop}) {
    if (_reducedMotion) {
      return Text(
        _staticTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isDesktop ? 17 : 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    final isRole = _idx == 1;
    return SizedBox(
      width: isDesktop ? 210 : 168,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 17 : 15,
                    fontWeight: isRole ? FontWeight.w600 : FontWeight.bold,
                    color: isRole ? const Color(0xFF93C5FD) : Colors.white,
                  ),
                ),
              ),
              if (_showCaret) _caret(isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandAvatar() {
    final asset = _brandAvatarAsset;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(asset),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            asset,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Breakpoints:
    //   < 768  → mobile  → hamburger menu
    //   768–1100 → tablet → hamburger menu  ← FIX
    //   > 1100 → desktop → full nav row
    final isDesktop = width >= 1100;
    final uri = GoRouterState.of(context).uri;

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
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 12),
          child: isDesktop
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final leftBand = (w * 0.34).clamp(
                      320.0,
                      440.0,
                    ); // typing + avatar
                    final showTrailingContact = w >= 1240;
                    final desktopNavItems = showTrailingContact
                        ? _navItems
                            .where((e) => e.$2 != '/contact')
                            .toList()
                        : _navItems;

                    return SizedBox(
                      height: 52,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: leftBand + 6,
                                  right: showTrailingContact ? 168 : 10,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final e in desktopNavItems)
                                        _NavBtn(
                                          label: e.$1,
                                          route: e.$2,
                                          currentUri: uri,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => context.go('/'),
                              child: SizedBox(
                                width: leftBand,
                                child: Row(
                                  children: [
                                    _brandAvatar(),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              _typingTitle(isDesktop: true),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (showTrailingContact)
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _DesktopContactCta(currentUri: uri),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )
              : Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.go('/'),
                        child: Row(
                          children: [
                            _brandAvatar(),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: _typingTitle(isDesktop: false),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _HamburgerMenu(currentUri: uri),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Hamburger menu (mobile + tablet) ─────────────────────────────────────────
class _HamburgerMenu extends StatefulWidget {
  final Uri currentUri;

  const _HamburgerMenu({required this.currentUri});

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
                            final active = _navMatches(widget.currentUri, e.$2);
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

// ── Desktop-only CTA (replaces duplicate "Contact" in center nav) ─────────────
class _DesktopContactCta extends StatefulWidget {
  final Uri currentUri;

  const _DesktopContactCta({required this.currentUri});

  @override
  State<_DesktopContactCta> createState() => _DesktopContactCtaState();
}

class _DesktopContactCtaState extends State<_DesktopContactCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = _navMatches(widget.currentUri, '/contact');
    return Tooltip(
      message: 'Email & professional links',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => context.go('/contact'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF38BDF8),
                  Color(0xFF3B82F6),
                  Color(0xFF8B5CF6),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                if (_hover || active)
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(
                      alpha: active ? 0.42 : 0.28,
                    ),
                    blurRadius: active ? 18 : 12,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(1.25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.75),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: active
                      ? [
                          const Color(0xFF1D4ED8).withValues(alpha: 0.55),
                          const Color(0xFF312E81).withValues(alpha: 0.72),
                        ]
                      : [
                          const Color(0xFF0F172A).withValues(alpha: 0.96),
                          const Color(0xFF0A0E27).withValues(alpha: 0.98),
                        ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (_hover || active)
                              ? const Color(0xFF67E8F9)
                              : const Color(0xFF7DD3FC),
                          const Color(0xFF2563EB),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF38BDF8).withValues(
                            alpha: active ? 0.85 : 0.45,
                          ),
                          blurRadius: active ? 10 : 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Get in touch',
                    style: TextStyle(
                      color: (_hover || active)
                          ? Colors.white
                          : const Color(0xFFE2E8F0),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Nav Button (desktop only) ─────────────────────────────────────────────────
class _NavBtn extends StatefulWidget {
  final String label, route;
  final Uri currentUri;

  const _NavBtn({
    required this.label,
    required this.route,
    required this.currentUri,
  });

  @override
  State<_NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<_NavBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final active = _navMatches(widget.currentUri, widget.route);
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

class _NotFoundScreen extends StatelessWidget {
  final String path;
  const _NotFoundScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFF60A5FA),
                size: 54,
              ),
              const SizedBox(height: 14),
              const Text(
                'Page not found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'No route matches: $path',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
