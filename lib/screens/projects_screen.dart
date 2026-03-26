import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/gallery_section.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  static final _projects = [
    {
      'title': 'Smile Shop E-Commerce',
      'subtitle': 'Full-featured Shopping Platform',
      'image': 'assets/images/smile_shop.png',
      'desc':
          'Shopping platform with product catalog, cart, Firebase Auth, Firestore & MVC architecture.',
      'tags': ['Flutter', 'Dart', 'Firebase', 'REST API'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/e_commerce',
      'icon': Icons.shopping_cart,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/ecommerce_1.png',
        'assets/images/ecommerce_2.png',
        'assets/images/ecommerce_3.png',
      ],
    },
    {
      'title': 'Food Monkey',
      'subtitle': 'Food Delivery UI App',
      'image': 'assets/images/food_monkey.png',
      'desc':
          'Food delivery UI app with smooth animations, category browsing & intuitive ordering experience.',
      'tags': ['Flutter', 'Material Design 3', 'Custom UI'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/food_monkey',
      'icon': Icons.fastfood,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/food_monkey_1.png',
        'assets/images/food_monkey_2.png',
        'assets/images/food_monkey_3.png',
        'assets/images/food_monkey_4.png',
      ],
    },
    {
      'title': 'Yin Store',
      'subtitle': 'Responsive Dark E-Commerce App',
      'image': 'assets/images/yin_store.png',
      'desc':
          'Responsive dark-themed e-commerce app — iPhone, MacBook, Fashion & Lifestyle categories.',
      'tags': ['Flutter Web', 'Material Design 3', 'Responsive UI'],
      'liveUrl': 'https://yin-store.vercel.app',
      'github': 'https://github.com/phyowaikyaw-mobiledev/yin_store',
      'icon': Icons.store,
      'status': 'Live Demo',
      'statusColor': Colors.green,
      'gallery': <String>[], // gallery removed — live demo replaces it
    },
    {
      'title': 'Learners Gateway',
      'subtitle': 'Live Production Blog Platform',
      'image': 'assets/images/learner_gateway.jpg',
      'desc':
          'Blog platform with Flutter Web & Firebase — real-time content, auth, comments & responsive design.',
      'tags': ['Flutter Web', 'Firebase', 'Provider', 'go_router'],
      'liveUrl': 'https://learners-gateway.web.app',
      'github':
          'https://github.com/phyowaikyaw-mobiledev/learners_gateway_website',
      'icon': Icons.web,
      'status': 'Live',
      'statusColor': Colors.green,
      'gallery': <String>[], // gallery removed — live demo replaces it
    },
    {
      'title': 'Resume Tailor AI',
      'subtitle': 'AI-Powered Resume Optimizer',
      'image': 'assets/images/resume_tailor.png',
      'desc':
          'AI-powered resume optimizer using OpenAI GPT — ATS-friendly resume tailoring with PDF export.',
      'tags': ['Flutter', 'OpenAI API', 'PDF Generation', 'flutter_dotenv'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/resume_tailor_ai',
      'icon': Icons.auto_awesome,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/resume_1.png',
        'assets/images/resume_2.png',
        'assets/images/resume_4.png',
        'assets/images/resume_3.png',
      ],
    },
    {
      'title': 'Ying Music',
      'subtitle': 'Music Streaming App UI',
      'image': 'assets/images/music_app1.png',
      'desc':
          'Modern music streaming UI with gradient design, hero animations & playback controls.',
      'tags': ['Flutter', 'Material 3', 'Animations'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/music_app',
      'icon': Icons.music_note,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/music_1.png',
        'assets/images/music_2.png',
        'assets/images/music_3.png',
        'assets/images/music_4.png',
      ],
    },
    {
      'title': 'EduHub',
      'subtitle': 'Learning Management System',
      'image': 'assets/images/lms.png',
      'desc':
          'LMS with dual-role (Student & Teacher), course management, assignments & offline Hive storage.',
      'tags': ['Flutter', 'Firebase', 'BLoC', 'Hive'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/eduhub_lms',
      'icon': Icons.school,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/lms_1.png',
        'assets/images/lms_2.png',
        'assets/images/lms_3.png',
        'assets/images/lms_4.png',
        'assets/images/lms_5.png',
        'assets/images/lms_6.png',
        'assets/images/lms_7.png',
      ],
    },
    {
      'title': 'Pardon Diary',
      'subtitle': 'Feature-rich Note App',
      'image': 'assets/images/note_app.png',
      'desc':
          'Google Keep-inspired note app with Realm DB, CRUD, staggered grid & full-text search.',
      'tags': ['Flutter', 'Realm DB', 'Streams', 'Material 3'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/pardon_diary-note',
      'icon': Icons.note_alt,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/note_1.png',
        'assets/images/note_2.png',
        'assets/images/note_3.png',
        'assets/images/note_4.png',
      ],
    },
    {
      'title': 'SocialHub',
      'subtitle': 'Social Media UI Clone',
      'image': 'assets/images/social_app.png',
      'desc':
          'Facebook-inspired app with news feed, interactive posts, notifications & smooth navigation.',
      'tags': ['Flutter', 'Material Design', 'Complex UI'],
      'liveUrl': null,
      'github':
          'https://github.com/phyowaikyaw-mobiledev/social_media_ui_clone',
      'icon': Icons.people,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/social_1.png',
        'assets/images/social_2.png',
        'assets/images/social_3.png',
        'assets/images/social_4.png',
        'assets/images/social_5.png',
      ],
    },
    {
      'title': 'Flutter Quiz App',
      'subtitle': 'Interactive Quiz Application',
      'image': 'assets/images/quiz_app.png',
      'desc':
          'Interactive quiz app with score tracking, dynamic question flow & clean Material UI.',
      'tags': ['Flutter', 'setState', 'Material Design'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/flutter_quizz_app',
      'icon': Icons.quiz,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/quiz_1.png',
        'assets/images/quiz_2.png',
        'assets/images/quiz_3.png',
      ],
    },
    {
      'title': 'Healthcare Plus',
      'subtitle': 'Telemedicine Flutter App',
      'image': 'assets/images/healthcare.png',
      'desc':
          'Telemedicine app with Firebase Auth, dual-role (Patient & Doctor) dashboard & real-time Firestore.',
      'tags': ['Flutter', 'Firebase Auth', 'Firestore', 'Material Design'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/healthcare_plus',
      'icon': Icons.local_hospital,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/healthcare_1.png',
        'assets/images/healthcare_2.png',
        'assets/images/healthcare_3.png',
        'assets/images/healthcare_4.png',
        'assets/images/healthcare_5.png',
        'assets/images/healthcare_6.png',
      ],
    },
    {
      'title': 'Roll Dice App',
      'subtitle': 'Simple Dice Roller',
      'image': 'assets/images/roll_dice.png',
      'desc':
          'Simple dice roller app — beginner Flutter project with clean UI and smooth dice animation.',
      'tags': ['Flutter', 'setState', 'Material Design'],
      'liveUrl': null,
      'github': 'https://github.com/phyowaikyaw-mobiledev/roll_dice_app',
      'icon': Icons.casino,
      'status': 'Individual Project',
      'statusColor': Colors.orange,
      'gallery': [
        'assets/images/dice_1.png',
        'assets/images/dice_3.png',
        'assets/images/dice_2.png',
      ],
    },
  ];

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: isMobile ? 80 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SectionTitle(title: 'Personal Projects', isMobile: isMobile),
                  SizedBox(height: isMobile ? 20 : 30),
                  isMobile
                      ? Column(
                          children: _projects
                              .asMap()
                              .entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: RevealAnimator(
                                    delay: Duration(milliseconds: 50 * e.key),
                                    child: _ProjectCard(
                                      p: e.value,
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
                          itemCount: _projects.length,
                          itemBuilder: (_, i) => RevealAnimator(
                            delay: Duration(milliseconds: 60 * (i % 2)),
                            child: _ProjectCard(
                              p: _projects[i],
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ProjectCard extends StatelessWidget {
  final Map<String, dynamic> p;
  final bool isMobile;
  final void Function(String) launch;

  const _ProjectCard({
    required this.p,
    required this.isMobile,
    required this.launch,
  });

  @override
  Widget build(BuildContext context) {
    final color = p['statusColor'] as Color;
    final gallery = p['gallery'] as List<String>;
    final liveUrl = p['liveUrl'] as String?;

    // A card has a live URL but no gallery → show the live preview banner
    // instead so the card height stays consistent with gallery cards.
    final showLiveBanner = liveUrl != null && gallery.isEmpty;

    return ShimmerCard(
      glowColor: color,
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
                  p['image'] as String,
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
                      p['icon'] as IconData,
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
                        p['status'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      p['subtitle'] as String,
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
              p['desc'] as String,
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
              itemCount: (p['tags'] as List<String>).length,
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
                  (p['tags'] as List<String>)[i],
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
            _LivePreviewBanner(url: liveUrl!, color: color, launch: launch)
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
                  onTap: () => launch(p['github'] as String),
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
                          color: widget.color.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 1,
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
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 16,
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
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.45),
                      blurRadius: 12,
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
                      widget.icon as IconData,
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
