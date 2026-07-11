import 'package:flutter/material.dart';
import '../../services/email_service.dart';
import '../../theme/portfolio_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/common/zeel_section_header.dart';
import '../../widgets/contact/google_map_embed.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _emailService = EmailService();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _submitted = false;
  bool _attemptedSubmit = false;

  static const _requiredMessage = 'Please fill out this field.';
  static const _errorColor = Color(0xFFEF4444);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _attemptedSubmit = true);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await _emailService.sendContactMessage(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
      );
      if (mounted) {
        setState(() {
          _submitted = true;
          _attemptedSubmit = false;
          _nameCtrl.clear();
          _emailCtrl.clear();
          _messageCtrl.clear();
        });
      }
    } on EmailServiceException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send. Please try email directly.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.portfolio;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZeelSectionHeader(title: 'Hire Me'),
        const SizedBox(height: 20),
        _mapPreview(),
        const SizedBox(height: 28),
        const ZeelSectionHeader(title: 'Contact Form', showAccent: false),
        const SizedBox(height: 16),
        _form(p, isMobile),
      ],
    );
  }

  Widget _mapPreview() {
    return const GoogleMapEmbed(
      height: 360,
      embedUrl: AppStrings.mapEmbedUrl,
      openUrl: AppStrings.mapOpenUrl,
    );
  }

  Widget _form(PortfolioColors p, bool isMobile) {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: p.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.activeGreen.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, color: p.activeGreen, size: 40),
            const SizedBox(height: 12),
            Text(
              'Message sent successfully!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: p.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "I'll get back to you within 24 hours.",
              style: TextStyle(
                fontSize: PortfolioFontSizes.secondary,
                color: p.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _submitted = false),
              child: Text('Send another', style: TextStyle(color: p.accentTeal)),
            ),
          ],
        ),
      );
    }

    final autovalidate = _attemptedSubmit
        ? AutovalidateMode.always
        : AutovalidateMode.disabled;

    return Form(
      key: _formKey,
      autovalidateMode: autovalidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isMobile
              ? Column(
                  children: [
                    _field(
                      p,
                      controller: _nameCtrl,
                      label: 'Full name',
                      validator: _required,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      p,
                      controller: _emailCtrl,
                      label: 'Email address',
                      validator: _email,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        p,
                        controller: _nameCtrl,
                        label: 'Full name',
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _field(
                        p,
                        controller: _emailCtrl,
                        label: 'Email address',
                        validator: _email,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 14),
          _field(
            p,
            controller: _messageCtrl,
            label: 'Your Message',
            maxLines: 6,
            validator: _required,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: p.accentTeal,
                foregroundColor: AppColors.background,
                disabledBackgroundColor: p.border,
                disabledForegroundColor: p.textMuted,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _submitting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : const Icon(Icons.send_outlined, size: 18),
              label: const Text('Send Message'),
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return _requiredMessage;
    return null;
  }

  String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return _requiredMessage;
    if (!v.contains('@')) return 'Please enter a valid email.';
    return null;
  }

  Widget _field(
    PortfolioColors p, {
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _errorColor, width: 1.5),
    );

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: p.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: p.textMuted),
        filled: true,
        fillColor: p.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.accentTeal),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorStyle: const TextStyle(color: _errorColor, fontSize: 12),
      ),
    );
  }
}
