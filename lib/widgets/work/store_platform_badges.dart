import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/production_app.dart';
import '../../theme/portfolio_theme.dart';

class StorePlatformBadges extends StatefulWidget {
  const StorePlatformBadges({
    super.key,
    this.playUrl,
    this.appStoreUrl,
    required this.onLaunch,
    this.releaseStatus = AppReleaseStatus.live,
  });

  final String? playUrl;
  final String? appStoreUrl;
  final Future<void> Function(String url) onLaunch;
  final AppReleaseStatus releaseStatus;

  static const appStoreAsset = 'assets/images/store_appstore.png';
  static const playStoreAsset = 'assets/images/store_playstore.png';

  @override
  State<StorePlatformBadges> createState() => _StorePlatformBadgesState();
}

class _StorePlatformBadgesState extends State<StorePlatformBadges> {
  static const _iconSize = 32.0;
  static const _iconGap = 6.0;
  static const _inReviewOpacity = 0.55;

  bool _assetsReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAssets();
  }

  Future<void> _precacheAssets() async {
    if (_assetsReady) return;
    await Future.wait([
      precacheImage(const AssetImage(StorePlatformBadges.appStoreAsset), context),
      precacheImage(const AssetImage(StorePlatformBadges.playStoreAsset), context),
    ]);
    if (mounted) setState(() => _assetsReady = true);
  }

  bool get _hasLiveUrls =>
      widget.playUrl != null || widget.appStoreUrl != null;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;

    if (widget.releaseStatus == AppReleaseStatus.inReview) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _storeBadgeImage(
            asset: StorePlatformBadges.appStoreAsset,
            p: p,
            dimmed: true,
          ),
          const SizedBox(width: _iconGap),
          _storeBadgeImage(
            asset: StorePlatformBadges.playStoreAsset,
            p: p,
            dimmed: true,
          ),
          const SizedBox(width: 10),
          _statusPill(
            p,
            icon: Icons.hourglass_top_outlined,
            label: 'In Review',
          ),
        ],
      );
    }

    if (widget.releaseStatus == AppReleaseStatus.launchingSoon || !_hasLiveUrls) {
      return _statusPill(
        p,
        icon: Icons.schedule_outlined,
        label: 'Launching Soon',
      );
    }

    final badges = <Widget>[];
    if (widget.appStoreUrl != null) {
      badges.add(
        _StoreBadge(
          onTap: () => widget.onLaunch(widget.appStoreUrl!),
          child: _storeBadgeImage(
            asset: StorePlatformBadges.appStoreAsset,
            p: p,
          ),
        ),
      );
    }
    if (widget.playUrl != null) {
      if (badges.isNotEmpty) badges.add(const SizedBox(width: _iconGap));
      badges.add(
        _StoreBadge(
          onTap: () => widget.onLaunch(widget.playUrl!),
          child: _storeBadgeImage(
            asset: StorePlatformBadges.playStoreAsset,
            p: p,
          ),
        ),
      );
    }

    if (badges.isEmpty) {
      return _statusPill(
        p,
        icon: Icons.schedule_outlined,
        label: 'Launching Soon',
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: badges,
    );
  }

  Widget _storeBadgeImage({
    required String asset,
    required PortfolioColors p,
    bool dimmed = false,
  }) {
    return Opacity(
      opacity: dimmed ? _inReviewOpacity : 1,
      child: SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: Image(
          image: AssetImage(asset),
          width: _iconSize,
          height: _iconSize,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported_outlined,
            size: _iconSize * 0.7,
            color: p.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _statusPill(
    PortfolioColors p, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: p.border.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: p.textMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: PortfolioFontSizes.label,
              fontWeight: FontWeight.w500,
              color: p.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreBadge extends StatefulWidget {
  const _StoreBadge({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<_StoreBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _hovered ? 1 : 0.88,
          child: widget.child,
        ),
      ),
    );
  }
}
