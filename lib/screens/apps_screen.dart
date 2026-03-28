import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/gallery_section.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

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
            horizontal: isMobile ? 20 : 40, vertical: isMobile ? 80 : 100),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(children: [
              SectionTitle(
                title: 'Production Apps',
                isMobile: isMobile,
                subtitle:
                    'Real products I helped ship for business users, with performance and maintainability in mind.',
              ),
              SizedBox(height: isMobile ? 28 : 40),

              _catLabel('Published & Live', Colors.green, isMobile),
              const SizedBox(height: 16),
              _two(isMobile, [
                _AppCard(title: 'Phone King Plus — Customer', description: 'Built loyalty flows for points, rewards redemption, and customer engagement in a production retail environment.', iconAsset: 'assets/images/phoneking_icon.png', icon: Icons.phone_android, role: 'Core Developer', statusColor: Colors.green, companyBadge: 'Root Studio Asia', tags: ['Flutter','REST API','Material Design'], impact: 'Published on both stores and actively used by real customers.', playUrl: 'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_customer', appStoreUrl: 'https://apps.apple.com/th/app/phoneking-plus/id6757488887', gallery: ['assets/images/pk_1.png','assets/images/pk_2.png','assets/images/pk_3.png','assets/images/pk_4.png','assets/images/pk_5.png'], isMobile: isMobile, launch: _launch),
                _AppCard(title: 'Phone King Plus — Admin', description: 'Implemented internal operations tools to manage stores, campaigns, and customer reward activity efficiently.', iconAsset: 'assets/images/phoneking_admin_icon.png', icon: Icons.admin_panel_settings, role: 'Core Developer', statusColor: Colors.green, companyBadge: 'Root Studio Asia', tags: ['Flutter','REST API','Material Design'], impact: 'Enabled staff workflows with a dedicated production admin app.', playUrl: 'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_admin', appStoreUrl: 'https://apps.apple.com/th/app/phoneking-plus-admin/id6757606298', gallery: ['assets/images/pka_1.png','assets/images/pka_2.png','assets/images/pka_3.png','assets/images/pka_4.png','assets/images/pka_5.png'], isMobile: isMobile, launch: _launch),
              ]),
              SizedBox(height: isMobile ? 28 : 36),
              _catLabel('Launching Soon', Colors.orange, isMobile),
              const SizedBox(height: 16),
              _two(isMobile, [
                _AppCard(title: 'DrZon Healthcare', description: 'Developed patient-facing healthcare journeys with localization and architecture ready for long-term feature growth.', iconAsset: 'assets/images/dr_zon.png', icon: Icons.local_hospital, role: 'Core Developer', statusColor: Colors.orange, companyBadge: 'Root Studio Asia', tags: ['Flutter','Dio','Clean Architecture','l10n'], impact: 'Prepared for regional release across Myanmar and Thailand markets.', gallery: ['assets/images/drzon_1.png','assets/images/drzon_2.png','assets/images/drzon_3.png','assets/images/drzon_4.png','assets/images/drzon_5.png','assets/images/drzon_6.png'], isMobile: isMobile, launch: _launch),
                _AppCard(title: 'Pan Customer App', description: 'Engineered shopping flows on layered architecture to support easier scaling, testing, and long-term maintenance.', iconAsset: 'assets/images/pan_icon.png', icon: Icons.shopping_bag, role: 'Core Developer', statusColor: Colors.orange, companyBadge: 'Root Studio Asia', tags: ['Flutter','REST API','Layered Architecture'], impact: 'Designed for maintainable feature delivery in a production context.', gallery: ['assets/images/pan.png','assets/images/pan_1.png','assets/images/pan_2.png','assets/images/pan_3.png'], isMobile: isMobile, launch: _launch),
              ]),
              SizedBox(height: isMobile ? 16 : 20),
              RevealAnimator(delay: const Duration(milliseconds: 100),
                child: _AppCard(title: 'Secure Plus CCTV', description: 'Delivered customer and admin workflows for a CCTV operations product with real-time Firebase-backed capabilities.', iconAsset: 'assets/images/secure_plus.jpg', icon: Icons.security, role: 'Freelance Developer', statusColor: Colors.orange, tags: ['Flutter','Firebase','BLoC','GoRouter','FCM','l10n'], impact: 'Shipped a bilingual, notification-ready app tailored for business operations.', gallery: ['assets/images/secure_plus.png','assets/images/secure_plus_1.png','assets/images/secure_plus_2.png','assets/images/secure_plus_3.png','assets/images/secure_plus_4.png','assets/images/secure_plus_5.png','assets/images/secure_plus_6.png','assets/images/secure_plus_7.png'], isMobile: isMobile, launch: _launch)),
            ]),
          )),
        ),
      ),
    );
  }

  Widget _catLabel(String label, Color color, bool isMobile) {
    return Row(children: [
      Container(width: 10, height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6)])),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: isMobile ? 14 : 16,
        fontWeight: FontWeight.w600, color: color, letterSpacing: 0.5)),
      const SizedBox(width: 12),
      Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.2))),
    ]);
  }

  Widget _two(bool isMobile, List<Widget> ch) {
    if (isMobile) return Column(children: [ch[0], const SizedBox(height: 16), ch[1]]);
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: ch[0]), const SizedBox(width: 20), Expanded(child: ch[1]),
      ]),
    );
  }
}

class _AppCard extends StatelessWidget {
  final String title, description, role;
  final String? impact;
  final IconData icon;
  final String? iconAsset, playUrl, appStoreUrl, companyBadge;
  final Color statusColor;
  final List<String> tags, gallery;
  final bool isMobile;
  final void Function(String) launch;

  const _AppCard({
    required this.title, required this.description, required this.icon,
    required this.role, required this.statusColor, required this.tags,
    required this.gallery, required this.isMobile, required this.launch,
    this.impact,
    this.iconAsset, this.playUrl, this.appStoreUrl, this.companyBadge,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = playUrl != null;
    return RevealAnimator(
      child: ShimmerCard(
        glowColor: statusColor,
        enableEffects: true,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.white.withValues(alpha: 0.07), Colors.white.withValues(alpha: 0.02)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: iconAsset != null
                  ? Image.asset(iconAsset!, width: 52, height: 52, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _iconFallback())
                  : _iconFallback(),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(
                fontSize: isMobile ? 15 : 17, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 4, children: [
                StatusBadge(label: isLive ? 'Live' : 'Launching Soon', color: statusColor),
                StatusBadge(label: role, color: const Color(0xFF3B82F6)),
                if (companyBadge != null) CompanyBadge(label: companyBadge!),
              ]),
            ])),
          ]),
          const SizedBox(height: 16),
          Text(description, style: TextStyle(fontSize: isMobile ? 13 : 14,
            color: Colors.white.withValues(alpha: 0.75), height: 1.55)),
          if (impact != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.insights_rounded,
                      color: Color(0xFF60A5FA),
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      impact!,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        color: Colors.white.withValues(alpha: 0.84),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(spacing: 6, runSpacing: 6, children: tags.map((t) => _techTag(t)).toList()),
          if (gallery.isNotEmpty) ...[
            const SizedBox(height: 18),
            GallerySection(images: gallery, accentColor: statusColor, isMobile: isMobile),
          ],
          if (isLive) ...[
            const SizedBox(height: 18),
            Row(children: [
              if (playUrl != null) ...[
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => launch(playUrl!),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Play Store', style: TextStyle(fontSize: 13)),
                )),
                if (appStoreUrl != null) const SizedBox(width: 10),
              ],
              if (appStoreUrl != null)
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => launch(appStoreUrl!),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                    side: const BorderSide(color: Color(0xFF3B82F6)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.apple, size: 16),
                  label: const Text('App Store', style: TextStyle(fontSize: 13)),
                )),
            ]),
          ],
        ]),
      ),
    );
  }

  Widget _iconFallback() => Container(
    width: 52, height: 52,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)]),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(icon, color: Colors.white, size: 26),
  );

  Widget _techTag(String tag) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.5)),
    ),
    child: Text(tag, style: TextStyle(fontSize: isMobile ? 12 : 13, color: Colors.white)),
  );
}
