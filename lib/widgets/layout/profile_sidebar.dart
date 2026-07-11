import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/portfolio_theme.dart';
import '../../theme/theme_controller.dart';
import '../../utils/constants.dart';
import 'radar_active_dot.dart';

class ProfileSidebar extends StatefulWidget {
  const ProfileSidebar({super.key, this.compact = false});

  final bool compact;

  @override
  State<ProfileSidebar> createState() => _ProfileSidebarState();
}

class _ProfileSidebarState extends State<ProfileSidebar> {
  bool _expanded = false;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final compact = widget.compact;

    final card = Container(
      width: compact ? double.infinity : 300,
      padding: EdgeInsets.all(compact ? 16 : 28),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: compact ? _compactContent(p) : _fullContent(p),
    );

    if (!compact) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: 10,
          right: 10,
          child: _ExpandToggleButton(
            p: p,
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ),
      ],
    );
  }

  Widget _compactContent(PortfolioColors p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 36),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar(p, true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: p.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _RolePill(p: p),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 16),
          _SidebarInfoRow(
            p: p,
            icon: Icons.email_outlined,
            label: 'EMAIL',
            value: AppStrings.email,
            onTap: () => _launch('mailto:${AppStrings.email}'),
          ),
          const SizedBox(height: 10),
          _SidebarInfoRow(
            p: p,
            icon: Icons.location_on_outlined,
            label: 'LOCATION',
            value: AppStrings.location,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIconBtn.fa(
                p: p,
                url: AppStrings.github,
                faIcon: FontAwesomeIcons.github,
                onLaunch: _launch,
              ),
              const SizedBox(width: 12),
              _SocialIconBtn.fa(
                p: p,
                url: AppStrings.linkedin,
                faIcon: FontAwesomeIcons.linkedin,
                onLaunch: _launch,
              ),
              const SizedBox(width: 12),
              _SocialIconBtn.material(
                p: p,
                url: 'mailto:${AppStrings.email}',
                materialIcon: Icons.email_outlined,
                onLaunch: _launch,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _fullContent(PortfolioColors p) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _avatar(p, false),
        const SizedBox(height: 22),
        Text(
          AppStrings.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.role,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: p.textMuted,
          ),
        ),
        const SizedBox(height: 24),
        _SidebarInfoRow(
          p: p,
          icon: Icons.email_outlined,
          label: 'EMAIL',
          value: AppStrings.email,
          onTap: () => _launch('mailto:${AppStrings.email}'),
        ),
        const SizedBox(height: 10),
        _SidebarInfoRow(
          p: p,
          icon: Icons.location_on_outlined,
          label: 'LOCATION',
          value: AppStrings.location,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconBtn.fa(
              p: p,
              url: AppStrings.github,
              faIcon: FontAwesomeIcons.github,
              onLaunch: _launch,
            ),
            const SizedBox(width: 12),
            _SocialIconBtn.fa(
              p: p,
              url: AppStrings.linkedin,
              faIcon: FontAwesomeIcons.linkedin,
              onLaunch: _launch,
            ),
            const SizedBox(width: 12),
            _SocialIconBtn.material(
              p: p,
              url: 'mailto:${AppStrings.email}',
              materialIcon: Icons.email_outlined,
              onLaunch: _launch,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListenableBuilder(
          listenable: themeController,
          builder: (context, _) {
            final isDark = themeController.isDark;
            return IconButton(
              onPressed: themeController.toggle,
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: p.textMuted,
                size: 20,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _avatar(PortfolioColors p, bool compact) {
    final size = compact ? 56.0 : 160.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppStrings.avatarAsset,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: p.border,
                child: Icon(Icons.person, size: size * 0.4, color: p.textMuted),
              ),
            ),
          ),
          Positioned(
            right: compact ? 3 : 8,
            bottom: compact ? 3 : 8,
            child: RadarActiveDot(
              color: p.activeGreen,
              borderColor: p.cardBg,
              dotSize: compact ? 9 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.p});

  final PortfolioColors p;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: p.border.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Text(
        AppStrings.role,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: PortfolioFontSizes.caption,
          fontWeight: FontWeight.w600,
          color: p.textMuted,
        ),
      ),
    );
  }
}

class _ExpandToggleButton extends StatelessWidget {
  const _ExpandToggleButton({
    required this.p,
    required this.expanded,
    required this.onTap,
  });

  final PortfolioColors p;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: p.border),
          ),
          child: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: p.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarInfoRow extends StatefulWidget {
  const _SidebarInfoRow({
    required this.p,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final PortfolioColors p;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  State<_SidebarInfoRow> createState() => _SidebarInfoRowState();
}

class _SidebarInfoRowState extends State<_SidebarInfoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final tappable = widget.onTap != null;

    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? p.textMuted.withValues(alpha: 0.45)
                  : p.border,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: p.textMuted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.label,
                        fontWeight: FontWeight.w600,
                        color: p.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: p.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIconBtn extends StatefulWidget {
  const _SocialIconBtn.fa({
    required this.p,
    required this.url,
    required this.faIcon,
    required this.onLaunch,
  }) : materialIcon = null;

  const _SocialIconBtn.material({
    required this.p,
    required this.url,
    required this.materialIcon,
    required this.onLaunch,
  }) : faIcon = null;

  final PortfolioColors p;
  final String url;
  final FaIconData? faIcon;
  final IconData? materialIcon;
  final Future<void> Function(String url) onLaunch;

  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final color = _hovered ? p.textPrimary : p.textMuted;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onLaunch(widget.url),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: widget.faIcon != null
              ? FaIcon(widget.faIcon!, size: 18, color: color)
              : Icon(widget.materialIcon!, size: 18, color: color),
        ),
      ),
    );
  }
}
