import 'package:flutter/material.dart';

enum AppReleaseStatus { live, launchingSoon }

class ProductionApp {
  const ProductionApp({
    required this.title,
    required this.description,
    required this.icon,
    required this.role,
    required this.statusColor,
    required this.tags,
    required this.gallery,
    required this.releaseStatus,
    this.iconAsset,
    this.impact,
    this.keyContribution,
    this.playUrl,
    this.appStoreUrl,
    this.companyBadge,
    this.fullWidth = false,
  });

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
  final bool fullWidth;

  bool get isLive => playUrl != null;
}
