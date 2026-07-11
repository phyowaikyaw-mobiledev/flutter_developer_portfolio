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

class ProductionAppChallenge {
  const ProductionAppChallenge({
    required this.title,
    required this.solution,
  });

  final String title;
  final String solution;
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
    required this.industries,
    this.iconAsset,
    this.impact,
    this.keyContribution,
    this.keyContributionPoints,
    this.challenges,
    this.keyFeatures,
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
  final List<String>? keyContributionPoints;
  final List<ProductionAppChallenge>? challenges;
  final List<String>? keyFeatures;
  final String? playUrl;
  final String? appStoreUrl;
  final List<String> gallery;
  final AppReleaseStatus releaseStatus;
  final List<AppIndustry> industries;
  final bool fullWidth;
  final bool fullBleedIcon;

  bool get isLive => playUrl != null;
}
