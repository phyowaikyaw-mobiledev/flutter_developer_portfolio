import 'package:flutter/material.dart';
import '../sections/about_section.dart';
import '../sections/awards_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';
import '../sections/portfolio_section.dart';
import '../sections/process_section.dart';
import '../sections/resume_section.dart';
import '../sections/skills_section.dart';
import '../sections/milestones_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/work_preview_section.dart';
import '../theme/portfolio_theme.dart';
import '../theme/theme_controller.dart';
import '../widgets/layout/contact_speed_dial.dart';
import '../widgets/layout/pill_section_nav.dart';
import '../widgets/layout/profile_sidebar.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, this.initialSection});

  final PortfolioSection? initialSection;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late PortfolioSection _active;
  final _aboutScroll = ScrollController();
  final _expertiseScroll = ScrollController();
  final _resumeScroll = ScrollController();
  final _portfolioScroll = ScrollController();
  final _contactScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _active = widget.initialSection ?? PortfolioSection.about;
  }

  @override
  void dispose() {
    _aboutScroll.dispose();
    _expertiseScroll.dispose();
    _resumeScroll.dispose();
    _portfolioScroll.dispose();
    _contactScroll.dispose();
    super.dispose();
  }

  void _switchTab(PortfolioSection section) {
    setState(() => _active = section);
    final ctrl = _scrollFor(section);
    if (ctrl.hasClients) {
      ctrl.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  ScrollController _scrollFor(PortfolioSection section) {
    return switch (section) {
      PortfolioSection.about => _aboutScroll,
      PortfolioSection.expertise => _expertiseScroll,
      PortfolioSection.resume => _resumeScroll,
      PortfolioSection.portfolio => _portfolioScroll,
      PortfolioSection.contact => _contactScroll,
    };
  }

  int get _tabIndex => PortfolioSection.values.indexOf(_active);

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      backgroundColor: p.background,
      floatingActionButton: const ContactSpeedDial(),
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              top: false,
              child: SectionBottomNav(active: _active, onTap: _switchTab),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: isDesktop ? _desktopLayout(p) : _mobileLayout(p),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _desktopLayout(PortfolioColors p) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSidebar(),
        const SizedBox(width: 20),
        Expanded(child: _contentCard(p)),
      ],
    );
  }

  Widget _mobileLayout(PortfolioColors p) {
    return Column(
      children: [
        const ProfileSidebar(compact: true),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: themeController.toggle,
              tooltip: themeController.isDark ? 'Light Mode' : 'Dark Mode',
              icon: Icon(
                themeController.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: p.textMuted,
              ),
            ),
          ],
        ),
        Expanded(child: _contentCard(p, showNav: false)),
      ],
    );
  }

  Widget _contentCard(PortfolioColors p, {bool showNav = true}) {
    return Container(
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          if (showNav)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: PillSectionNav(
                  active: _active,
                  onTap: _switchTab,
                ),
              ),
            )
          else
            const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _tabScroll(_aboutScroll, const _AboutTabBody()),
                _tabScroll(_expertiseScroll, const _ExpertiseTabBody()),
                _tabScroll(_resumeScroll, const _ResumeTabBody()),
                _tabScroll(_portfolioScroll, const _PortfolioTabBody()),
                _tabScroll(_contactScroll, const _ContactTabBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabScroll(ScrollController controller, Widget child) {
    return SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: child,
    );
  }
}

class _AboutTabBody extends StatelessWidget {
  const _AboutTabBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AboutSection(),
        const SizedBox(height: 40),
        const MilestonesSection(),
        const SizedBox(height: 40),
        const AwardsSection(),
        const SizedBox(height: 40),
        const WorkPreviewSection(),
        const SizedBox(height: 40),
        const ProcessSection(),
        const SizedBox(height: 40),
        const TestimonialsSection(),
      ],
    );
  }
}

class _ExpertiseTabBody extends StatelessWidget {
  const _ExpertiseTabBody();

  @override
  Widget build(BuildContext context) {
    return const SkillsSection();
  }
}

class _ResumeTabBody extends StatelessWidget {
  const _ResumeTabBody();

  @override
  Widget build(BuildContext context) {
    return const ResumeSection();
  }
}

class _PortfolioTabBody extends StatelessWidget {
  const _PortfolioTabBody();

  @override
  Widget build(BuildContext context) {
    return const PortfolioGridSection();
  }
}

class _ContactTabBody extends StatelessWidget {
  const _ContactTabBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContactSection(),
        SizedBox(height: 24),
        FooterSection(),
      ],
    );
  }
}

PortfolioSection? sectionFromQuery(String? section) {
  switch (section) {
    case 'about':
      return PortfolioSection.about;
    case 'expertise':
    case 'skills':
      return PortfolioSection.expertise;
    case 'resume':
    case 'experience':
    case 'education':
      return PortfolioSection.resume;
    case 'portfolio':
    case 'work':
    case 'apps':
    case 'projects':
      return PortfolioSection.portfolio;
    case 'contact':
    case 'testimonials':
      return PortfolioSection.contact;
    case 'awards':
      return PortfolioSection.about;
    default:
      return null;
  }
}
