import 'package:flutter/material.dart';
import '../models/production_app.dart';
import '../utils/constants.dart';

ProductionApp? productionAppBySlug(String slug) {
  for (final app in kProductionApps) {
    if (app.slug == slug) return app;
  }
  return null;
}

const kProductionApps = <ProductionApp>[
  ProductionApp(
    slug: 'phone-king-plus-customer',
    title: 'Phone King Plus Customer',
    fullBleedIcon: true,
    description:
        'Built loyalty flows for points, rewards redemption, and customer engagement in a production retail environment.',
    keyContribution:
        'Customer loyalty flows — points, rewards redemption, and engagement.',
    iconAsset: 'assets/images/phoneking_icon.png',
    icon: Icons.phone_android,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: ['Flutter', 'REST API', 'Material Design'],
    impact:
        'Live on Play Store & App Store. Retail loyalty flows used by active customers. REST API integration with Material Design UI.',
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_customer',
    appStoreUrl:
        'https://apps.apple.com/th/app/phoneking-plus/id6757488887',
    gallery: [
      'assets/images/pk_1.png',
      'assets/images/pk_2.png',
      'assets/images/pk_3.png',
      'assets/images/pk_4.png',
      'assets/images/pk_5.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industry: AppIndustry.retailCommerce,
  ),
  ProductionApp(
    slug: 'phone-king-plus-admin',
    title: 'Phone King Plus Admin',
    description:
        'Implemented internal operations tools to manage stores, campaigns, and customer reward activity efficiently.',
    keyContribution:
        'Staff admin tools — store management, campaigns, and reward activity.',
    iconAsset: 'assets/images/phoneking_admin_icon.png',
    icon: Icons.admin_panel_settings,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: ['Flutter', 'REST API', 'Material Design'],
    impact:
        'Live on both stores. Dedicated admin app enabling staff workflows for store operations and customer reward management.',
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_admin',
    appStoreUrl:
        'https://apps.apple.com/th/app/phoneking-plus-admin/id6757606298',
    gallery: [
      'assets/images/pka_1.png',
      'assets/images/pka_2.png',
      'assets/images/pka_3.png',
      'assets/images/pka_4.png',
      'assets/images/pka_5.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industry: AppIndustry.retailCommerce,
  ),
  ProductionApp(
    slug: 'drzon-medical-service',
    title: 'DrZon Medical Service',
    description:
        'Developed patient-facing healthcare journeys — hospital referrals, medical records, appointments, and localized health content.',
    keyContribution:
        'Patient healthcare flows — referrals, records, appointments, and l10n.',
    iconAsset: 'assets/images/dr_zon.png',
    icon: Icons.local_hospital,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: ['Flutter', 'Dio', 'Clean Architecture', 'l10n'],
    impact:
        'Live on Play Store & App Store. Patient flows for MM/English — hospital referrals, medical records, appointments. Built with Dio, clean architecture, and localization.',
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.drzon',
    appStoreUrl:
        'https://apps.apple.com/th/app/drzon-medical-service/id6762826790',
    gallery: [
      'assets/images/drzon_1.png',
      'assets/images/drzon_2.png',
      'assets/images/drzon_3.png',
      'assets/images/drzon_4.png',
      'assets/images/drzon_5.png',
      'assets/images/drzon_6.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industry: AppIndustry.healthcare,
  ),
  ProductionApp(
    slug: 'teexpress',
    title: 'TeeXpress',
    description:
        'Built a logistics platform for parcel tracking, multi-order requests, secure payments, and real-time order timelines for Myanmar delivery operations.',
    keyContribution:
        'End-to-end shipping flows — tracking, multi-order, payments, and order status.',
    iconAsset: 'assets/images/teexpress_icon.png',
    icon: Icons.local_shipping,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: ['Flutter', 'REST API', 'Material Design', 'l10n'],
    impact: 'Submitted to Play Store and App Store — currently in review.',
    gallery: ['assets/images/teexpress_1.png'],
    releaseStatus: AppReleaseStatus.inReview,
    industry: AppIndustry.logisticsSecurity,
  ),
  ProductionApp(
    slug: 'pan-aesthetic',
    title: 'PAN Aesthetic',
    description:
        'Engineered shopping flows on layered architecture to support easier scaling, testing, and long-term maintenance.',
    keyContribution: 'E-commerce shopping flows on layered architecture.',
    iconAsset: 'assets/images/pan_icon.png',
    icon: Icons.shopping_bag,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: ['Flutter', 'REST API', 'Layered Architecture'],
    impact: 'In release pipeline — layered architecture for maintainable feature delivery.',
    gallery: [
      'assets/images/pan.png',
      'assets/images/pan_1.png',
      'assets/images/pan_2.png',
      'assets/images/pan_3.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    industry: AppIndustry.retailCommerce,
  ),
  ProductionApp(
    slug: 'vie-pharma',
    title: 'VIE Pharma',
    description:
        'Multi-role pharmaceutical platform for Myanmar — Promoter and Admin apps with order, commission, gift rewards, and MR reporting across four user roles.',
    keyContribution:
        'Shared UI library across two apps with four role-based home flows, OTP auth, adaptive shell, and MM/English localization.',
    iconAsset: 'assets/images/vie_icon.png',
    icon: Icons.medical_services,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Provider',
      'REST API',
      'Multi-role Auth',
      'Material 3',
      'l10n',
    ],
    impact:
        'In release pipeline — end-to-end order, commission, and reporting workflows for four user roles across two apps from a shared Flutter codebase.',
    gallery: [
      'assets/images/vie_1.png',
      'assets/images/vie_2.png',
      'assets/images/vie_3.png',
      'assets/images/vie_4.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    industry: AppIndustry.retailCommerce,
  ),
  ProductionApp(
    slug: 'secure-plus-cctv',
    title: 'Secure Plus CCTV',
    description:
        'Delivered customer and admin workflows for a CCTV operations product with real-time Firebase-backed capabilities.',
    keyContribution:
        'CCTV operations workflows with Firebase, BLoC, and push notifications.',
    iconAsset: 'assets/images/secure_plus.jpg',
    icon: Icons.security,
    role: 'Freelance Developer',
    statusColor: AppColors.statusLaunching,
    tags: ['Flutter', 'Firebase', 'BLoC', 'GoRouter', 'FCM', 'l10n'],
    impact:
        'In release pipeline — MM/English localized app with Firebase-backed real-time capabilities and FCM notifications.',
    gallery: [
      'assets/images/secure_plus.png',
      'assets/images/secure_plus_1.png',
      'assets/images/secure_plus_2.png',
      'assets/images/secure_plus_3.png',
      'assets/images/secure_plus_4.png',
      'assets/images/secure_plus_5.png',
      'assets/images/secure_plus_6.png',
      'assets/images/secure_plus_7.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    fullWidth: true,
    industry: AppIndustry.logisticsSecurity,
  ),
];
