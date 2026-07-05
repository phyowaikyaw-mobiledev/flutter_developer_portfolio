import 'package:flutter/material.dart';

enum AppReleaseStatus { live, inReview, launchingSoon }

extension AppReleaseStatusLabels on AppReleaseStatus {
  String get label => switch (this) {
        AppReleaseStatus.live => 'Live',
        AppReleaseStatus.inReview => 'In Review',
        AppReleaseStatus.launchingSoon => 'Launching Soon',
      };

  bool get isUpcoming => this != AppReleaseStatus.live;
}

enum AppIndustry {
  healthcare,
  retailCommerce,
  logisticsSecurity,
}

extension AppIndustryLabels on AppIndustry {
  String get filterLabel => switch (this) {
        AppIndustry.healthcare => 'Healthcare',
        AppIndustry.retailCommerce => 'Retail & Commerce',
        AppIndustry.logisticsSecurity => 'Logistics & Security',
      };
}

class ProductionApp {
  const ProductionApp({
    required this.slug,
    required this.title,
    required this.description,
    required this.icon,
    required this.role,
    required this.statusColor,
    required this.tags,
    required this.gallery,
    required this.releaseStatus,
    required this.industry,
    this.iconAsset,
    this.impact,
    this.keyContribution,
    this.playUrl,
    this.appStoreUrl,
    this.companyBadge,
    this.fullWidth = false,
    this.fullBleedIcon = false,
  });

  final String slug;
  final String title;
  final String description;
  final IconData icon;
  final String? iconAsset;
  final String role;
  final Color statusColor;
  final String? companyBadge;
  final List<String> tags;
  final String? impact;
  final String? keyContribution;
  final String? playUrl;
  final String? appStoreUrl;
  final List<String> gallery;
  final AppReleaseStatus releaseStatus;
  final AppIndustry industry;
  final bool fullWidth;
  final bool fullBleedIcon;

  bool get isLive => playUrl != null;
}
