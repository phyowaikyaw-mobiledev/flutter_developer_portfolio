import '../models/testimonial_model.dart';

/// Infers how the reviewer relates to the portfolio owner.
/// Firestore `relationship` field overrides inference when set.
String testimonialRelationshipLabel(TestimonialModel t) {
  final override = t.relationship.trim();
  if (override.isNotEmpty) return override;

  final role = t.role.toLowerCase();
  final company = t.company.toLowerCase();
  final text = t.text.toLowerCase();
  final combined = '$role $company $text';

  if (combined.contains('hackathon')) return 'Hackathon Peer';

  if (role.contains('mentor') ||
      role.contains('teacher') ||
      role.contains('instructor') ||
      role.contains('professor') ||
      text.contains('mentor') ||
      text.contains('mentoring')) {
    return 'Mentor';
  }

  if (company.contains('root studio')) return 'Colleague';

  if (role.contains('client') ||
      role.contains('freelance') ||
      company.contains('freelance') ||
      text.contains('freelance')) {
    return 'Client';
  }

  if (text.contains('collaborated') || text.contains('work closely')) {
    return 'Collaborator';
  }

  if (_isLeadershipRole(role)) return 'Leadership';

  return 'Collaborator';
}

bool _isLeadershipRole(String role) {
  if (role.contains('manager') ||
      role.contains('director') ||
      role.contains('head of') ||
      role.contains(' vp') ||
      role.startsWith('vp ') ||
      role.contains('chief') ||
      role.contains('cto')) {
    return true;
  }

  const leadershipPhrases = [
    'team lead',
    'tech lead',
    'engineering lead',
    'engineering manager',
    'project lead',
  ];
  for (final phrase in leadershipPhrases) {
    if (role.contains(phrase)) return true;
  }

  return false;
}
