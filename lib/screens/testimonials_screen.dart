import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/testimonial_model.dart';
import '../services/firestore_service.dart';
import '../widgets/common/section_title.dart';

Color _testimonialAccentColor(int index) {
  const colors = [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF06B6D4)];
  return colors[index % colors.length];
}

String _testimonialChipLabel(TestimonialModel t, int index) {
  final r = t.role.toLowerCase();
  if (r.contains('client')) return 'CLIENT';
  if (r.contains('manager') || r.contains('lead')) return 'LEADERSHIP';
  if (r.contains('mentor')) return 'MENTOR';
  return ['PEER REVIEW', 'ENDORSEMENT', 'COLLABORATION'][index % 3];
}

const _verifiedBannerMessage =
    'Feedback from collaborators and teammates I have worked with — '
    'each review is personally verified before publishing';

/// Decoded avatar bytes cache — avoids re-decoding base64 on every rebuild.
final _decodedAvatarCache = <String, Uint8List>{};

Uint8List _cachedAvatarBytes(String id, String base64) {
  return _decodedAvatarCache.putIfAbsent(id, () => base64Decode(base64));
}

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key, this.embeddedInAbout = false});

  final bool embeddedInAbout;

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen>
    with TickerProviderStateMixin {
  final _service = FirestoreService();
  List<TestimonialModel> _testimonials = [];
  bool _loading = false;

  // Form controllers
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();
  bool _submitted = false, _formError = false, _submitting = false;
  DateTime? _nextSubmitAt;
  Uint8List? _avatarBytes;
  String? _avatarBase64;

  // Scroll controller for floating action button
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _formSectionKey = GlobalKey();
  final ValueNotifier<bool> _showFab = ValueNotifier(false);

  void _scrollToForm() {
    final ctx = _formSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        alignment: 0.12,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.offset > 200;
    if (_showFab.value != show) {
      _showFab.value = show;
    }
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
      });
      await _loadTestimonials();
      setState(() {
        _submitted = true;
        _nextSubmitAt = DateTime.now().add(const Duration(seconds: 30));
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
  void dispose() {
    _showFab.dispose();
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
    final topPad = widget.embeddedInAbout
        ? (isMobile ? 20.0 : 28.0)
        : (isMobile ? 80.0 : 100.0);

    final scrollBody = SingleChildScrollView(
      controller: _scrollController,
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 32,
              topPad,
              isMobile ? 16 : 32,
              0,
            ),
            child: Column(
              children: [
                if (!widget.embeddedInAbout) ...[
                  SectionTitle(
                    title: 'What People Say',
                    isMobile: isMobile,
                    subtitle:
                        'Professional feedback from collaborators, clients, and teammates.',
                  ),
                  const SizedBox(height: 12),
                ],
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
                    _verifiedBannerMessage,
                    textAlign: TextAlign.center,
                    softWrap: true,
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
          if (_loading)
            _TestimonialsLoadingSkeleton(isMobile: isMobile)
          else if (_testimonials.isNotEmpty) ...[
            _buildMasonryGrid(isMobile, _testimonials, firstIndex: 0),
            const SizedBox(height: 48),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
                child: _buildStatsDashboard(isMobile),
              ),
          ] else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: _emptyState(isMobile),
            ),
          const SizedBox(height: 48),
          KeyedSubtree(
            key: _formSectionKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: _buildConsistentForm(isMobile),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );

    if (widget.embeddedInAbout) {
      return ColoredBox(color: const Color(0xFF0A0E27), child: scrollBody);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _showFab,
      builder: (context, showFab, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E27),
          floatingActionButton: !showFab
              ? null
              : isMobile
              ? FloatingActionButton(
                  onPressed: _scrollToForm,
                  backgroundColor: const Color(0xFF2563EB),
                  tooltip: 'Share feedback',
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                  ),
                )
              : _MorphingFab(
                  onTap: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    );
                  },
                ),
          body: scrollBody,
        );
      },
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
        horizontal: isMobile ? 14 : 18,
        vertical: isMobile ? 14 : 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B).withValues(alpha: 0.45),
            const Color(0xFF0F172A).withValues(alpha: 0.65),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.26),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _statMetric(
                        'Total Reviews',
                        total.toString(),
                        Icons.people_outline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statMetric(
                        'Companies',
                        uniqueCompanies.toString(),
                        Icons.business_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _statMetric(
                  'Verified reviews',
                  'Live',
                  Icons.verified_outlined,
                  tooltip:
                      'Each review is personally verified in Firestore before it appears here.',
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _statMetric(
                    'Total Reviews',
                    total.toString(),
                    Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statMetric(
                    'Companies',
                    uniqueCompanies.toString(),
                    Icons.business_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statMetric(
                    'Verified reviews',
                    'Live',
                    Icons.verified_outlined,
                    tooltip:
                        'Each review is personally verified in Firestore before it appears here.',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statMetric(
    String label,
    String value,
    IconData icon, {
    String? tooltip,
  }) {
    final box = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF60A5FA), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.58),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (tooltip == null) return box;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: box,
    );
  }

  Widget _buildMasonryGrid(
    bool isMobile,
    List<TestimonialModel> items, {
    required int firstIndex,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    if (isMobile) {
      return Column(
        children: List.generate(items.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _KineticCard(
              key: ValueKey(items[i].id),
              testimonial: items[i],
              index: firstIndex + i,
            ),
          );
        }),
      );
    }

    final List<TestimonialModel> leftColumn = [];
    final List<TestimonialModel> rightColumn = [];

    for (int i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(items[i]);
      } else {
        rightColumn.add(items[i]);
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: List.generate(leftColumn.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _KineticCard(
                        key: ValueKey(leftColumn[i].id),
                        testimonial: leftColumn[i],
                        index: firstIndex + i * 2,
                      ),
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
                        key: ValueKey(rightColumn[i].id),
                        testimonial: rightColumn[i],
                        index: firstIndex + i * 2 + 1,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Professional Feedback',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Your feedback helps recruiters and collaborators evaluate my work quality.',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white.withValues(alpha: 0.58),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'New submissions are reviewed before they appear on this page.',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: const Color(0xFF93C5FD).withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please fill in your name and feedback.',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 13,
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
            child: ElevatedButton(
              onPressed:
                  (_submitting ||
                      (_nextSubmitAt != null &&
                          DateTime.now().isBefore(_nextSubmitAt!)))
                  ? null
                  : _submit,
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (_nextSubmitAt != null &&
                                      DateTime.now().isBefore(_nextSubmitAt!))
                                  ? Icons.lock_clock_outlined
                                  : Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                (_nextSubmitAt != null &&
                                        DateTime.now().isBefore(_nextSubmitAt!))
                                    ? 'Please Wait Before Next Review'
                                    : 'Submit Review',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
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
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.16),
                    const Color(0xFF059669).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF34D399).withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF6EE7B7),
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Review submitted successfully',
                          style: TextStyle(
                            color: Color(0xFFA7F3D0),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Thanks for your professional feedback. Your review is now visible in the live feed.',
                          style: TextStyle(
                            color: const Color(
                              0xFFD1FAE5,
                            ).withValues(alpha: 0.82),
                            fontSize: 12,
                            height: 1.45,
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
            child: Text(
              'Reviews are published from the live Firestore feed. A short cooldown prevents duplicate submissions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.36),
              ),
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
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.5),
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

  const _KineticCard({
    super.key,
    required this.testimonial,
    required this.index,
  });

  @override
  State<_KineticCard> createState() => _KineticCardState();
}

class _KineticCardState extends State<_KineticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

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

  void _openFullReview() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640, maxHeight: 560),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.testimonial.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.testimonial.role}${widget.testimonial.company.isNotEmpty ? ' • ${widget.testimonial.company}' : ''}',
                style: TextStyle(
                  color: const Color(0xFF60A5FA).withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.testimonial.text,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.86),
                      fontSize: 14,
                      height: 1.65,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF60A5FA),
                    size: 16,
                  ),
                  label: const Text(
                    'Done',
                    style: TextStyle(color: Color(0xFF93C5FD)),
                  ),
                ),
              ),
              Text(
                'Press Esc to close',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pad = 20.0;
    const avatarSize = 50.0;
    const nameSize = 16.0;
    const quoteH = 120.0;
    const quoteLines = 5;
    const radius = 20.0;
    final accent = _testimonialAccentColor(widget.index);
    final chipLabel = _testimonialChipLabel(widget.testimonial, widget.index);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.055),
                  Colors.white.withValues(alpha: 0.018),
                ],
              ),
              border: Border.all(
                color: _isHovered
                    ? accent.withValues(alpha: 0.5)
                    : accent.withValues(alpha: 0.28),
                width: _isHovered ? 1.35 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.14),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border(
                  left: BorderSide(
                    color: accent.withValues(alpha: 0.75),
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(pad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Text(
                            chipLabel,
                            style: TextStyle(
                              fontSize: 9.5,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w700,
                              color: accent.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                color: Color(0xFF34D399),
                                size: 11,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'VERIFIED',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF34D399),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.format_quote_rounded,
                          color: accent.withValues(alpha: 0.65),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ConsistentAvatar(widget.testimonial, avatarSize),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.testimonial.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: nameSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.testimonial.role,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF60A5FA),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (widget.testimonial.company.isNotEmpty)
                                Text(
                                  widget.testimonial.company,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.56),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: quoteH,
                      child: _KineticText(
                        text: widget.testimonial.text,
                        animation: _controller,
                        index: widget.index,
                        maxLines: quoteLines,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: _openFullReview,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Read full review',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF60A5FA),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new_rounded,
                              color: Color(0xFF60A5FA),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
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
  final int? maxLines;

  const _KineticText({
    required this.text,
    required this.animation,
    required this.index,
    this.maxLines,
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
            maxLines: widget.maxLines,
            overflow: widget.maxLines != null
                ? TextOverflow.ellipsis
                : TextOverflow.visible,
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
    return RepaintBoundary(
      child: Container(
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
                  _cachedAvatarBytes(
                    testimonial.id,
                    testimonial.avatarBase64!,
                  ),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  width: size,
                  height: size,
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
      ),
    );
  }
}

// ── Loading skeleton (testimonial-shaped placeholders) ─────────────────────
class _TestimonialsLoadingSkeleton extends StatefulWidget {
  final bool isMobile;

  const _TestimonialsLoadingSkeleton({required this.isMobile});

  @override
  State<_TestimonialsLoadingSkeleton> createState() =>
      _TestimonialsLoadingSkeletonState();
}

class _TestimonialsLoadingSkeletonState
    extends State<_TestimonialsLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _shimmerBar(double height, {double? width}) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + 2.4 * t, 0),
              end: Alignment(-0.2 + 2.4 * t, 0),
              colors: [
                const Color(0xFF1E293B).withValues(alpha: 0.55),
                const Color(0xFF3B82F6).withValues(alpha: 0.2),
                const Color(0xFF1E293B).withValues(alpha: 0.55),
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }

  Widget _skeletonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 0,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.18),
        ),
        color: Colors.white.withValues(alpha: 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 130, child: _shimmerBar(22)),
              const Spacer(),
              SizedBox(width: 22, child: _shimmerBar(22)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: _shimmerBar(50, width: 50),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _shimmerBar(14),
                    const SizedBox(height: 8),
                    _shimmerBar(12),
                    const SizedBox(height: 8),
                    FractionallySizedBox(
                      widthFactor: 0.55,
                      child: _shimmerBar(10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _shimmerBar(2),
          const SizedBox(height: 14),
          _shimmerBar(12),
          const SizedBox(height: 8),
          _shimmerBar(12),
          const SizedBox(height: 8),
          FractionallySizedBox(widthFactor: 0.92, child: _shimmerBar(10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        child: Column(
          children: List.generate(3, (_) => _skeletonCard()),
        ),
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _skeletonCard()),
              const SizedBox(width: 20),
              Expanded(child: _skeletonCard()),
            ],
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
