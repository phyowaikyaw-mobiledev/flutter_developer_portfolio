class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final DateTime createdAt;
  final bool read;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
    this.read = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
      };

  factory ContactMessage.fromMap(Map<String, dynamic> map) => ContactMessage(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        message: map['message'] as String? ?? '',
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
            DateTime.now(),
        read: map['read'] as bool? ?? false,
      );
}
