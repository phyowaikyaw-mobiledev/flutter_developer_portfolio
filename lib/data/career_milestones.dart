class CareerMilestoneApp {
  const CareerMilestoneApp({
    required this.title,
    this.iconAsset,
  });

  final String title;
  final String? iconAsset;
}

class CareerMilestoneGroup {
  const CareerMilestoneGroup({
    required this.label,
    required this.apps,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final List<CareerMilestoneApp> apps;
}

const kCareerMilestoneSummary = (
  years: '2+',
  productionApps: '7',
  liveReleases: '3',
);

const kCareerMilestoneGroups = <CareerMilestoneGroup>[
  CareerMilestoneGroup(
    label: 'Root Studio Asia',
    subtitle: 'Live on Play Store & App Store',
    apps: [
      CareerMilestoneApp(
        title: 'DrZon Medical Service',
        iconAsset: 'assets/images/dr_zon.png',
      ),
      CareerMilestoneApp(
        title: 'Phone King Plus',
        iconAsset: 'assets/images/phoneking_icon.png',
      ),
      CareerMilestoneApp(
        title: 'Phone King Plus Admin',
        iconAsset: 'assets/images/phoneking_admin_icon.png',
      ),
    ],
  ),
  CareerMilestoneGroup(
    label: 'Root Studio Asia',
    subtitle: 'In Review',
    apps: [
      CareerMilestoneApp(
        title: 'TeeXpress Delivery',
        iconAsset: 'assets/images/teexpress_icon.png',
      ),
    ],
  ),
  CareerMilestoneGroup(
    label: 'Root Studio Asia',
    subtitle: 'Client Testing — Store Pending',
    apps: [
      CareerMilestoneApp(
        title: 'VIE Pharma',
        iconAsset: 'assets/images/vie_icon.png',
      ),
      CareerMilestoneApp(
        title: 'PAN Aesthetic',
        iconAsset: 'assets/images/pan_icon.png',
      ),
    ],
  ),
  CareerMilestoneGroup(
    label: 'Freelance',
    subtitle: 'Play Store Soon — Client Testing',
    apps: [
      CareerMilestoneApp(
        title: 'Secure Plus CCTV',
        iconAsset: 'assets/images/secure_plus.jpg',
      ),
    ],
  ),
];
