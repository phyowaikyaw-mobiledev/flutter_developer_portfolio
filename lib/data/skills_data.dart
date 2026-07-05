const kSkillIconDir = 'assets/icons/skills';

class SkillItem {
  const SkillItem({
    required this.name,
    required this.logoAsset,
  });

  final String name;
  final String logoAsset;
}

class SkillCategory {
  const SkillCategory({
    required this.title,
    required this.skills,
    required this.filter,
  });

  final String title;
  final List<SkillItem> skills;
  final SkillFilter filter;
}

enum SkillFilter { all, mobile, tools }

const kSkillFilters = ['All', 'Mobile Applications', 'Tools'];

SkillItem _asset(String name, String file) =>
    SkillItem(name: name, logoAsset: '$kSkillIconDir/$file');

final kSkillCategories = <SkillCategory>[
  SkillCategory(
    title: 'Frameworks / Languages',
    filter: SkillFilter.mobile,
    skills: [
      _asset('Flutter', 'flutter.svg'),
      _asset('Dart', 'dart.svg'),
      _asset('Material Design', 'materialdesign.svg'),
      _asset('Cupertino Widgets', 'apple.svg'),
    ],
  ),
  SkillCategory(
    title: 'State Management',
    filter: SkillFilter.mobile,
    skills: [
      _asset('GetX', 'getx.svg'),
      _asset('BLoC', 'bloc.png'),
      _asset('Provider', 'provider.png'),
      _asset('Riverpod', 'riverpod.svg'),
    ],
  ),
  SkillCategory(
    title: 'API & Integration',
    filter: SkillFilter.mobile,
    skills: [
      _asset('REST API', 'openapiinitiative.svg'),
      _asset('Dio', 'dio.svg'),
      _asset('Retrofit', 'retrofit.png'),
      _asset('Firebase', 'firebase.svg'),
      _asset('Postman', 'postman.svg'),
      _asset('Swagger UI', 'swagger.svg'),
      _asset('Google Sheets', 'googlesheets.svg'),
    ],
  ),
  SkillCategory(
    title: 'Database',
    filter: SkillFilter.mobile,
    skills: [
      _asset('Firestore', 'firebase.svg'),
      _asset('Hive', 'hive.svg'),
      _asset('SQLite', 'sqlite.svg'),
      _asset('Realm DB', 'mongodb.svg'),
      _asset('Local Storage', 'sqlite.svg'),
    ],
  ),
  SkillCategory(
    title: 'Testing',
    filter: SkillFilter.tools,
    skills: [
      _asset('Unit Tests', 'flutter.svg'),
      _asset('Widget Tests', 'flutter.svg'),
      _asset('Integration Tests', 'testinglibrary.svg'),
      _asset('Flutter DevTools', 'googlechrome.svg'),
    ],
  ),
  SkillCategory(
    title: 'Deployment & Automation',
    filter: SkillFilter.tools,
    skills: [
      _asset('Play Store', 'play_store.png'),
      _asset('App Store', 'appstore.svg'),
      _asset('Fastlane', 'fastlane.svg'),
      _asset('Firebase Hosting', 'googlecloud.svg'),
      _asset('Vercel', 'vercel.svg'),
      _asset('CI/CD', 'githubactions.svg'),
      _asset('App Store Connect API', 'apple.svg'),
      _asset('TestFlight', 'apple.svg'),
      _asset('Xcode', 'xcode.svg'),
      _asset('Gradle', 'gradle.svg'),
      _asset('CocoaPods', 'cocoapods.svg'),
      _asset('rbenv / Ruby', 'ruby.svg'),
    ],
  ),
  SkillCategory(
    title: 'Version Control',
    filter: SkillFilter.tools,
    skills: [
      _asset('Git', 'git.svg'),
      _asset('GitHub', 'github.svg'),
      _asset('Code Review', 'github.svg'),
      _asset('Pull Requests', 'github.svg'),
    ],
  ),
  SkillCategory(
    title: 'Architecture',
    filter: SkillFilter.mobile,
    skills: [
      _asset('Clean Architecture', 'flutter.svg'),
      _asset('Repository Pattern', 'flutter.svg'),
      _asset('MVC', 'flutter.svg'),
      _asset('Navigation & Routing', 'dart.svg'),
      _asset('MVVM', 'flutter.svg'),
      _asset('Dependency Injection', 'get_it.png'),
      _asset('Component-Based Architecture', 'flutter.svg'),
      _asset('Layered Architecture', 'flutter.svg'),
    ],
  ),
  SkillCategory(
    title: 'UI/UX Design',
    filter: SkillFilter.tools,
    skills: [
      _asset('Figma', 'figma.svg'),
    ],
  ),
  SkillCategory(
    title: 'Tools & Utilities',
    filter: SkillFilter.tools,
    skills: [
      _asset('Android Studio', 'androidstudio.svg'),
      _asset('VS Code', 'vscode.svg'),
      _asset('Terminal / CLI', 'gnubash.svg'),
      _asset('l10n / ARB', 'googletranslate.svg'),
    ],
  ),
  SkillCategory(
    title: 'Project Management',
    filter: SkillFilter.tools,
    skills: [
      _asset('Slack', 'slack.svg'),
      _asset('Jira', 'jira.svg'),
    ],
  ),
  SkillCategory(
    title: 'AI-Assisted Development',
    filter: SkillFilter.tools,
    skills: [
      _asset('Claude Code', 'anthropic.svg'),
      _asset('Cursor', 'cursor.svg'),
      _asset('Prompt Engineering', 'anthropic.svg'),
    ],
  ),
];

SkillFilter skillFilterFromLabel(String label) {
  switch (label) {
    case 'Mobile Applications':
      return SkillFilter.mobile;
    case 'Tools':
      return SkillFilter.tools;
    default:
      return SkillFilter.all;
  }
}
