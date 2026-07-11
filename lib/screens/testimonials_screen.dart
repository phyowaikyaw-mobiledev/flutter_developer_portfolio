import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../models/testimonial_model.dart';
import '../services/firestore_service.dart';
import '../theme/portfolio_theme.dart';
import '../utils/constants.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({
    super.key,
    this.embeddedInAbout = false,
  });

  final bool embeddedInAbout;

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  final _service = FirestoreService();
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();
  bool _formError = false;
  bool _submitting = false;
  DateTime? _nextSubmitAt;
  Uint8List? _avatarBytes;
  String? _avatarBase64;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _avatarBytes = bytes;
          _avatarBase64 = base64Encode(bytes);
        });
      }
    } catch (_) {}
  }

  Future<void> _submit() async {
    final now = DateTime.now();
    if (_nextSubmitAt != null && now.isBefore(_nextSubmitAt!)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait a moment before submitting again.'),
          ),
        );
      }
      return;
    }

    final name = _nameCtrl.text.trim();
    final feedback = _feedbackCtrl.text.trim();
    if (name.isEmpty || feedback.isEmpty) {
      setState(() => _formError = true);
      return;
    }

    setState(() {
      _formError = false;
      _submitting = true;
    });

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final t = TestimonialModel(
        id: id,
        name: name,
        role: _roleCtrl.text.trim().isEmpty
            ? 'Colleague'
            : _roleCtrl.text.trim(),
        company: _companyCtrl.text.trim(),
        text: feedback,
        avatarBase64: _avatarBase64,
      );
      await _service.submitTestimonial(t);
      _nameCtrl.clear();
      _roleCtrl.clear();
      _companyCtrl.clear();
      _feedbackCtrl.clear();
      setState(() {
        _avatarBytes = null;
        _avatarBase64 = null;
        _nextSubmitAt = DateTime.now().add(const Duration(seconds: 30));
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit. Please try again.'),
            backgroundColor: Colors.red,
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
    final horizontalPad = isMobile ? 16.0 : 32.0;

    final body = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        widget.embeddedInAbout ? 20 : 8,
        horizontalPad,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.embeddedInAbout) ...[
                Text(
                  'Share Your Feedback',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Professional feedback from collaborators, clients, and teammates.',
                  style: TextStyle(
                    fontSize: PortfolioFontSizes.secondary,
                    color: p.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              _buildForm(isMobile, p),
            ],
          ),
        ),
      ),
    );

    if (widget.embeddedInAbout) {
      return body;
    }

    return Scaffold(
      backgroundColor: p.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/?section=about'),
                    icon: Icon(Icons.arrow_back, color: p.textPrimary),
                    tooltip: 'Back to About',
                  ),
                  Text(
                    'Share Feedback',
                    style: TextStyle(
                      fontSize: PortfolioFontSizes.secondary,
                      color: p.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isMobile, PortfolioColors p) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: p.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: p.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.border),
            ),
            child: Icon(
              Icons.rate_review_rounded,
              color: p.textMuted,
              size: 22,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 28),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.background,
                  border: Border.all(color: p.border, width: 2),
                ),
                child: _avatarBytes != null
                    ? ClipOval(
                        child: Image.memory(_avatarBytes!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: p.textMuted, size: 26),
                          const SizedBox(height: 4),
                          Text(
                            'Photo',
                            style: TextStyle(
                              fontSize: PortfolioFontSizes.caption,
                              color: p.textMuted,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Profile Photo (Optional)',
              style: TextStyle(
                fontSize: PortfolioFontSizes.label,
                color: p.textMuted,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 28),
          if (isMobile) ...[
            _field(p, 'Full Name *', Icons.person_outline, _nameCtrl),
            const SizedBox(height: 16),
            _field(p, 'Job Title / Position', Icons.work_outline, _roleCtrl),
          ] else
            Row(
              children: [
                Expanded(
                  child: _field(
                    p,
                    'Full Name *',
                    Icons.person_outline,
                    _nameCtrl,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _field(
                    p,
                    'Job Title / Position',
                    Icons.work_outline,
                    _roleCtrl,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          _field(p, 'Company / Organization', Icons.business_outlined, _companyCtrl),
          const SizedBox(height: 16),
          _field(
            p,
            'Your Professional Review *',
            Icons.chat_bubble_outline,
            _feedbackCtrl,
            maxLines: 5,
          ),
          if (_formError) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please fill in your name and feedback.',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: PortfolioFontSizes.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
                  (_submitting ||
                      (_nextSubmitAt != null &&
                          DateTime.now().isBefore(_nextSubmitAt!)))
                  ? null
                  : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: p.accentTeal,
                disabledBackgroundColor: p.border,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      (_nextSubmitAt != null &&
                              DateTime.now().isBefore(_nextSubmitAt!))
                          ? Icons.lock_clock_outlined
                          : Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
              label: Text(
                (_nextSubmitAt != null &&
                        DateTime.now().isBefore(_nextSubmitAt!))
                    ? 'Please Wait Before Next Review'
                    : 'Submit Review',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Reviews are published from the live Firestore feed. A short cooldown prevents duplicate submissions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: PortfolioFontSizes.label,
                color: p.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    PortfolioColors p,
    String hint,
    IconData icon,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(color: p.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: p.textMuted, fontSize: 14),
        prefixIcon: maxLines == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(icon, color: p.textMuted, size: 18),
              )
            : null,
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
          borderSide: BorderSide(color: p.border, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: maxLines > 1 ? 18 : 0,
          vertical: 16,
        ),
      ),
    );
  }
}
