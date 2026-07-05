import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class EmailService {
  static const _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    if (!AppStrings.isEmailJsConfigured) {
      throw EmailServiceException(
        'EmailJS is not configured. Add your Public Key, Service ID, and '
        'Template ID in lib/utils/constants.dart',
      );
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': AppStrings.emailJsServiceId,
        'template_id': AppStrings.emailJsTemplateId,
        'user_id': AppStrings.emailJsPublicKey,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'message': message,
          'to_email': AppStrings.contactEmailTo,
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw EmailServiceException(
        'Email failed (${response.statusCode}). Check EmailJS settings.',
      );
    }
  }
}

class EmailServiceException implements Exception {
  EmailServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
