import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/production_apps.dart';
import '../models/production_app.dart';
import '../utils/constants.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';
import '../widgets/common/tech_tag.dart';
import '../widgets/carousel_dialog.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final GlobalKey _educationKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final section = GoRouterState.of(context).uri.queryParameters['section'];
    if (section == 'education') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _educationKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            alignment: 0.12,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final p = context.portfolio;
    return Scaffold(
      backgroundColor: p.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 80 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SectionTitle(
                    title: 'Professional Experience',
                    isMobile: isMobile,
                    subtitle:
                        'Delivery-focused experience building maintainable Flutter products with team collaboration.',
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  RevealAnimator(
                    child: _ExpCard(
                      title: 'Flutter Developer',
                      company: 'Root Studio Asia — Yangon, Myanmar (Remote)',
                      period: 'Jul 2024 – Jul 2026',
                      impactSummary:
                          'Shipped production Flutter features for business mobile products used by real customers.',
                      workMode: 'Remote',
                      points: const [
                        'Built and released production mobile features used by active users in business applications.',
                        'Shipped DrZon Medical Service to Google Play and the App Store — patient healthcare flows with localization for Myanmar and English.',
                        'Implemented notification and API workflows with Dio to improve delivery reliability.',
                        'Applied clean architecture and repository patterns to keep feature code maintainable.',
                        'Collaborated in code reviews and sprint planning under senior-led engineering standards.',
                        'Integrated Firebase services and state management for stable runtime behavior.',
                        'Maintained readable, reusable, and test-friendly Flutter code across modules.',
                      ],
                      tags: const [
                        'Flutter',
                        'Dart',
                        'REST API',
                        'Firebase',
                        'Clean Architecture',
                        'BLoC',
                      ],
                      icon: Icons.work,
                      logoAsset: 'assets/images/rootstudio_logo.jpg',
                      isMobile: isMobile,
                      certificateUrl: AppStrings.employmentCertificateUrl,
                    ),
                  ),
                  SizedBox(height: isMobile ? 28 : 36),
                  RevealAnimator(
                    delay: const Duration(milliseconds: 200),
                    child: _ProductionHighlightSection(isMobile: isMobile),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  KeyedSubtree(
                    key: _educationKey,
                    child: SectionTitle(
                      title: 'Education & Certifications',
                      isMobile: isMobile,
                      subtitle:
                          'Academic foundation, ongoing professional training, and certifications that support my engineering path.',
                    ),
                  ),
                  SizedBox(height: isMobile ? 6 : 10),
                  Text(
                    'Education milestones, ongoing learning, and certification proof of outcomes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: p.textMuted,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  RevealAnimator(
                    child: _CollapsibleEducationSection(isMobile: isMobile),
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

// ── Experience Card ───────────────────────────────────────────────────────────
class _ExpCard extends StatelessWidget {
  final String title, company, period;
  final String impactSummary;
  final String workMode;
  final List<String> points, tags;
  final IconData icon;
  final String? logoAsset;
  final String? certificateUrl;
  final bool isMobile;

  const _ExpCard({
    required this.title,
    required this.company,
    required this.period,
    required this.impactSummary,
    required this.workMode,
    required this.points,
    required this.tags,
    required this.icon,
    required this.isMobile,
    this.logoAsset,
    this.certificateUrl,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    const accent = AppColors.primary;

    return ShimmerCard(
      glowColor: accent,
      enableEffects: true,
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: logoAsset != null
                    ? Image.asset(
                        logoAsset!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _iconBox(icon, accent),
                      )
                    : _iconBox(icon, accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: p.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: p.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: p.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      workMode,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 11,
                        color: p.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: p.border),
            ),
            child: Text(
              impactSummary,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                color: p.textPrimary.withValues(alpha: 0.85),
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...points.map(
            (pt) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pt,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        color: p.textPrimary.withValues(alpha: 0.85),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((t) => TechTag(label: t, isMobile: isMobile))
                .toList(),
          ),
          if (certificateUrl != null) ...[
            const SizedBox(height: 16),
            _AcademicDocStripButton(
              onTap: () => _launchUrl(certificateUrl!),
              accent: accent,
              title: 'Certificate of Service',
              subtitle: 'Root Studio employment verification',
              hint: 'Verified employment document (PDF)',
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBox(IconData iconData, Color color) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.35)),
    ),
    child: Icon(iconData, color: color, size: 26),
  );
}

// ── Education shared helpers ──────────────────────────────────────────────────

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

BoxDecoration _eduCardDecoration(BuildContext context) {
  final p = context.portfolio;
  return BoxDecoration(
    color: p.cardBg,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: p.border),
  );
}

Widget _academicDocStrip({
  required BuildContext context,
  required VoidCallback onTap,
  required Color accent,
}) {
  final p = context.portfolio;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _AcademicDocStripButton(
        onTap: onTap,
        accent: accent,
        title: 'Academic Records',
        subtitle: '1st Year Marks & Recommendation Letter',
        hint: 'Verified university document (PDF)',
      ),
      const SizedBox(height: 8),
      Text(
        '2nd year transcript not issued — studies paused during 2nd semester (COVID-19).',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.5,
          color: p.textMuted,
          fontStyle: FontStyle.italic,
          height: 1.35,
        ),
      ),
    ],
  );
}

class _AcademicDocStripButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color accent;
  final String title;
  final String subtitle;
  final String hint;

  const _AcademicDocStripButton({
    required this.onTap,
    required this.accent,
    this.title = 'Academic Records',
    this.subtitle = '1st Year Marks & Recommendation Letter',
    this.hint = 'Verified university document (PDF)',
  });

  @override
  State<_AcademicDocStripButton> createState() =>
      _AcademicDocStripButtonState();
}

class _AcademicDocStripButtonState extends State<_AcademicDocStripButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: widget.accent.withValues(alpha: _hovered ? 0.1 : 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accent.withValues(alpha: _hovered ? 0.45 : 0.28),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.accent.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 20,
                  color: widget.accent.withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.secondary,
                        fontWeight: FontWeight.w700,
                        color: p.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: PortfolioFontSizes.caption,
                        color: p.textPrimary.withValues(alpha: 0.78),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.hint,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: p.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_rounded,
                size: 16,
                color: widget.accent.withValues(alpha: _hovered ? 1 : 0.75),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _logoBox(String asset) => Container(
  width: 72,
  height: 72,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
        child: const Icon(Icons.school, color: Color(0xFF3B82F6), size: 36),
      ),
    ),
  ),
);

Widget _dateRow(BuildContext context, String t) {
  final p = context.portfolio;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.calendar_today_outlined,
        size: 12,
        color: p.textMuted,
      ),
      const SizedBox(width: 4),
      Text(
        t,
        style: TextStyle(
          fontSize: PortfolioFontSizes.label,
          color: p.textMuted,
        ),
      ),
    ],
  );
}

Widget _pill(String label, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: color.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: color.withValues(alpha: 0.5)),
  ),
  child: Text(
    label,
    style: TextStyle(fontSize: PortfolioFontSizes.caption, color: color, fontWeight: FontWeight.w600),
  ),
);

Widget _checkItem(BuildContext context, String text) {
  final p = context.portfolio;
  return Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: PortfolioFontSizes.secondary,
              color: p.textPrimary.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Ongoing training (Ruby Learner) ───────────────────────────────────────────
/// Logo file: add [assets/images/ruby_learner.png] to the project (see pubspec assets).
class _OngoingTrainingCard extends StatelessWidget {
  final bool isMobile;

  const _OngoingTrainingCard({required this.isMobile});

  static const _logoAsset = 'assets/images/ruby_learner.jpg';
  static const _ruby = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return ShimmerCard(
      glowColor: _ruby,
      enableEffects: true,
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _ruby.withValues(alpha: 0.28)),
      ),
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      child: isMobile ? _mobileLayout(context) : _desktopLayout(context),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    final p = context.portfolio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _logoBox(_logoAsset),
        const SizedBox(height: 14),
        _statusRow(),
        const SizedBox(height: 10),
        const Text(
          'Ruby Learner',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFCA5A5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Flutter Advanced Class (2026)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        _formatDescription(context, TextAlign.center),
        const SizedBox(height: 10),
        _dateRow(context, '~4–5 months (estimated)'),
        const SizedBox(height: 14),
        Container(height: 1, color: _ruby.withValues(alpha: 0.2)),
        const SizedBox(height: 14),
        ..._coverageBullets(context),
      ],
    );
  }

  Widget _desktopLayout(BuildContext context) {
    final p = context.portfolio;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logoBox(_logoAsset),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusRow(),
              const SizedBox(height: 8),
              const Text(
                'Ruby Learner',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFCA5A5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Flutter Advanced Class (2026)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: p.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              _formatDescription(context, TextAlign.start),
              const SizedBox(height: 8),
              _dateRow(context, '~4–5 months (estimated)'),
              const SizedBox(height: 14),
              Container(height: 1, color: _ruby.withValues(alpha: 0.2)),
              const SizedBox(height: 14),
              ..._coverageBullets(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF34D399).withValues(alpha: 0.45),
            ),
          ),
          child: const Text(
            'In progress',
            style: TextStyle(
              fontSize: PortfolioFontSizes.caption,
              color: Color(0xFF6EE7B7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _pill('Ongoing — 2026', _ruby),
        _pill('Sat & Sun · Zoom', _ruby),
      ],
    );
  }

  Widget _formatDescription(BuildContext context, TextAlign align) {
    final p = context.portfolio;
    return Text(
      'Weekend live sessions (Sat & Sun, Zoom) with pre-recorded lesson materials, Q&A, and revision with the instructor. Weekly assignments are issued and reviewed by the instructor to reinforce progress.',
      textAlign: align,
      style: TextStyle(
        fontSize: isMobile ? 12 : 13,
        color: p.textMuted,
        height: 1.45,
      ),
    );
  }

  List<Widget> _coverageBullets(BuildContext context) {
    const items = [
      'Format: Pre-recorded lessons plus live Zoom on weekends for questions, review, and revision with the instructor.',
      'Assessment: Structured weekly assignments with instructor review and feedback on submissions.',
      'Course coverage progresses from Dart through Flutter for mobile and Flutter web.',
      'Curriculum includes advanced topics such as LLM-related concepts, AI agents, and on-device AI as presented in the program.',
      'Currently enrolled; modules and details may expand as the provider updates the course.',
    ];
    return items.map((item) => _checkItem(context, item)).toList();
  }
}

// ── Production highlight (compact store apps) ─────────────────────────────────
class _ProductionHighlightSection extends StatelessWidget {
  final bool isMobile;

  const _ProductionHighlightSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final liveApps = kProductionApps
        .where((a) => a.releaseStatus == AppReleaseStatus.live)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured production work',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: p.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '3 apps live on Google Play and the App Store',
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            color: p.textMuted,
          ),
        ),
        const SizedBox(height: 14),
        ...liveApps.map(
          (app) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ProductionMiniCard(app: app, isMobile: isMobile),
          ),
        ),
      ],
    );
  }
}

class _ProductionMiniCard extends StatelessWidget {
  final ProductionApp app;
  final bool isMobile;

  const _ProductionMiniCard({required this.app, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
        color: p.cardBg,
      ),
      child: Row(
        children: [
          if (app.iconAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(app.iconAsset!, width: 40, height: 40),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.title,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: p.textPrimary,
                  ),
                ),
                if (app.keyContribution != null)
                  Text(
                    app.keyContribution!,
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.caption,
                      color: p.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.go('/work?section=apps'),
            child: const Text('View', style: TextStyle(fontSize: PortfolioFontSizes.label)),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleEducationSection extends StatefulWidget {
  final bool isMobile;

  const _CollapsibleEducationSection({required this.isMobile});

  @override
  State<_CollapsibleEducationSection> createState() =>
      _CollapsibleEducationSectionState();
}

class _CollapsibleEducationSectionState
    extends State<_CollapsibleEducationSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
        color: p.cardBg.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.school_outlined, color: AppColors.primaryLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Academic background & early training',
                      style: TextStyle(
                        fontSize: widget.isMobile ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: p.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: p.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: p.border),
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.isMobile
                  ? Column(
                      children: [
                        _UniCard(isMobile: widget.isMobile),
                        const SizedBox(height: 16),
                        _OngoingTrainingCard(isMobile: widget.isMobile),
                        const SizedBox(height: 16),
                        _KMDCard(isMobile: widget.isMobile),
                        const SizedBox(height: 16),
                        _WebDevCard(isMobile: widget.isMobile),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _UniCard(isMobile: widget.isMobile)),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: _KMDCard(isMobile: widget.isMobile),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _WebDevCard(isMobile: widget.isMobile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _OngoingTrainingCard(isMobile: widget.isMobile),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── University Card ───────────────────────────────────────────────────────────
class _UniCard extends StatelessWidget {
  final bool isMobile;

  const _UniCard({required this.isMobile});

  static const _accent = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return ShimmerCard(
      glowColor: AppColors.primary,
      enableEffects: true,
      decoration: _eduCardDecoration(context),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/computer_university.jpg'),
          const SizedBox(height: 14),
          Text(
            'University of Computer, Mandalay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Computer Science Major',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow(context, '2018 – 2021'),
          const SizedBox(height: 8),
          _pill('2nd Year Completed', _accent),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 13,
                  color: Colors.orange.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Studies were paused due to COVID-19 and national circumstances in Myanmar.',
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.caption,
                      color: Colors.orange.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _academicDocStrip(
            context: context,
            accent: _accent,
            onTap: () => _launchUrl(AppStrings.universityFirstYearDocUrl),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          ...[
            'Data Structures & Algorithms',
            'Database Management Systems',
            'Software Engineering Principles',
            'Object-Oriented Programming',
            'Computer Architecture',
            'Web Development Foundations',
          ].map((item) => _checkItem(context, item)),
        ],
      ),
    );
  }
}

// ── KMD Card ──────────────────────────────────────────────────────────────────
class _KMDCard extends StatelessWidget {
  final bool isMobile;

  const _KMDCard({required this.isMobile});

  static const _accent = Color(0xFF3B82F6);

  static const _certs = [
    {
      'title': 'Software Engineering — VB.Net',
      'image': 'assets/images/cert_se.jpg',
    },
    {
      'title': 'Problem Solving with Programming',
      'image': 'assets/images/cert_ps.jpg',
    },
    {
      'title': 'Practical A+ Hardware & Networking',
      'image': 'assets/images/cert_hw.jpg',
    },
    {
      'title': 'Microsoft PowerPoint Advanced',
      'image': 'assets/images/cert_ppt.jpg',
    },
    {'title': 'Computer Basic', 'image': 'assets/images/cert_basic.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final allImages = _certs.map((c) => c['image']!).toList();
    return ShimmerCard(
      glowColor: AppColors.primary,
      enableEffects: true,
      decoration: _eduCardDecoration(context),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/kmd_logo.jpg'),
          const SizedBox(height: 14),
          Text(
            'KMD Education Center',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Technical Certifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow(context, 'Multiple Dates'),
          const SizedBox(height: 8),
          _pill('5 Verified Certificates', _accent),
          const SizedBox(height: 20),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 212,
            ),
            itemCount: _certs.length,
            itemBuilder: (ctx, i) => _CertCard(
              title: _certs[i]['title']!,
              imagePath: _certs[i]['image']!,
              onTap: () => showDialog(
                context: ctx,
                barrierColor: Colors.black.withValues(alpha: 0.92),
                builder: (_) =>
                    CarouselDialog(images: allImages, initialIndex: i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Web Dev Card ──────────────────────────────────────────────────────────────
class _WebDevCard extends StatelessWidget {
  final bool isMobile;

  const _WebDevCard({required this.isMobile});

  static const _accent = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    return ShimmerCard(
      glowColor: AppColors.primary,
      enableEffects: true,
      decoration: _eduCardDecoration(context),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logoBox('assets/images/computer_university.jpg'),
          const SizedBox(height: 14),
          Text(
            'University of Computer, Mandalay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Web Development Foundation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          _dateRow(context, 'Certified'),
          const SizedBox(height: 8),
          _pill('Certification Completed', _accent),
          const SizedBox(height: 14),
          Container(height: 1, color: _accent.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          ...[
            'HTML & CSS',
            'Bootstrap Framework',
            'JavaScript Fundamentals',
            'Responsive Web Design',
          ].map((item) => _checkItem(context, item)),
          const SizedBox(height: 16),
          _CertCard(
            title: 'Web Dev Foundation Certificate',
            imagePath: 'assets/images/cert_webdev.jpg',
            fullWidth: true,
            accentColor: _accent,
            onTap: () => showDialog(
              context: context,
              barrierColor: Colors.black.withValues(alpha: 0.92),
              builder: (_) => CarouselDialog(
                images: ['assets/images/cert_webdev.jpg'],
                initialIndex: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cert Card ─────────────────────────────────────────────────────────────────
class _CertCard extends StatefulWidget {
  final String title, imagePath;
  final VoidCallback onTap;
  final bool fullWidth;
  final Color accentColor;

  const _CertCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.fullWidth = false,
    this.accentColor = const Color(0xFF3B82F6),
  });

  @override
  State<_CertCard> createState() => _CertCardState();
}

class _CertCardState extends State<_CertCard> {
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
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _h ? -1.5 : 0, 0),
          height: widget.fullWidth ? 148 : null,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _h
                  ? widget.accentColor.withValues(alpha: 0.8)
                  : const Color(0xFF1E3A6E).withValues(alpha: 0.8),
              width: _h ? 1.5 : 1,
            ),
            boxShadow: _h
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.14),
                      blurRadius: 7,
                    ),
                  ]
                : [],
          ),
          child: widget.fullWidth
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
                      if (_h) _overlay(),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.32),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (_h) _overlay(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A1020),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(11),
                        ),
                      ),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: PortfolioFontSizes.caption,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFF1E40AF).withValues(alpha: 0.2),
    child: Center(
      child: Icon(
        Icons.workspace_premium,
        color: const Color(0xFFFFD700).withValues(alpha: 0.6),
        size: 32,
      ),
    ),
  );

  Widget _overlay() => Container(
    color: Colors.black.withValues(alpha: 0.4),
    child: const Center(
      child: Icon(Icons.zoom_in_rounded, color: Colors.white, size: 28),
    ),
  );
}
