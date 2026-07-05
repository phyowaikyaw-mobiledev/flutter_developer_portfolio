import 'package:flutter/material.dart';

class ProcessStep {
  const ProcessStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final int number;
  final IconData icon;
  final String title;
  final String description;
}

const kProcessSteps = <ProcessStep>[
  ProcessStep(
    number: 1,
    icon: Icons.manage_search_outlined,
    title: 'Understand the product',
    description:
        'Clarify users, scope, and API contracts before writing code.',
  ),
  ProcessStep(
    number: 2,
    icon: Icons.design_services_outlined,
    title: 'Design the experience',
    description:
        'Responsive Material UI with MM/English localization on every screen.',
  ),
  ProcessStep(
    number: 3,
    icon: Icons.code_outlined,
    title: 'Build for production',
    description:
        'Modular features, clean structure, tested APIs — built for seamless handoff.',
  ),
  ProcessStep(
    number: 4,
    icon: Icons.rocket_launch_outlined,
    title: 'Release and iterate',
    description:
        'Store submission, crash fixes, and post-launch improvements.',
  ),
];
