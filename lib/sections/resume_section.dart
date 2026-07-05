import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/production_app.dart';
import '../data/production_apps.dart';
import '../data/resume_data.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';
import '../widgets/carousel_dialog.dart';
import '../widgets/common/zeel_section_header.dart';
import '../widgets/resume/resume_timeline.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showImage(BuildContext context, String imagePath) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: CarouselDialog(images: [imagePath], initialIndex: 0),
      ),
    );
  }

  ProductionApp? _appByTitle(String title) {
    for (final app in kProductionApps) {
      if (app.title == title) return app;
    }
    return null;
  }

  List<ProductionApp> get _shippedRow1 => kShippedWorkRow1Titles
      .map(_appByTitle)
      .whereType<ProductionApp>()
      .toList();

  List<ProductionApp> get _shippedRow2 => kShippedWorkRow2Titles
      .map(_appByTitle)
      .whereType<ProductionApp>()
      .toList();

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final exp = kRootStudioExperience;
    final uni = kUniversityEducation;
    final ruby = kRubyLearnerOngoing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(
          title: 'Resume',
          subtitle:
              'Verified experience, education, and ongoing professional training.',
        ),
        SizedBox(height: isMobile ? 24 : 32),
        ResumeTimelineSection(
          icon: Icons.work_outline,
          title: 'Experience',
          entries: [
            ResumeTimelineEntry(
              isLast: true,
              child: _experienceEntry(context, p, exp),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 28 : 36),
        ResumeTimelineSection(
          icon: Icons.school_outlined,
          title: 'Education',
          entries: [
            ResumeTimelineEntry(
              child: _universityEntry(context, p, uni),
            ),
            ResumeTimelineEntry(
              child: _kmdEntry(context, p),
            ),
            ResumeTimelineEntry(
              isLast: true,
              child: _ongoingEntry(context, p, ruby),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 28 : 32),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: () => _launch(AppStrings.cvUrl),
            icon: Icon(Icons.description_outlined, color: p.accentTeal, size: 18),
            label: Text(
              'Download CV',
              style: TextStyle(color: p.accentTeal, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: p.accentTeal.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _experienceEntry(
    BuildContext context,
    PortfolioColors p,
    ({
      String title,
      String orgName,
      String subtitle,
      String logoAsset,
      String period,
      String workMode,
      String impactSummary,
      String releaseSummary,
      List<String> points,
    }) exp,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeOrgHeader(
          logoAsset: exp.logoAsset,
          orgName: exp.orgName,
          subtitle: '${exp.title} · ${exp.workMode}',
          period: exp.period,
        ),
        const SizedBox(height: 12),
        Text(
          exp.impactSummary,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        const ResumeSectionLabel(label: 'Shipped Work'),
        ResumeShippedRows(row1: _shippedRow1, row2: _shippedRow2),
        const SizedBox(height: 16),
        const ResumeSectionLabel(label: 'Release & Delivery'),
        Text(
          exp.releaseSummary,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ResumeBulletList(items: exp.points),
        ResumeEvidenceButton(
          label: 'View Employment Certificate',
          onTap: () => _launch(AppStrings.employmentCertificateUrl),
        ),
      ],
    );
  }

  Widget _universityEntry(
    BuildContext context,
    PortfolioColors p,
    ({
      String institution,
      String degree,
      String logoAsset,
      String period,
      String note,
      List<String> highlights,
    }) uni,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeOrgHeader(
          logoAsset: uni.logoAsset,
          orgName: uni.institution,
          subtitle: uni.degree,
          period: uni.period,
        ),
        const SizedBox(height: 8),
        Text(
          uni.note,
          style: TextStyle(
            fontSize: PortfolioFontSizes.label,
            color: p.textMuted,
            fontStyle: FontStyle.italic,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in uni.highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '· $item',
              style: TextStyle(fontSize: PortfolioFontSizes.label, color: p.textMuted, height: 1.4),
            ),
          ),
        ResumeEvidenceButton(
          label: 'View Transcript',
          onTap: () => _launch(AppStrings.universityFirstYearDocUrl),
        ),
        ResumeEvidenceButton(
          label: 'View Letter of Recommendation',
          icon: Icons.mail_outline,
          onTap: () => _showImage(context, kLetterOfRecommendationAsset),
        ),
      ],
    );
  }

  Widget _kmdEntry(BuildContext context, PortfolioColors p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeOrgHeader(
          logoAsset: kKmdEducation.logoAsset,
          orgName: kKmdEducation.institution,
          subtitle: kKmdEducation.subtitle,
          period: '5 verified certificates',
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < kKmdCertificates.length; i++)
          ResumeCertRoadmapEntry(
            title: kKmdCertificates[i].title,
            subtitle: kKmdCertificates[i].subtitle,
            date: kKmdCertificates[i].date,
            isLast: i == kKmdCertificates.length - 1,
            onView: () => _showImage(context, kKmdCertificates[i].imagePath),
          ),
      ],
    );
  }

  Widget _ongoingEntry(
    BuildContext context,
    PortfolioColors p,
    ({
      String provider,
      String course,
      String logoAsset,
      String schedule,
      String description,
    }) ruby,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeOrgHeader(
          logoAsset: ruby.logoAsset,
          orgName: ruby.provider,
          subtitle: ruby.course,
          period: ruby.schedule,
          subtitleTrailing: const ResumeOngoingBadge(),
        ),
        const SizedBox(height: 10),
        Text(
          ruby.description,
          style: TextStyle(
            fontSize: PortfolioFontSizes.secondary,
            color: p.textMuted,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
