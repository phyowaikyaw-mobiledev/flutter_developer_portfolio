import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/testimonial_model.dart';
import '../services/firestore_service.dart';
import '../widgets/common/section_title.dart';
import '../widgets/common/shimmer_card.dart';
import '../widgets/common/reveal_animator.dart';

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key});

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen>
    with TickerProviderStateMixin {
  final _service = FirestoreService();
  List<TestimonialModel> _testimonials = [];
  bool _loading = false;
  bool _isMasonryExpanded = false;

  // Form controllers
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();
  bool _submitted = false, _formError = false, _submitting = false;
  Uint8List? _avatarBytes;
  String? _avatarBase64;

  // Scroll controller for floating action button
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _showFloatingButton = _scrollController.offset > 200;
    });
  }

  Future<void> _loadTestimonials() async {
    setState(() => _loading = true);
    try {
      final loaded = await _service.loadTestimonials();
      setState(() => _testimonials = loaded);
    } catch (_) {
    } finally {
      setState(() => _loading = false);
    }
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
      });
      await _loadTestimonials();
      setState(() {
        _submitted = true;
      });
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _submitted = false);
      });

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      floatingActionButton: _showFloatingButton && !isMobile
          ? _MorphingFab(
              onTap: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              },
            )
          : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 32,
                isMobile ? 80 : 100,
                isMobile ? 16 : 32,
                0,
              ),
              child: Column(
                children: [
                  SectionTitle(title: 'What People Say', isMobile: isMobile),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "Kind words from colleagues and clients I've worked with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 15,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Masonry Grid (Testimonials First)
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
              )
            else if (_testimonials.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
                child: _emptyState(isMobile),
              )
            else
              _buildMasonryGrid(isMobile),

            // Stats Dashboard (After Testimonials)
            if (_testimonials.isNotEmpty) ...[
              const SizedBox(height: 48),
              _buildStatsDashboard(isMobile),
            ],

            const SizedBox(height: 48),

            // Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: _buildConsistentForm(isMobile),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsDashboard(bool isMobile) {
    final total = _testimonials.length;
    final uniqueCompanies = _testimonials
        .map((t) => t.company)
        .where((c) => c.isNotEmpty)
        .toSet()
        .length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            'Testimonials',
            total.toString(),
            Icons.people_outline,
            isMobile,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          _statItem(
            'Companies',
            uniqueCompanies.toString(),
            Icons.business_outlined,
            isMobile,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          _statItem('Rating', '4.9 ★', Icons.star_outline, isMobile),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF3B82F6),
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 11 : 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildMasonryGrid(bool isMobile) {
    if (isMobile) {
      return Column(
        children: List.generate(_testimonials.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _KineticCard(testimonial: _testimonials[i], index: i),
          );
        }),
      );
    }

    final List<TestimonialModel> leftColumn = [];
    final List<TestimonialModel> rightColumn = [];

    for (int i = 0; i < _testimonials.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(_testimonials[i]);
      } else {
        rightColumn.add(_testimonials[i]);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: List.generate(leftColumn.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _KineticCard(testimonial: leftColumn[i], index: i * 2),
                );
              }),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: List.generate(rightColumn.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _KineticCard(
                    testimonial: rightColumn[i],
                    index: i * 2 + 1,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 64,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: const Color(0xFF3B82F6),
            size: 56,
          ),
          const SizedBox(height: 20),
          Text(
            'No testimonials yet.',
            style: TextStyle(
              fontSize: isMobile ? 17 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistentForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 28 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rate_review_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share Your Experience',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Worked with me? I'd love to hear from you.",
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isMobile ? 28 : 36),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      const Color(0xFF1E40AF).withValues(alpha: 0.2),
                    ],
                  ),
                  border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                ),
                child: _avatarBytes != null
                    ? ClipOval(
                        child: Image.memory(_avatarBytes!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            color: Color(0xFF3B82F6),
                            size: 26,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Photo',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6),
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
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 28),
          isMobile
              ? Column(
                  children: [
                    _consistentField(
                      'Full Name *',
                      Icons.person_outline,
                      _nameCtrl,
                    ),
                    const SizedBox(height: 16),
                    _consistentField(
                      'Job Title / Position',
                      Icons.work_outline,
                      _roleCtrl,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _consistentField(
                        'Full Name *',
                        Icons.person_outline,
                        _nameCtrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _consistentField(
                        'Job Title / Position',
                        Icons.work_outline,
                        _roleCtrl,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          _consistentField(
            'Company / Organization',
            Icons.business_outlined,
            _companyCtrl,
          ),
          const SizedBox(height: 16),
          _consistentField(
            'Your Feedback *',
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
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Please fill in your name and feedback.',
                    style: TextStyle(color: Colors.red.shade400, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: _submitting
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _submitting
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Submit Testimonial',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          if (_submitted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thank you!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Your testimonial has been added successfully.',
                          style: TextStyle(
                            color: Colors.green.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 5),
                Text(
                  'Your testimonial appears instantly after submitting.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _consistentField(
    String hint,
    IconData icon,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        prefixIcon: maxLines == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(icon, color: const Color(0xFF3B82F6), size: 18),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: maxLines > 1 ? 18 : 0,
          vertical: 16,
        ),
      ),
    );
  }
}

// ── Kinetic Typography Card (Consistent with Profile/Projects Theme) ─────────
class _KineticCard extends StatefulWidget {
  final TestimonialModel testimonial;
  final int index;

  const _KineticCard({required this.testimonial, required this.index});

  @override
  State<_KineticCard> createState() => _KineticCardState();
}

class _KineticCardState extends State<_KineticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
                border: Border.all(
                  color: _isHovered
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
                      : const Color(0xFF3B82F6).withValues(alpha: 0.25),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(0, _isHovered ? -2 : 0),
                      child: Row(
                        children: [
                          _ConsistentAvatar(widget.testimonial, 52),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.testimonial.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: _isHovered
                                        ? [
                                            Shadow(
                                              color: const Color(
                                                0xFF3B82F6,
                                              ).withValues(alpha: 0.5),
                                              blurRadius: 8,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.testimonial.role,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (widget.testimonial.company.isNotEmpty)
                                  Text(
                                    widget.testimonial.company,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF3B82F6,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getEmoji(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getEmotionLabel(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 16),
                    _KineticText(
                      text: _isExpanded
                          ? widget.testimonial.text
                          : (widget.testimonial.text.length > 150
                                ? '${widget.testimonial.text.substring(0, 150)}...'
                                : widget.testimonial.text),
                      animation: _controller,
                      index: widget.index,
                    ),
                    if (widget.testimonial.text.length > 150)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isExpanded ? 'Show less' : 'Read more',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: const Color(0xFF3B82F6),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _getTags().map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getEmoji() {
    final text = widget.testimonial.text.toLowerCase();
    if (text.contains('amazing') || text.contains('incredible')) return '🚀';
    if (text.contains('thanks') || text.contains('grateful')) return '🙏';
    if (text.contains('creative') || text.contains('innovative')) return '💡';
    if (text.contains('expert') || text.contains('professional')) return '🏆';
    return '😊';
  }

  String _getEmotionLabel() {
    final text = widget.testimonial.text.toLowerCase();
    if (text.contains('amazing') || text.contains('incredible'))
      return 'Amazing';
    if (text.contains('thanks') || text.contains('grateful')) return 'Grateful';
    if (text.contains('creative') || text.contains('innovative'))
      return 'Creative';
    if (text.contains('expert') || text.contains('professional'))
      return 'Expert';
    return 'Great';
  }

  List<String> _getTags() {
    final tags = <String>[];
    final text = widget.testimonial.text.toLowerCase();
    if (text.contains('teamwork')) tags.add('Teamwork');
    if (text.contains('creative')) tags.add('Creative');
    if (text.contains('fast')) tags.add('Fast');
    if (text.contains('professional')) tags.add('Professional');
    if (tags.isEmpty) tags.add('Great Work');
    return tags.take(3).toList();
  }
}

// ── Kinetic Text Widget ──────────────────────────────────────────────────────
// FIX: Replaced word-by-word Wrap (caused irregular spacing/justify look)
// with a single AnimatedBuilder that animates the whole text block as one unit.
// The entrance animation is a combined fade + slide-up, which keeps the
// kinetic feel while letting Flutter's text engine lay out words correctly.
class _KineticText extends StatefulWidget {
  final String text;
  final Animation<double> animation;
  final int index;

  const _KineticText({
    required this.text,
    required this.animation,
    required this.index,
  });

  @override
  State<_KineticText> createState() => _KineticTextState();
}

class _KineticTextState extends State<_KineticText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slide = Tween<double>(
      begin: 16.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger based on card index so cards don't all animate at once
    final staggerDelay = Duration(milliseconds: widget.index * 60);
    Future.delayed(staggerDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void didUpdateWidget(_KineticText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-animate when text changes (expand / collapse)
    if (oldWidget.text != widget.text) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.65,
              // FIX: left-align so Flutter uses normal word spacing
              // (was effectively justify because each word was a separate widget)
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

// ── Consistent Avatar ────────────────────────────────────────────────────────
class _ConsistentAvatar extends StatelessWidget {
  final TestimonialModel testimonial;
  final double size;

  const _ConsistentAvatar(this.testimonial, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: testimonial.avatarBase64 == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  const Color(0xFF1E40AF).withValues(alpha: 0.3),
                ],
              )
            : null,
        border: Border.all(color: const Color(0xFF3B82F6), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: testimonial.avatarBase64 != null
          ? ClipOval(
              child: Image.memory(
                base64Decode(testimonial.avatarBase64!),
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Text(
                testimonial.initials,
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.35,
                ),
              ),
            ),
    );
  }
}

// ── Morphing Floating Action Button ──────────────────────────────────────────
class _MorphingFab extends StatefulWidget {
  final VoidCallback onTap;

  const _MorphingFab({required this.onTap});

  @override
  State<_MorphingFab> createState() => _MorphingFabState();
}

class _MorphingFabState extends State<_MorphingFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final width = 56 + (40 * _controller.value);
            return Container(
              width: width,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.white, size: 24),
                  if (_controller.value > 0.5)
                    FadeTransition(
                      opacity: _controller,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Top',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
