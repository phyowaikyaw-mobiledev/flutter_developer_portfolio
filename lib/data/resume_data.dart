class ResumeCertItem {
  const ResumeCertItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String date;
  final String imagePath;
}

const kRootStudioLogo = 'assets/images/rootstudio_logo.jpg';
const kUniversityLogo = 'assets/images/computer_university.jpg';
const kKmdLogo = 'assets/images/kmd_logo.jpg';
const kRubyLearnerLogo = 'assets/images/ruby_learner.jpg';
const kLetterOfRecommendationAsset =
    'assets/images/letter_of_recommendation.png';

const kShippedWorkRow1Titles = [
  'Phone King Plus Customer',
  'Phone King Plus Admin',
  'DrZon Medical Service',
];

const kShippedWorkRow2Titles = [
  'TeeXpress',
  'PAN Aesthetic',
  'VIE Pharma',
];

const kRootStudioExperience = (
  title: 'Flutter Developer',
  orgName: 'Root Studio Asia',
  subtitle: 'Yangon, Myanmar · Remote',
  logoAsset: kRootStudioLogo,
  period: 'Jul 2024 – Jul 2026',
  workMode: 'Remote',
  impactSummary:
      'Shipped production Flutter apps across retail, healthcare, logistics, and pharma.',
  releaseSummary:
      'Released to Google Play & App Store; Fastlane automation for build and deploy pipelines.',
  points: [
    'Built and released production mobile features used by active users across multiple business apps.',
    'Collaborated in code reviews and sprint planning under senior-led engineering standards.',
    'Applied clean architecture and repository patterns to keep feature code maintainable.',
    'Integrated REST APIs, Firebase services, and state management for stable runtime behavior.',
  ],
);

const kUniversityEducation = (
  institution: 'University of Computer, Mandalay',
  degree: 'Computer Science Major',
  logoAsset: kUniversityLogo,
  period: '2018 – 2020',
  note:
      'Studies were paused due to COVID-19 and national circumstances in Myanmar.',
  highlights: [
    'Data Structures & Algorithms',
    'Database Management Systems',
    'Software Engineering Principles',
    'Object-Oriented Programming',
  ],
);

const kKmdEducation = (
  institution: 'KMD Education Center',
  logoAsset: kKmdLogo,
  subtitle: 'Technical Certifications & Training',
);

const kKmdCertificates = <ResumeCertItem>[
  ResumeCertItem(
    title: 'Software Engineering Fundamentals',
    subtitle:
        'Introduction to Software Engineering, Microsoft Access & Visual Basic .NET',
    date: 'Aug 2019',
    imagePath: 'assets/images/cert_software_engineering.png',
  ),
  ResumeCertItem(
    title: 'Programming Concepts & Computer Systems Fundamentals',
    subtitle:
        'Problem Solving with Programming Concepts and Computer Systems Fundamentals',
    date: 'Jul 2019',
    imagePath: 'assets/images/cert_programming_concepts.png',
  ),
  ResumeCertItem(
    title: 'Computer Hardware & Networking Fundamentals',
    subtitle:
        'Practical A+ Hardware, Troubleshooting and Wireless Networking',
    date: 'May 2019',
    imagePath: 'assets/images/cert_hardware_networking.png',
  ),
  ResumeCertItem(
    title: 'Information Technology Fundamentals',
    subtitle:
        'Computer Applications, Internet and Digital Productivity Tools',
    date: 'Jul 2018',
    imagePath: 'assets/images/cert_information_technology.png',
  ),
  ResumeCertItem(
    title: 'Microsoft PowerPoint & Presentation Skills',
    subtitle: 'Microsoft PowerPoint 2013 Practical Training',
    date: 'Aug 2019',
    imagePath: 'assets/images/cert_powerpoint.png',
  ),
];

const kRubyLearnerOngoing = (
  provider: 'Ruby Learner',
  course: 'Flutter Advanced Class',
  logoAsset: kRubyLearnerLogo,
  schedule: 'Sat & Sun · Zoom',
  description:
      'Weekend live sessions with pre-recorded lessons, Q&A, and weekly assignments reviewed by the instructor.',
);
