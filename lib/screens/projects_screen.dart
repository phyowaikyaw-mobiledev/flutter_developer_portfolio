import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_projects.dart';
import '../models/portfolio_project.dart';
import '../utils/constants.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/gallery_section.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key, this.embeddedInWork = false});

  /// When shown inside [WorkScreen] tabs, skip extra top inset (shell + tab bar).
  final bool embeddedInWork;

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final featuredProjects =
        kPortfolioProjects.where((project) => project.featured).toList();
    final learningArchive = kPortfolioProjects
        .where((project) => project.learningArchive)
        .toList();
    final otherProjects = kPortfolioProjects
        .where((project) => !project.featured && !project.learningArchive)
        .toList();

    final body = SingleChildScrollView(
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: embeddedInWork
                ? (isMobile ? 20 : 28)
                : (isMobile ? 80 : 100),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SectionTitle(
                    title: 'Projects & demos',
                    isMobile: isMobile,
                    subtitle:
                        'Featured builds, live demos, and additional experiments.',
                  ),
                  SizedBox(height: isMobile ? 20 : 26),
                  _ProjectSectionLabel(
                    title: 'Featured Projects',
                    subtitle:
                        'Selected work with strongest real-world impact and quality.',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 14 : 18),
                  isMobile
                      ? Column(
                          children: featuredProjects
                              .asMap()
                              .entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: RevealAnimator(
                                    delay: Duration(milliseconds: 50 * e.key),
                                    child: _ProjectCard(
                                      project: e.value,
                                      isMobile: isMobile,
                                      launch: _launch,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 500,
                              ),
                          itemCount: featuredProjects.length,
                          itemBuilder: (_, i) => RevealAnimator(
                            delay: Duration(milliseconds: 60 * (i % 2)),
                            child: _ProjectCard(
                              project: featuredProjects[i],
                              isMobile: isMobile,
                              launch: _launch,
                            ),
                          ),
                        ),
                  if (learningArchive.isNotEmpty) ...[
                    SizedBox(height: isMobile ? 24 : 34),
                    _ProjectSectionLabel(
                      title: 'Learning Archive',
                      subtitle:
                          'UI studies and beginner projects — kept for growth context.',
                      isMobile: isMobile,
                    ),
                    SizedBox(height: isMobile ? 14 : 18),
                    isMobile
                        ? Column(
                            children: learningArchive
                                .asMap()
                                .entries
                                .map(
                                  (e) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16),
                                    child: RevealAnimator(
                                      delay:
                                          Duration(milliseconds: 50 * e.key),
                                      child: _ProjectCard(
                                        project: e.value,
                                        isMobile: isMobile,
                                        launch: _launch,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 500,
                            ),
                            itemCount: learningArchive.length,
                            itemBuilder: (_, i) => RevealAnimator(
                              delay: Duration(milliseconds: 60 * (i % 2)),
                              child: _ProjectCard(
                                project: learningArchive[i],
                                isMobile: isMobile,
                                launch: _launch,
                              ),
                            ),
                          ),
                  ],
                  SizedBox(height: isMobile ? 24 : 34),
                  _ProjectSectionLabel(
                    title: 'Other Projects',
                    subtitle:
                        'Additional apps and experiments beyond featured work.',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 14 : 18),
                  isMobile
                      ? Column(
                          children: otherProjects
                              .asMap()
                              .entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: RevealAnimator(
                                    delay: Duration(milliseconds: 50 * e.key),
                                    child: _ProjectCard(
                                      project: e.value,
                                      isMobile: isMobile,
                                      launch: _launch,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 500,
                              ),
                          itemCount: otherProjects.length,
                          itemBuilder: (_, i) => RevealAnimator(
                            delay: Duration(milliseconds: 60 * (i % 2)),
                            child: _ProjectCard(
                              project: otherProjects[i],
                              isMobile: isMobile,
                              launch: _launch,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
    );

    if (embeddedInWork) {
      return ColoredBox(color: AppColors.background, child: body);
    }
    return Scaffold(backgroundColor: AppColors.background, body: body);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ProjectSectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isMobile;

  const _ProjectSectionLabel({
    required this.title,
    required this.subtitle,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              color: Colors.white.withValues(alpha: 0.58),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ProjectCard extends StatelessWidget {
  final PortfolioProject project;
  final bool isMobile;
  final void Function(String) launch;

  const _ProjectCard({
    required this.project,
    required this.isMobile,
    required this.launch,
  });

  @override
  Widget build(BuildContext context) {
    final color = project.statusColor;
    final gallery = project.gallery;
    final liveUrl = project.liveUrl;

    // A card has a live URL but no gallery → show the live preview banner
    // instead so the card height stays consistent with gallery cards.
    final showLiveBanner = liveUrl != null && gallery.isEmpty;

    return ShimmerCard(
      glowColor: color,
      enableEffects: true,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  project.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      project.icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withValues(alpha: 0.6)),
                      ),
                      child: Text(
                        project.status,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      project.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Description ──────────────────────────────────────────────────
          SizedBox(
            height: 42,
            child: Text(
              project.desc,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 10),

          // ── Tags ─────────────────────────────────────────────────────────
          SizedBox(
            height: 28,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: project.tags.length,
              itemBuilder: (_, i) => Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  project.tags[i],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Gallery  OR  Live Preview Banner ─────────────────────────────
          if (gallery.isNotEmpty)
            GallerySection(
              images: gallery,
              accentColor: color,
              isMobile: isMobile,
            )
          else if (showLiveBanner)
            // Same visual footprint as a GallerySection so card height matches
            _LivePreviewBanner(url: liveUrl, color: color, launch: launch)
          else
            // Fallback spacer for cards with neither gallery nor live URL
            const SizedBox(height: 213),

          const SizedBox(height: 14),

          // ── Buttons ───────────────────────────────────────────────────────
          Row(
            children: [
              if (liveUrl != null) ...[
                Expanded(
                  child: _Btn(
                    label: 'Live Demo',
                    icon: Icons.launch,
                    color: const Color(0xFF3B82F6),
                    filled: true,
                    onTap: () => launch(liveUrl),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: _Btn(
                  label: 'View Code',
                  icon: FontAwesomeIcons.github,
                  color: Colors.white70,
                  filled: false,
                  isFa: true,
                  onTap: () => launch(project.github),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Replaces the gallery for live-demo-only cards.
/// Height visually matches a GallerySection (header ~28 + scroll ~185 = ~213).
class _LivePreviewBanner extends StatefulWidget {
  final String url;
  final Color color;
  final void Function(String) launch;

  const _LivePreviewBanner({
    required this.url,
    required this.color,
    required this.launch,
  });

  @override
  State<_LivePreviewBanner> createState() => _LivePreviewBannerState();
}

class _LivePreviewBannerState extends State<_LivePreviewBanner> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── "LIVE PREVIEW" header — same style as GallerySection header ──
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [widget.color, widget.color.withValues(alpha: 0.3)],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (b) => LinearGradient(
                colors: [widget.color, widget.color.withValues(alpha: 0.7)],
              ).createShader(b),
              child: const Text(
                'LIVE PREVIEW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: widget.color.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.7),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Live',
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Clickable banner body — same height as gallery scroll ──
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => widget.launch(widget.url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 185,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: _hovered ? 0.18 : 0.08),
                    widget.color.withValues(alpha: _hovered ? 0.08 : 0.03),
                  ],
                ),
                border: Border.all(
                  color: widget.color.withValues(alpha: _hovered ? 0.8 : 0.35),
                  width: _hovered ? 1.5 : 1,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.16),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  // Decorative grid dots
                  Positioned.fill(
                    child: CustomPaint(painter: _DotGridPainter(widget.color)),
                  ),
                  // Center content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withValues(
                              alpha: _hovered ? 0.25 : 0.12,
                            ),
                            border: Border.all(
                              color: widget.color.withValues(
                                alpha: _hovered ? 0.9 : 0.5,
                              ),
                            ),
                            boxShadow: _hovered
                                ? [
                                    BoxShadow(
                                      color: widget.color.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            Icons.open_in_new_rounded,
                            color: widget.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _hovered ? 'Opening...' : 'Click to Open Live Site',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(
                              alpha: _hovered ? 1.0 : 0.75,
                            ),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          Uri.parse(widget.url).host,
                          style: TextStyle(
                            fontSize: 11,
                            color: widget.color.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Subtle dot-grid background for the live preview banner
class _DotGridPainter extends CustomPainter {
  final Color color;

  _DotGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    const spacing = 22.0;
    const radius = 1.5;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
class _Btn extends StatefulWidget {
  final String label;
  final dynamic icon;
  final Color color;
  final bool filled, isFa;
  final VoidCallback onTap;

  const _Btn({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onTap,
    this.isFa = false,
  });

  @override
  State<_Btn> createState() => _BtnState();
}

class _BtnState extends State<_Btn> {
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
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _h ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.filled
                ? (_h ? const Color(0xFF2563EB) : const Color(0xFF3B82F6))
                : (_h
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.transparent),
            border: widget.filled
                ? null
                : Border.all(
                    color: _h
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.35),
                  ),
            boxShadow: widget.filled && _h
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      blurRadius: 6,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isFa
                  ? FaIcon(
                      widget.icon as FaIconData,
                      size: 13,
                      color: widget.filled ? Colors.white : widget.color,
                    )
                  : Icon(
                      widget.icon as IconData,
                      size: 14,
                      color: widget.filled ? Colors.white : widget.color,
                    ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.filled ? Colors.white : widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
