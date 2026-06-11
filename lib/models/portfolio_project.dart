import 'package:flutter/material.dart';

class PortfolioProject {
  const PortfolioProject({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.desc,
    required this.tags,
    required this.github,
    required this.icon,
    required this.status,
    required this.statusColor,
    required this.gallery,
    this.liveUrl,
    this.featured = false,
    this.learningArchive = false,
  });

  final String title;
  final String subtitle;
  final String image;
  final String desc;
  final List<String> tags;
  final String? liveUrl;
  final String github;
  final IconData icon;
  final String status;
  final Color statusColor;
  final bool featured;
  final bool learningArchive;
  final List<String> gallery;
}
