import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phyo Wai Kyaw - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
      ),
      home: const PortfolioHome(),
    );
  }
}

class TestimonialModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final String text;
  final String? avatarBase64;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.text,
    this.avatarBase64,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, math.min(2, name.length)).toUpperCase();
  }

  Color get avatarColor {
    final colors = [
      const Color(0xFF1E40AF),
      const Color(0xFF7C3AED),
      const Color(0xFF065F46),
      const Color(0xFF9D174D),
      const Color(0xFF92400E),
      const Color(0xFF1E3A5F),
    ];
    return colors[name.length % colors.length];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'role': role,
    'company': company,
    'text': text,
    'avatarBase64': avatarBase64,
  };

  factory TestimonialModel.fromMap(Map<String, dynamic> map) =>
      TestimonialModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        role: map['role'] ?? '',
        company: map['company'] ?? '',
        text: map['text'] ?? '',
        avatarBase64: map['avatarBase64'],
      );
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  bool _showAppBar = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'testimonials';

  int _currentTestimonialPage = 0;
  late PageController _testimonialPageController;
  List<TestimonialModel> _testimonials = [];
  bool _isLoadingTestimonials = false;
  Set<int> _expandedCards = {};
  Timer? _autoSlideTimer;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleTFController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  bool _testimonialSubmitted = false;
  bool _formError = false;
  bool _isSubmitting = false;

  // Image upload
  Uint8List? _avatarBytes;
  String? _avatarBase64;

  // Typing animation
  int _typingIndex = 0;
  String _typedText = '';
  bool _isDeleting = false;
  Timer? _typingTimer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;
  final List<String> _typingTexts = [
    'Phyo Wai Kyaw',
    'Flutter Developer',
    'Mobile Developer',
  ];

  final List<String> _typingAvatars = [
    'assets/images/phyo.jpg',
    'assets/images/flutter_icon.png',
    'assets/images/mobile_icon.png',
  ];

  String _activeNav = '~/';

  final Map<String, double> _sectionOffsets = {
    '~/': 0,
    'Profile': 900,
    'Skills': 1800,
    'Apps': 2700,
    'Projects': 3700,
    'Experience': 6200,
    'Awards': 8800,
    'Testimonials': 9300,
    'Contact': 10200,
  };

  bool _testimonialControllerReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_testimonialControllerReady) {
      final isMobile = MediaQuery.of(context).size.width < 768;
      _testimonialPageController = PageController(
        viewportFraction: isMobile ? 0.88 : 0.42,
      );
      _testimonialControllerReady = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
    _testimonialPageController = PageController(
      viewportFraction: 0.42,
    ); // temp, overridden in didChangeDependencies
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        _showAppBar = offset > 100;
        String detected = '~/';
        _sectionOffsets.forEach((label, sectionOffset) {
          if (offset >= sectionOffset - 200) detected = label;
        });
        _activeNav = detected;
      });
    });
    _startAutoSlide();
    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  double _typingOpacity = 1.0;

  void _startTyping() {
    _typingTimer?.cancel();
    const typeSpeed = Duration(milliseconds: 50);
    void tick(Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final current = _typingTexts[_typingIndex];
      setState(() {
        if (_typedText.length < current.length) {
          _typedText = current.substring(0, _typedText.length + 1);
        } else {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (!mounted) return;
            setState(() => _typingOpacity = 0.0);
            Future.delayed(const Duration(milliseconds: 350), () {
              if (!mounted) return;
              setState(() {
                _typingIndex = (_typingIndex + 1) % _typingTexts.length;
                _typedText = '';
                _typingOpacity = 1.0;
              });
              Future.delayed(const Duration(milliseconds: 80), () {
                if (mounted) _startTyping();
              });
            });
          });
        }
      });
    }

    _typingTimer = Timer.periodic(typeSpeed, tick);
  }

  bool _slideForward = true;

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_testimonials.isEmpty || !mounted) return;
      if (!_testimonialPageController.hasClients) return;
      final total = _testimonials.length;
      if (total <= 1) return;

      int next = _currentTestimonialPage + (_slideForward ? 1 : -1);
      if (next >= total) {
        _slideForward = false;
        next = _currentTestimonialPage - 1;
      } else if (next < 0) {
        _slideForward = true;
        next = _currentTestimonialPage + 1;
      }
      _testimonialPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _avatarBytes = bytes;
          _avatarBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  Future<void> _loadTestimonials() async {
    setState(() => _isLoadingTestimonials = true);
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('id', descending: true)
          .get();
      final loaded = snapshot.docs
          .map((doc) => TestimonialModel.fromMap(doc.data()))
          .toList();
      setState(() => _testimonials = loaded);
      _startAutoSlide();
    } catch (e) {
      debugPrint('Error loading testimonials: $e');
    } finally {
      setState(() => _isLoadingTestimonials = false);
    }
  }

  Future<void> _submitTestimonial() async {
    final name = _nameController.text.trim();
    final role = _roleTFController.text.trim();
    final company = _companyController.text.trim();
    final feedback = _feedbackController.text.trim();
    if (name.isEmpty || feedback.isEmpty) {
      setState(() => _formError = true);
      return;
    }
    setState(() {
      _formError = false;
      _isSubmitting = true;
    });
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final t = TestimonialModel(
        id: id,
        name: name,
        role: role.isEmpty ? 'Colleague' : role,
        company: company,
        text: feedback,
        avatarBase64: _avatarBase64,
      );
      await _firestore.collection(_collection).doc(id).set(t.toMap());
      _nameController.clear();
      _roleTFController.clear();
      _companyController.clear();
      _feedbackController.clear();
      setState(() {
        _avatarBytes = null;
        _avatarBase64 = null;
      });
      await _loadTestimonials();
      setState(() {
        _testimonialSubmitted = true;
        _currentTestimonialPage = 0;
      });
      if (_testimonialPageController.hasClients) {
        _testimonialPageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _testimonialSubmitted = false);
      });
    } catch (e) {
      debugPrint('Error submitting: $e');
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    _floatingController.dispose();
    _rotationController.dispose();
    _scrollController.dispose();
    _testimonialPageController.dispose();
    _nameController.dispose();
    _roleTFController.dispose();
    _companyController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _scrollToSection(double offset) => _scrollController.animateTo(
    offset,
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeInOutCubic,
  );

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openProjectRepo(String repoUrl) async {
    final Uri uri = Uri.parse(repoUrl);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openGmail() {
    const email = 'phyowalkyawdeveloper@gmail.com';
    const subject = 'Portfolio Contact - Flutter Developer Opportunity';
    const body =
        'Hello Phyo Wai Kyaw,\n\nI came across your portfolio and would like to connect with you.\n\nBest regards,';
    _launchURL(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
  }

  void _downloadCV() =>
      _launchURL('https://drive.google.com/your-cv-link-here');

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(isMobile),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildStatsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildProfileSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildSkillsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildProductionAppsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildProjectsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildExperienceSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildEducationSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                // Community section removed
                _buildAwardsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildTestimonialsSection(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildContactSection(isMobile),
                _buildFooter(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return PreferredSize(
      preferredSize: Size.fromHeight(isMobile ? 60 : 70),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _showAppBar
              ? const Color(0xFF0A0E27).withOpacity(0.95)
              : Colors.transparent,
          boxShadow: _showAppBar
              ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20)]
              : [],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        key: ValueKey(_typingIndex),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            _typingAvatars[_typingIndex],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          opacity: _typingOpacity,
                          duration: const Duration(milliseconds: 350),
                          child: Text(
                            _typedText,
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _cursorVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                            '_',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!isMobile)
                  Row(
                    children: [
                      _buildNavButton('~/', 50),
                      _buildNavButton('Profile', 950),
                      _buildNavButton('Skills', 1800),
                      _buildNavButton('Apps', 2600),
                      _buildNavButton('Projects', 3600),
                      _buildNavButton('Experience', 6000),
                      _buildNavButton('Awards', 7800),
                      _buildNavButton('Testimonials', 8500),
                      _buildNavButton('Contact', 9600),
                    ],
                  )
                else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    color: const Color(0xFF0F172A),
                    onSelected: (value) {
                      setState(() => _activeNav = value);
                      final offsets = {
                        '~/': 0.0,
                        'Profile': 850.0,
                        'Skills': 1900.0,
                        'Apps': 3200.0,
                        'Projects': 4400.0,
                        'Experience': 7000.0,
                        'Awards': 9000.0,
                        'Testimonials': 9500.0,
                        'Contact': 10800.0,
                      };
                      _scrollToSection(offsets[value] ?? 0);
                    },
                    itemBuilder: (ctx) =>
                        [
                              '~/',
                              'Profile',
                              'Skills',
                              'Apps',
                              'Projects',
                              'Experience',
                              'Awards',
                              'Testimonials',
                              'Contact',
                            ]
                            .map(
                              (e) => PopupMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String label, double offset) {
    final isActive = _activeNav == label;
    return GestureDetector(
      onTap: () => _scrollToSection(offset),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? const Color(0xFF3B82F6).withOpacity(0.15)
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? const Color(0xFF3B82F6).withOpacity(0.6)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF3B82F6) : Colors.white70,
            fontSize: label == '~/' ? 16 : 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontFamily: label == '~/' ? 'monospace' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) => Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Transform.rotate(
              angle: _rotationController.value * 2 * math.pi,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1E40AF).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Transform.rotate(
              angle: -_rotationController.value * 2 * math.pi,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return SizedBox(
      height: isMobile ? 750 : 850,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (ctx, child) => Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(_floatingController.value * math.pi) * 20,
                      ),
                      child: child,
                    ),
                    child: Container(
                      width: isMobile ? 170 : 210,
                      height: isMobile ? 170 : 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF3B82F6),
                            Color(0xFF06B6D4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.3),
                            blurRadius: 60,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0A0E27),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/phyo.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.person,
                                  size: isMobile ? 60 : 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 30 : 50),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (ctx, double value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ).createShader(bounds),
                          child: Text(
                            'PHYO WAI KYAW',
                            style: TextStyle(
                              fontSize: isMobile ? 32 : 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          ).createShader(bounds),
                          child: Text(
                            'Flutter Developer',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 26,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                          'Building Mobile Apps with Passion & Purpose',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _heroBadgeLocation(isMobile),
                            _heroBadgeGreen(isMobile),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 30 : 40),
                  _buildSocialLinks(isMobile),
                  SizedBox(height: isMobile ? 20 : 30),
                  _buildCTAButtons(isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBadgeLocation(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFA78BFA), size: 15),
          const SizedBox(width: 6),
          Text(
            'Chonburi, Thailand | From Myanmar',
            style: TextStyle(
              color: const Color(0xFFA78BFA),
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBadgeGreen(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Available for opportunities',
            style: TextStyle(
              color: Colors.green,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 32,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E40AF).withOpacity(0.15),
            const Color(0xFF3B82F6).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('1+', 'Year\nExperience', isMobile),
          _buildStatDivider(),
          _buildStatItem('6+', 'Projects\nBuilt', isMobile),
          _buildStatDivider(),
          _buildStatItem('1', 'Hackathon\nWin', isMobile),
          _buildStatDivider(),
          _buildStatItem('4+', 'Production\nApps', isMobile),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          ).createShader(bounds),
          child: Text(
            number,
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 11 : 13,
            color: Colors.white54,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() =>
      Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1));

  Widget _buildSocialLinks(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          FontAwesomeIcons.github,
          'https://github.com/phyowaikyaw-mobiledev',
          isMobile,
        ),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIcon(
          FontAwesomeIcons.linkedin,
          'https://www.linkedin.com/in/phyowaikyaw-dev',
          isMobile,
        ),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIcon(
          FontAwesomeIcons.facebook,
          'https://facebook.com/learnersgateway30',
          isMobile,
        ),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIconEmail(isMobile),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, bool isMobile) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: () => _launchURL(url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isMobile ? 11 : 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: hovered
                    ? const Color(0xFF3B82F6).withOpacity(0.2)
                    : const Color(0xFF1E40AF).withOpacity(0.2),
                border: Border.all(
                  color: hovered
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF3B82F6).withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.35),
                          blurRadius: 14,
                        ),
                      ]
                    : [],
              ),
              child: FaIcon(
                icon,
                color: hovered
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF60A5FA),
                size: isMobile ? 18 : 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialIconEmail(bool isMobile) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: _openGmail,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isMobile ? 11 : 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: hovered
                    ? const Color(0xFF3B82F6).withOpacity(0.2)
                    : const Color(0xFF1E40AF).withOpacity(0.2),
                border: Border.all(
                  color: hovered
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF3B82F6).withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.35),
                          blurRadius: 14,
                        ),
                      ]
                    : [],
              ),
              child: FaIcon(
                FontAwesomeIcons.envelope,
                color: hovered
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF60A5FA),
                size: isMobile ? 18 : 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTAButtons(bool isMobile) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isMobile ? 12 : 16,
      runSpacing: 12,
      children: [
        _hoverButton(
          label: 'Hire Me',
          icon: Icons.mail_outline,
          isMobile: isMobile,
          filled: true,
          onTap: () => _scrollToSection(isMobile ? 10800 : 9600),
        ),
        _hoverButton(
          label: 'View Projects',
          icon: Icons.folder_open_outlined,
          isMobile: isMobile,
          filled: false,
          onTap: () => _scrollToSection(isMobile ? 4400 : 3600),
        ),
        _hoverButton(
          label: 'Download CV',
          icon: Icons.download_outlined,
          isMobile: isMobile,
          filled: false,
          accent: true,
          onTap: _downloadCV,
        ),
      ],
    );
  }

  Widget _hoverButton({
    required String label,
    required IconData icon,
    required bool isMobile,
    required bool filled,
    required VoidCallback onTap,
    bool accent = false,
  }) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 28,
                vertical: isMobile ? 12 : 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: filled
                    ? (hovered
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF3B82F6))
                    : (hovered
                          ? (accent
                                ? const Color(0xFF3B82F6).withOpacity(0.15)
                                : Colors.white.withOpacity(0.1))
                          : Colors.transparent),
                border: filled
                    ? null
                    : Border.all(
                        color: accent
                            ? const Color(0xFF3B82F6)
                            : (hovered ? Colors.white : Colors.white70),
                        width: 1.5,
                      ),
                boxShadow: hovered && filled
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: filled
                        ? Colors.white
                        : (accent ? const Color(0xFF3B82F6) : Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.w600,
                      color: filled
                          ? Colors.white
                          : (accent ? const Color(0xFF3B82F6) : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Profile', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              if (isMobile) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello! I'm Phyo Wai Kyaw",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _bioText(14),
                      const SizedBox(height: 16),
                      _bio2Text(14),
                      const SizedBox(height: 20),
                      _buildTechStack(isMobile),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  'Current Focus',
                  Icons.code,
                  _currentFocusPoints,
                  isMobile,
                ),
                const SizedBox(height: 15),
                _buildInfoCard(
                  'Career Goal',
                  Icons.flag,
                  _careerGoalPoints,
                  isMobile,
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello! I'm Phyo Wai Kyaw",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _bioText(16),
                            const SizedBox(height: 20),
                            _bio2Text(16),
                            const SizedBox(height: 30),
                            _buildTechStack(isMobile),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildInfoCard(
                            'Current Focus',
                            Icons.code,
                            _currentFocusPoints,
                            isMobile,
                          ),
                          const SizedBox(height: 15),
                          _buildInfoCard(
                            'Career Goal',
                            Icons.flag,
                            _careerGoalPoints,
                            isMobile,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _bioText(double size) => Text(
    'Flutter Developer with 1+ year of production experience, building cross-platform mobile applications that ship to real users on Google Play & App Store. Proficient in Flutter, Dart, Firebase, REST APIs, and modern state management — writing clean, scalable code in Agile environments.',
    style: TextStyle(
      fontSize: size,
      color: Colors.white.withOpacity(0.9),
      height: 1.6,
    ),
  );

  Widget _bio2Text(double size) => Text(
    'Experienced in remote collaboration with distributed teams, delivering features independently while maintaining clear communication. Proven problem-solver — 1st Runner Up at Oway Travel Hackathon 2020 — and active tech community builder. Open to remote opportunities worldwide.',
    style: TextStyle(
      fontSize: size,
      color: Colors.white.withOpacity(0.9),
      height: 1.6,
    ),
  );

  final List<String> _currentFocusPoints = [
    'Building production apps at Root Studio Asia',
    'REST API integration with Dio & Clean Architecture',
    'Localization (flutter_gen-l10n)',
    'Code reviews & Agile team workflow',
  ];
  final List<String> _careerGoalPoints = [
    'Contributing to meaningful Flutter projects',
    'Continuous learning and professional growth',
    'Building scalable production-ready apps',
    'Team collaboration and knowledge sharing',
  ];

  Widget _buildTechStack(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tech Stack:',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                    'Flutter',
                    'Dart',
                    'Firebase',
                    'GetX',
                    'BLoC',
                    'Provider',
                    'Dio',
                    'REST API',
                    'Hive',
                    'SQLite',
                    'Git',
                    'Postman',
                  ]
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF3B82F6)),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    List<String> points,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    final skills = [
      [
        'Mobile Development',
        Icons.phone_android,
        [
          'Flutter',
          'Dart',
          'Material Design',
          'Cupertino Widgets',
          'Responsive UI',
        ],
        const Color(0xFF1E40AF),
        const Color(0xFF3B82F6),
      ],
      [
        'State Management',
        Icons.settings,
        ['GetX', 'BLoC', 'Provider', 'Riverpod (Learning)'],
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ],
      [
        'Backend & Integration',
        Icons.cloud,
        ['Firebase', 'REST API', 'Dio', 'Retrofit', 'JSON Parsing', 'Postman'],
        const Color(0xFF1E40AF),
        const Color(0xFF3B82F6),
      ],
      [
        'Database & Storage',
        Icons.storage,
        ['Firestore', 'Hive', 'SQLite', 'Realm DB', 'Local Storage'],
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ],
      [
        'Development Tools',
        Icons.build,
        ['Git', 'GitHub', 'Android Studio', 'VS Code', 'Flutter DevTools'],
        const Color(0xFF1E40AF),
        const Color(0xFF3B82F6),
      ],
      [
        'Architecture & Patterns',
        Icons.architecture,
        [
          'MVC',
          'Clean Architecture',
          'Repository Pattern',
          'Navigation & Routing',
        ],
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ],
      [
        'AI-Augmented Dev',
        Icons.auto_awesome,
        ['Claude AI', 'Cursor', 'AI Code Review', 'AI Architecture'],
        const Color(0xFF6366F1),
        const Color(0xFF8B5CF6),
      ],
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 50,
        horizontal: isMobile ? 16 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              _buildSectionTitle('Technical Skills', isMobile),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                'Technologies I work with every day',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
              SizedBox(height: isMobile ? 20 : 30),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: isMobile ? 170 : 195,
                ),
                itemCount: skills.length,
                itemBuilder: (ctx, i) => _buildSkillCard(
                  skills[i][0] as String,
                  skills[i][1] as IconData,
                  skills[i][2] as List<String>,
                  skills[i][3] as Color,
                  skills[i][4] as Color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCard(
    String title,
    IconData icon,
    List<String> tags,
    Color primary,
    Color secondary,
  ) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: hovered
                    ? [primary.withOpacity(0.2), secondary.withOpacity(0.12)]
                    : [primary.withOpacity(0.1), secondary.withOpacity(0.05)],
              ),
              border: Border.all(
                color: hovered
                    ? primary.withOpacity(0.6)
                    : primary.withOpacity(0.2),
                width: hovered ? 1.5 : 1,
              ),
              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: primary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, secondary]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: hovered
                        ? [
                            BoxShadow(
                              color: primary.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: tags
                            .map((t) => _skillTag(t, primary, hovered))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _skillTag(String label, Color primary, bool parentHovered) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hovered
                  ? primary.withOpacity(0.35)
                  : primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hovered ? primary : primary.withOpacity(0.4),
                width: hovered ? 1.5 : 1,
              ),
              boxShadow: hovered
                  ? [BoxShadow(color: primary.withOpacity(0.3), blurRadius: 8)]
                  : [],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: hovered ? Colors.white : Colors.white.withOpacity(0.85),
                fontWeight: hovered ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductionAppsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Production Apps', isMobile),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                'Live applications shipped to real users on Google Play & App Store',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(height: isMobile ? 28 : 40),
              _buildAppCategoryLabel(
                'Published & Live',
                Colors.green,
                isMobile,
              ),
              const SizedBox(height: 16),
              _twoColOrStack(isMobile, [
                _buildProductionAppCard(
                  title: 'Phone King Plus — Customer',
                  description:
                      'Loyalty rewards platform — earn points, track rewards & redeem exclusive offers.',
                  iconAsset: 'assets/images/phoneking_icon.png',
                  icon: Icons.phone_android,
                  role: 'Core Developer',
                  statusColor: Colors.green,
                  tags: ['Flutter', 'REST API', 'Material Design'],
                  playUrl:
                      'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_customer',
                  appStoreUrl:
                      'https://apps.apple.com/th/app/phoneking-plus/id6757488887',
                  galleryImages: [
                    'assets/images/pk_1.png',
                    'assets/images/pk_2.png',
                    'assets/images/pk_3.png',
                    'assets/images/pk_4.png',
                    'assets/images/pk_5.png',
                  ],
                  isMobile: isMobile,
                ),
                _buildProductionAppCard(
                  title: 'Phone King Plus — Admin',
                  description:
                      'Admin panel for managing the loyalty platform — stores, rewards & users.',
                  iconAsset: 'assets/images/phoneking_admin_icon.png',
                  icon: Icons.admin_panel_settings,
                  role: 'Core Developer',
                  statusColor: Colors.green,
                  tags: ['Flutter', 'REST API', 'Material Design'],
                  playUrl:
                      'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_admin',
                  appStoreUrl:
                      'https://apps.apple.com/th/app/phoneking-plus-admin/id6757606298',
                  galleryImages: [
                    'assets/images/pka_1.png',
                    'assets/images/pka_2.png',
                    'assets/images/pka_3.png',
                    'assets/images/pka_4.png',
                    'assets/images/pka_5.png',
                  ],
                  isMobile: isMobile,
                ),
              ]),
              SizedBox(height: isMobile ? 28 : 36),
              _buildAppCategoryLabel('Launching Soon', Colors.orange, isMobile),
              const SizedBox(height: 16),
              _twoColOrStack(isMobile, [
                _buildProductionAppCard(
                  title: 'DrZon Healthcare',
                  description:
                      'Healthcare app connecting patients with medical services in Myanmar & Thailand.',
                  iconAsset: 'assets/images/drzon_icon.png',
                  icon: Icons.local_hospital,
                  role: 'Core Developer',
                  statusColor: Colors.orange,
                  tags: ['Flutter', 'Dio', 'Clean Architecture', 'l10n'],
                  galleryImages: [
                    'assets/images/drzon_1.jpeg',
                    'assets/images/drzon_2.jpeg',
                    'assets/images/drzon_3.jpeg',
                  ],
                  isMobile: isMobile,
                ),
                _buildProductionAppCard(
                  title: 'Pan Customer App',
                  description:
                      'Cross-platform production shopping application built with layered architecture for scalability and maintainability.',
                  iconAsset: 'assets/images/pan_icon.png',
                  icon: Icons.shopping_bag,
                  role: 'Core Developer',
                  statusColor: Colors.orange,
                  tags: ['Flutter', 'REST API', 'Layered Architecture'],
                  galleryImages: [
                    'assets/images/pan_1.jpeg',
                    'assets/images/pan_2.jpeg',
                    'assets/images/pan_3.jpeg',
                  ],
                  isMobile: isMobile,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _twoColOrStack(bool isMobile, List<Widget> children) {
    if (isMobile)
      return Column(
        children: [children[0], const SizedBox(height: 16), children[1]],
      );
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 20),
          Expanded(child: children[1]),
        ],
      ),
    );
  }

  Widget _buildAppCategoryLabel(String label, Color color, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: color.withOpacity(0.2))),
      ],
    );
  }

  Widget _buildProductionAppCard({
    required String title,
    required String description,
    required IconData icon,
    String? iconAsset,
    required String role,
    required Color statusColor,
    required List<String> tags,
    required bool isMobile,
    String? playUrl,
    String? appStoreUrl,
    List<String> galleryImages = const [],
  }) {
    final isLive = playUrl != null;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: Colors.white, size: 26),
                        ),
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: Colors.white, size: 26),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _statusBadge(
                          isLive ? 'Live' : 'Launching Soon',
                          statusColor,
                        ),
                        const SizedBox(width: 8),
                        _statusBadge(role, const Color(0xFF3B82F6)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: Colors.white.withOpacity(0.75),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((tag) => _techTag(tag, isMobile)).toList(),
          ),
          if (galleryImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 3,
                  height: 13,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: isMobile ? 120 : 145,
              child: ScrollConfiguration(
                behavior: _DragScrollBehavior(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: galleryImages.length,
                  itemBuilder: (ctx, i) => _buildGalleryItem(
                    galleryImages[i],
                    isMobile,
                    onTap: () => _showCarouselDialog(galleryImages, i),
                  ),
                ),
              ),
            ),
          ],
          if (isLive) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (playUrl != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchURL(playUrl),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text(
                        'Play Store',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                if (playUrl != null && appStoreUrl != null)
                  const SizedBox(width: 10),
                if (appStoreUrl != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchURL(appStoreUrl),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF60A5FA),
                        side: const BorderSide(color: Color(0xFF3B82F6)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.apple, size: 16),
                      label: const Text(
                        'App Store',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.6), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _techTag(String tag, bool isMobile) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hovered
                  ? const Color(0xFF3B82F6).withOpacity(0.3)
                  : const Color(0xFF1E40AF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hovered
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF3B82F6).withOpacity(0.5),
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                color: Colors.white,
                fontWeight: hovered ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════
  // PROJECTS SECTION — consistent layout, maxLines 2
  // ═══════════════════════════════════════

  Widget _buildProjectsSection(bool isMobile) {
    final projects = [
      {
        'title': 'E-Commerce App',
        'subtitle': 'Full-featured Shopping Platform',
        'image': 'assets/images/e_commerce_shopping.jpeg',
        'desc':
            'Shopping platform with product catalog, cart, Firebase Auth, Firestore & MVC architecture.',
        'tags': ['Flutter', 'Dart', 'Firebase', 'REST API'],
        'liveUrl': null,
        'github': 'https://github.com/phyowaikyaw-mobiledev/e_commerce',
        'icon': Icons.shopping_cart,
        'status': 'Individual Project',
        'statusColor': Colors.orange,
        'gallery': [
          'assets/images/ecommerce_1.png',
          'assets/images/ecommerce_2.png',
          'assets/images/ecommerce_3.png',
        ],
      },
      {
        'title': 'Learners Gateway',
        'subtitle': 'Live Production Blog Platform',
        'image': 'assets/images/learners_gateway.jpeg',
        'desc':
            'Blog platform with Flutter Web & Firebase — real-time content, auth, comments & responsive design.',
        'tags': ['Flutter Web', 'Firebase', 'Provider', 'go_router'],
        'liveUrl': 'https://learners-gateway.web.app',
        'github':
            'https://github.com/phyowaikyaw-mobiledev/learners_gateway_website',
        'icon': Icons.web,
        'status': 'Live',
        'statusColor': Colors.green,
        'gallery': [
          'assets/images/learners_1.jpeg',
          'assets/images/learners_2.jpeg',
          'assets/images/learners_3.jpeg',
        ],
      },
      {
        'title': 'EduHub LMS',
        'subtitle': 'Learning Management System',
        'image': 'assets/images/lms.jpeg',
        'desc':
            'LMS with dual-role (Student & Teacher), course management, assignments & offline Hive storage.',
        'tags': ['Flutter', 'Firebase', 'BLoC', 'Hive'],
        'liveUrl': null,
        'github': 'https://github.com/phyowaikyaw-mobiledev/eduhub_lms',
        'icon': Icons.school,
        'status': 'Individual Project',
        'statusColor': Colors.orange,
        'gallery': [
          'assets/images/lms_1.jpeg',
          'assets/images/lms_2.jpeg',
          'assets/images/lms_3.jpeg',
        ],
      },
      {
        'title': 'Pardon Diary',
        'subtitle': 'Feature-rich Note App',
        'image': 'assets/images/note_app.jpeg',
        'desc':
            'Google Keep-inspired note app with Realm DB, CRUD, staggered grid & full-text search.',
        'tags': ['Flutter', 'Realm DB', 'Streams', 'Material 3'],
        'liveUrl': null,
        'github': 'https://github.com/phyowaikyaw-mobiledev/pardon_diary-note',
        'icon': Icons.note_alt,
        'status': 'Individual Project',
        'statusColor': Colors.orange,
        'gallery': [
          'assets/images/note_1.png',
          'assets/images/note_2.png',
          'assets/images/note_3.png',
          'assets/images/note_4.png',
        ],
      },
      {
        'title': 'Ying Music',
        'subtitle': 'Music Streaming App UI',
        'image': 'assets/images/music_app.jpeg',
        'desc':
            'Modern music streaming UI with gradient design, hero animations & playback controls.',
        'tags': ['Flutter', 'Material 3', 'Animations'],
        'liveUrl': null,
        'github': 'https://github.com/phyowaikyaw-mobiledev/music_app',
        'icon': Icons.music_note,
        'status': 'Individual Project',
        'statusColor': Colors.orange,
        'gallery': [
          'assets/images/music_1.png',
          'assets/images/music_2.png',
          'assets/images/music_3.png',
          'assets/images/music_4.png',
        ],
      },
      {
        'title': 'SocialHub',
        'subtitle': 'Social Media UI Clone',
        'image': 'assets/images/social_app.jpeg',
        'desc':
            'Facebook-inspired app with news feed, interactive posts, notifications & smooth navigation.',
        'tags': ['Flutter', 'Material Design', 'Complex UI'],
        'liveUrl': null,
        'github':
            'https://github.com/phyowaikyaw-mobiledev/social_media_ui_clone',
        'icon': Icons.people,
        'status': 'Individual Project',
        'statusColor': Colors.orange,
        'gallery': [
          'assets/images/social_1.png',
          'assets/images/social_2.png',
          'assets/images/social_3.png',
          'assets/images/social_4.png',
          'assets/images/social_5.png',
        ],
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 50,
        horizontal: isMobile ? 16 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Personal Projects', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              isMobile
                  ? Column(
                      children: projects
                          .map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildProjectCard2(p, isMobile),
                            ),
                          )
                          .toList(),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 390,
                          ),
                      itemCount: projects.length,
                      itemBuilder: (ctx, i) =>
                          _buildProjectCard2(projects[i], isMobile),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard2(Map<String, dynamic> p, bool isMobile) {
    final color = p['statusColor'] as Color;
    final gallery = p['gallery'] as List<String>;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  p['image'] as String,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      p['icon'] as IconData,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.6)),
                      ),
                      child: Text(
                        p['status'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      p['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Description — fixed 2 lines with empty line if short ──
          SizedBox(
            height: 42, // fixed height = 2 lines × ~21px
            child: Text(
              p['desc'] as String,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.72),
                height: 1.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),

          // ── Tags — fixed 1 row ──
          SizedBox(
            height: 28,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (p['tags'] as List<String>).length,
              itemBuilder: (ctx, i) {
                final tag = (p['tags'] as List<String>)[i];
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // ── Gallery — always same height ──
          if (gallery.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 3,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 80,
              child: ScrollConfiguration(
                behavior: _DragScrollBehavior(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: gallery.length,
                  itemBuilder: (ctx, i) => GestureDetector(
                    onTap: () => _showCarouselDialog(gallery, i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          gallery[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1E40AF).withOpacity(0.3),
                            child: const Icon(
                              Icons.image_outlined,
                              color: Colors.white38,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else
            const SizedBox(height: 97), // consistent placeholder height
          const SizedBox(height: 12),

          // ── Buttons — always at bottom ──
          Row(
            children: [
              if (p['liveUrl'] != null) ...[
                Expanded(
                  child: _smallButton(
                    'Live Demo',
                    Icons.launch,
                    const Color(0xFF3B82F6),
                    true,
                    () => _launchURL(p['liveUrl'] as String),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: _smallButton(
                  'View Code',
                  FontAwesomeIcons.github,
                  Colors.white70,
                  false,
                  () => _openProjectRepo(p['github'] as String),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallButton(
    String label,
    IconData icon,
    Color color,
    bool filled,
    VoidCallback onTap,
  ) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: filled
                    ? (hovered
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF3B82F6))
                    : (hovered
                          ? Colors.white.withOpacity(0.08)
                          : Colors.transparent),
                border: filled
                    ? null
                    : Border.all(
                        color: hovered
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                boxShadow: filled && hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon == FontAwesomeIcons.github
                      ? FaIcon(
                          icon,
                          size: 14,
                          color: filled ? Colors.white : color,
                        )
                      : Icon(
                          icon,
                          size: 14,
                          color: filled ? Colors.white : color,
                        ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: filled ? Colors.white : color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGalleryItem(
    String imagePath,
    bool isMobile, {
    VoidCallback? onTap,
  }) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: onTap ?? () => _showCarouselDialog([imagePath], 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              width: isMobile ? 110 : 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hovered
                      ? const Color(0xFF3B82F6)
                      : Colors.white.withOpacity(0.2),
                  width: hovered ? 1.5 : 1,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1E40AF).withOpacity(0.3),
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.white38,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (hovered)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        color: Colors.black.withOpacity(0.35),
                        child: const Center(
                          child: Icon(
                            Icons.zoom_in_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCarouselDialog(List<String> images, int startIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (ctx) =>
          _CarouselDialog(images: images, initialIndex: startIndex),
    );
  }

  Widget _buildExperienceSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Professional Experience', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              _buildExpCard(
                title: 'Junior Flutter Developer',
                company: 'Root Studio Asia — Yangon, Myanmar (Remote)',
                period: 'Jan 2026 – Present',
                points: [
                  'Building production-grade mobile applications used by real users',
                  'Developing and maintaining notification system with REST API integration using Dio',
                  'Implementing clean architecture with repository pattern and l10n localization',
                  'Collaborating in code reviews with senior developer following Agile workflow',
                  'Integrating Firebase services and managing app state with modern solutions',
                  'Writing clean, well-documented, maintainable Dart/Flutter code',
                ],
                tags: [
                  'Flutter',
                  'Dart',
                  'Dio',
                  'REST API',
                  'Firebase',
                  'Clean Architecture',
                  'l10n',
                  'Git',
                ],
                icon: Icons.work,
                companyLogoAsset: 'assets/images/rootstudio_logo.jpg',
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 15 : 20),
              _buildExpCard(
                title: 'Junior Flutter Developer (Mentorship)',
                company: 'Intensive Mentorship Program',
                period: '2024 – 2025',
                points: [
                  'Built production-ready applications using Flutter, Dart, and Firebase under senior guidance',
                  'Implemented state management solutions (GetX, BLoC, Provider)',
                  'Participated in regular code reviews with senior developer',
                  'Developed e-commerce application with full feature set',
                  'Focused on Clean Architecture and enterprise-level standards',
                  'Worked with REST APIs and Firebase services integration',
                ],
                tags: [
                  'Flutter',
                  'Dart',
                  'Firebase',
                  'GetX',
                  'BLoC',
                  'Clean Architecture',
                  'REST API',
                ],
                icon: Icons.school,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpCard({
    required String title,
    required String company,
    required String period,
    required List<String> points,
    required List<String> tags,
    required IconData icon,
    required bool isMobile,
    String? companyLogoAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: companyLogoAsset != null
                    ? Image.asset(
                        companyLogoAsset,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: Colors.white, size: 26),
                        ),
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 26),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 15,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3B82F6)),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((t) => _techTag(t, isMobile)).toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // EDUCATION SECTION — redesigned
  // ═══════════════════════════════════════

  Widget _buildEducationSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 50,
        horizontal: isMobile ? 16 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Education & Certifications', isMobile),
              SizedBox(height: isMobile ? 6 : 10),
              Text(
                'Academic background and professional credentials',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 15,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(height: isMobile ? 20 : 32),
              isMobile
                  ? Column(
                      children: [
                        _buildComputerUniversityCard(isMobile),
                        const SizedBox(height: 20),
                        _buildKMDCard(isMobile),
                        const SizedBox(height: 20),
                        _buildWebDevCard(isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildComputerUniversityCard(isMobile)),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildKMDCard(isMobile)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildWebDevCard(isMobile)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Computer University Card ──
  Widget _buildComputerUniversityCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1530),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A6E).withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/computer_university.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF3B82F6),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Computer University',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Computer Science Major',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                '2018 – 2021',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.5),
              ),
            ),
            child: const Text(
              '2nd Year Completed',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Updated note: COVID & political situation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 13,
                  color: Colors.orange.withOpacity(0.8),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Studies paused due to COVID-19 and Myanmar\'s political situation.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0xFF1E3A6E).withOpacity(0.5)),
          const SizedBox(height: 14),
          ...[
            'Data Structures & Algorithms',
            'Database Management Systems',
            'Software Engineering Principles',
            'Object-Oriented Programming',
            'Computer Architecture',
            'Web Development Foundations',
          ].map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── KMD Card with 5 certificate cards in 2-column grid ──
  Widget _buildKMDCard(bool isMobile) {
    final certs = [
      {
        'title': 'Software Engineering — VB.Net',
        'image': 'assets/images/cert_se.jpg',
        'icon': Icons.code,
      },
      {
        'title': 'Problem Solving with Programming',
        'image': 'assets/images/cert_ps.jpg',
        'icon': Icons.psychology,
      },
      {
        'title': 'Practical A+ Hardware & Networking',
        'image': 'assets/images/cert_hw.jpg',
        'icon': Icons.computer,
      },
      {
        'title': 'Microsoft PowerPoint Advanced',
        'image': 'assets/images/cert_ppt.jpg',
        'icon': Icons.slideshow,
      },
      {
        'title': 'Computer Basic',
        'image': 'assets/images/cert_basic.jpg',
        'icon': Icons.desktop_windows,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1530),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A6E).withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/kmd_logo.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF3B82F6),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'KMD Education Center',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Technical Certifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                'Multiple Dates',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.5),
              ),
            ),
            child: const Text(
              '5 Certificates',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: const Color(0xFF1E3A6E).withOpacity(0.5)),
          const SizedBox(height: 16),
          // 2-column certificate grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 170,
            ),
            itemCount: certs.length,
            itemBuilder: (ctx, i) {
              final allImages = certs.map((c) => c['image'] as String).toList();
              return _buildCertCard(
                title: certs[i]['title'] as String,
                imagePath: certs[i]['image'] as String,
                fallbackIcon: certs[i]['icon'] as IconData,
                onTap: () => _showCarouselDialog(allImages, i),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Individual Certificate Card ──
  Widget _buildCertCard({
    required String title,
    required String imagePath,
    required IconData fallbackIcon,
    VoidCallback? onTap,
  }) {
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1A35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hovered
                      ? const Color(0xFF3B82F6).withOpacity(0.7)
                      : const Color(0xFF1E3A6E).withOpacity(0.8),
                  width: hovered ? 1.5 : 1,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.25),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Certificate image with zoom overlay on hover
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(11),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF1E40AF).withOpacity(0.2),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: const Color(
                                        0xFFFFD700,
                                      ).withOpacity(0.6),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Certificate',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (hovered)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: Icon(
                                  Icons.zoom_in_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Title
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A1020),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(11),
                      ),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Web Development Foundation Card ──
  Widget _buildWebDevCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1530),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A6E).withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/computer_university.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF3B82F6),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'University of Computer, Mandalay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Web Development Foundation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                'Certified',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: const Text(
              'Certified',
              style: TextStyle(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0xFF1E3A6E).withOpacity(0.5)),
          const SizedBox(height: 14),
          // Subjects
          ...[
            'HTML & CSS',
            'Bootstrap Framework',
            'JavaScript Fundamentals',
            'Responsive Web Design',
          ].map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Certificate image placeholder
          GestureDetector(
            onTap: () =>
                _showCarouselDialog(['assets/images/cert_webdev.jpg'], 0),
            child: StatefulBuilder(
              builder: (ctx, ss) {
                bool hovered = false;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => ss(() => hovered = true),
                  onExit: (_) => ss(() => hovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: hovered
                            ? const Color(0xFF3B82F6).withOpacity(0.7)
                            : Colors.green.withOpacity(0.3),
                        width: hovered ? 1.5 : 1,
                      ),
                      boxShadow: hovered
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withOpacity(0.25),
                                blurRadius: 12,
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/cert_webdev.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF0A1020),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    color: Colors.green.withOpacity(0.5),
                                    size: 36,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Certificate',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (hovered)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: Icon(
                                  Icons.zoom_in_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // AWARDS SECTION
  // ═══════════════════════════════════════

  Widget _buildAwardsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 50,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Awards & Achievements', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              _buildAwardCard(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwardCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withOpacity(0.1),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: isMobile ? 32 : 48,
                ),
              ),
              SizedBox(width: isMobile ? 16 : 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1st Runner Up',
                      style: TextStyle(
                        fontSize: isMobile ? 22 : 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Oway Travel Hackathon 2020 — Mandalay',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Organized by Phandeeyar Foundation | Myanmar',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 24 : 32),
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: const Color(0xFFFFD700),
                      size: isMobile ? 20 : 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '\$1,000 AWS Cloud Credits',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _awardDetail(
                  'Achievement',
                  '1st Runner Up among 20+ competing teams',
                  isMobile,
                ),
                _awardDetail(
                  'Project',
                  'Developed functional travel application prototype under strict time constraints',
                  isMobile,
                ),
                _awardDetail(
                  'Skills Demonstrated',
                  'Teamwork, problem-solving, rapid prototyping, and presentation skills',
                  isMobile,
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),
          Text(
            'Hackathon Memories',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFD700),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          isMobile
              ? Column(
                  children: [
                    _hackathonImage(
                      'assets/images/hackathon_award.jpg',
                      'Award Ceremony',
                      isMobile,
                    ),
                    const SizedBox(height: 16),
                    _hackathonImage(
                      'assets/images/hackathon_team.jpg',
                      'Team Heaven',
                      isMobile,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _hackathonImage(
                        'assets/images/hackathon_award.jpg',
                        'Award Ceremony',
                        isMobile,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _hackathonImage(
                        'assets/images/hackathon_team.jpg',
                        'Team Heaven',
                        isMobile,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _hackathonImage(String path, String caption, bool isMobile) {
    return Column(
      children: [
        Container(
          height: isMobile ? 200 : 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: isMobile ? 40 : 60,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: Colors.white.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _awardDetail(String label, String value, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: isMobile ? 6 : 7),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // TESTIMONIALS SECTION — multi-card visible slider
  // ═══════════════════════════════════════

  Widget _buildTestimonialsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: 0,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
            child: Column(
              children: [
                _buildSectionTitle('What People Say', isMobile),
                SizedBox(height: isMobile ? 6 : 10),
                Text(
                  "Kind words from colleagues and clients I've worked with.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 16,
                    color: Colors.white.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 24 : 36),
          if (_isLoadingTestimonials)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          else if (_testimonials.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
              child: _buildEmptyState(isMobile),
            )
          else ...[
            // ── Multi-card slider: uses shared _testimonialPageController ──
            SizedBox(
              height: isMobile ? 260 : 280,
              child: PageView.builder(
                controller: _testimonialPageController,
                itemCount: _testimonials.length,
                onPageChanged: (i) =>
                    setState(() => _currentTestimonialPage = i),
                itemBuilder: (ctx, i) {
                  final isActive = i == _currentTestimonialPage;
                  return AnimatedScale(
                    scale: isActive ? 1.0 : 0.93,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.6,
                      duration: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: _buildProCard(
                          t: _testimonials[i],
                          index: i,
                          isMobile: isMobile,
                          featured: isActive,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navArrow(Icons.chevron_left, () {
                  if (_currentTestimonialPage > 0) {
                    setState(() => _slideForward = false);
                    _testimonialPageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  }
                }),
                const SizedBox(width: 16),
                _buildSliderDots(),
                const SizedBox(width: 16),
                _navArrow(Icons.chevron_right, () {
                  if (_currentTestimonialPage < _testimonials.length - 1) {
                    setState(() => _slideForward = true);
                    _testimonialPageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  }
                }),
              ],
            ),
          ],
          SizedBox(height: isMobile ? 32 : 48),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _buildTestimonialForm(isMobile),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderDots() {
    final dotCount = _testimonials.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dotCount, (i) {
        final isActive = i == _currentTestimonialPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  )
                : null,
            color: isActive ? null : Colors.white.withOpacity(0.2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _navArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF3B82F6), size: 22),
      ),
    );
  }

  Widget _buildProCard({
    required TestimonialModel t,
    required int index,
    required bool isMobile,
    bool featured = false,
  }) {
    const previewLen = 180;
    final needsExpand = t.text.length > previewLen;
    return StatefulBuilder(
      builder: (ctx, ss) {
        bool hovered = false;
        return MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) => ss(() => hovered = true),
          onExit: (_) => ss(() => hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF0D1530),
              border: Border.all(
                color: featured
                    ? const Color(0xFF3B82F6).withOpacity(0.6)
                    : const Color(0xFF1E3A6E).withOpacity(0.5),
                width: featured ? 1.5 : 1,
              ),
              boxShadow: featured
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: t.avatarBase64 == null
                              ? LinearGradient(
                                  colors: [
                                    t.avatarColor,
                                    t.avatarColor.withOpacity(0.6),
                                  ],
                                )
                              : null,
                        ),
                        child: t.avatarBase64 != null
                            ? ClipOval(
                                child: Image.memory(
                                  base64Decode(t.avatarBase64!),
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                ),
                              )
                            : Center(
                                child: Text(
                                  t.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              t.role,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF60A5FA),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (t.company.isNotEmpty)
                              Text(
                                t.company,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF7C3AED)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.format_quote_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: const Color(0xFF1E3A6E).withOpacity(0.5),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    needsExpand
                        ? '${t.text.substring(0, previewLen)}...'
                        : t.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.78),
                      height: 1.6,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  if (needsExpand) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _showTestimonialDialog(t),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Read more',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF60A5FA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF60A5FA),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTestimonialDialog(TestimonialModel t) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1530),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.format_quote_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Text(
                    t.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.7,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Column(
                  children: [
                    Container(height: 1, color: const Color(0xFF1E3A6E)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: t.avatarBase64 == null
                                ? LinearGradient(
                                    colors: [
                                      t.avatarColor,
                                      t.avatarColor.withOpacity(0.6),
                                    ],
                                  )
                                : null,
                          ),
                          child: t.avatarBase64 != null
                              ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(t.avatarBase64!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    t.initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              t.role,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF60A5FA),
                              ),
                            ),
                            if (t.company.isNotEmpty)
                              Text(
                                t.company,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
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
            Colors.white.withOpacity(0.04),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
            ).createShader(b),
            child: const Icon(
              Icons.format_quote_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No testimonials yet.',
            style: TextStyle(
              fontSize: isMobile ? 17 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 28 : 44),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E40AF).withOpacity(0.12),
            const Color(0xFF0F172A).withOpacity(0.9),
            const Color(0xFF3B82F6).withOpacity(0.06),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
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
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
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
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Worked with me? I'd love to hear from you.",
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white.withOpacity(0.5),
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
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
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
                              color: Colors.white.withOpacity(0.6),
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
              'Optional profile photo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 28),
          isMobile
              ? Column(
                  children: [
                    _proTextField(
                      'Full Name *',
                      Icons.person_outline,
                      _nameController,
                      isMobile,
                    ),
                    const SizedBox(height: 16),
                    _proTextField(
                      'Job Title / Position',
                      Icons.work_outline,
                      _roleTFController,
                      isMobile,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _proTextField(
                        'Full Name *',
                        Icons.person_outline,
                        _nameController,
                        isMobile,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _proTextField(
                        'Job Title / Position',
                        Icons.work_outline,
                        _roleTFController,
                        isMobile,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          _proTextField(
            'Company / Organization',
            Icons.business_outlined,
            _companyController,
            isMobile,
          ),
          const SizedBox(height: 16),
          _proTextField(
            'Your Feedback *',
            Icons.chat_bubble_outline,
            _feedbackController,
            isMobile,
            maxLines: 5,
          ),
          if (_formError) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
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
              onPressed: _isSubmitting ? null : _submitTestimonial,
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
                  gradient: _isSubmitting
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isSubmitting
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: _isSubmitting
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
          if (_testimonialSubmitted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
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
                            color: Colors.green.withOpacity(0.7),
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
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(width: 5),
                Text(
                  'Your testimonial appears instantly after submitting.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proTextField(
    String hint,
    IconData icon,
    TextEditingController controller,
    bool isMobile, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14,
        ),
        prefixIcon: maxLines == 1
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  icon,
                  color: const Color(0xFF3B82F6).withOpacity(0.7),
                  size: 18,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
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

  // ═══════════════════════════════════════
  // CONTACT SECTION
  // ═══════════════════════════════════════

  Widget _buildContactSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 50 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0F172A),
            const Color(0xFF1E293B).withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.2),
                      const Color(0xFF8B5CF6).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  "💬 Let's Connect",
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: const Color(0xFF60A5FA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 15 : 20),
              _buildSectionTitle('Get In Touch', isMobile),
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                "Have a project in mind or want to collaborate?\nLet's create something amazing together!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bolt,
                    color: Colors.amber,
                    size: isMobile ? 16 : 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Usually responds within 24 hours',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: Colors.amber.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 30 : 40),
              isMobile
                  ? _buildMobileContactLayout()
                  : _buildDesktopContactLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContactLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildContactCard(
                Icons.email_outlined,
                'Email',
                'phyowalkyawdeveloper@gmail.com',
                'Drop me an email anytime',
                _openGmail,
                const Color(0xFF3B82F6),
                const Color(0xFF60A5FA),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      FontAwesomeIcons.github,
                      'GitHub',
                      'phyowaikyaw-mobiledev',
                      'Check out my projects',
                      () => _launchURL(
                        'https://github.com/phyowaikyaw-mobiledev',
                      ),
                      const Color(0xFF6366F1),
                      const Color(0xFF818CF8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildContactCard(
                      FontAwesomeIcons.linkedin,
                      'LinkedIn',
                      'phyowaikyaw-dev',
                      "Let's connect professionally",
                      () => _launchURL(
                        'https://www.linkedin.com/in/phyowaikyaw-dev',
                      ),
                      const Color(0xFF8B5CF6),
                      const Color(0xFFA78BFA),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildOpportunityCard(false)),
      ],
    );
  }

  Widget _buildMobileContactLayout() {
    return Column(
      children: [
        _buildContactCard(
          Icons.email_outlined,
          'Email',
          'phyowalkyawdeveloper@gmail.com',
          'Drop me an email anytime',
          _openGmail,
          const Color(0xFF3B82F6),
          const Color(0xFF60A5FA),
        ),
        const SizedBox(height: 15),
        _buildContactCard(
          FontAwesomeIcons.github,
          'GitHub',
          'phyowaikyaw-mobiledev',
          'Check out my projects',
          () => _launchURL('https://github.com/phyowaikyaw-mobiledev'),
          const Color(0xFF6366F1),
          const Color(0xFF818CF8),
        ),
        const SizedBox(height: 15),
        _buildContactCard(
          FontAwesomeIcons.linkedin,
          'LinkedIn',
          'phyowaikyaw-dev',
          "Let's connect professionally",
          () => _launchURL('https://www.linkedin.com/in/phyowaikyaw-dev'),
          const Color(0xFF8B5CF6),
          const Color(0xFFA78BFA),
        ),
        const SizedBox(height: 20),
        _buildOpportunityCard(true),
      ],
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    VoidCallback onTap,
    Color primary,
    Color secondary,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withOpacity(0.1), secondary.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primary, secondary]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: primary.withOpacity(0.6),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.15),
            const Color(0xFF8B5CF6).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.work_outline,
              color: Color(0xFF60A5FA),
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Open to Opportunities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Currently seeking exciting roles and projects where I can contribute and grow as a Flutter developer',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ...[
            '💼  Flutter Developer roles',
            '🌏  Remote work opportunities',
            '🚀  Freelance projects',
            '💻  Open-source contributions',
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openGmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Send Message',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Built with Flutter 💙 & Passion 🔥',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2026 Phyo Wai Kyaw. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
            const SizedBox(height: 20),
            _buildSocialLinks(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          ).createShader(bounds),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Container(
          width: isMobile ? 80 : 120,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
  );
}

class _DragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

class _CarouselDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _CarouselDialog({required this.images, required this.initialIndex});

  @override
  State<_CarouselDialog> createState() => _CarouselDialogState();
}

class _CarouselDialogState extends State<_CarouselDialog> {
  late int _current;
  late PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.92),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: PageView.builder(
                          controller: _ctrl,
                          itemCount: total,
                          onPageChanged: (i) => setState(() => _current = i),
                          itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                widget.images[i],
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          total,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _current ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: i == _current
                                  ? const Color(0xFF3B82F6)
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_current + 1} / $total',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              if (total > 1) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_current > 0)
                          _ctrl.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _current > 0
                              ? const Color(0xFF3B82F6).withOpacity(0.8)
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: _current > 0 ? Colors.white : Colors.white38,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_current < total - 1)
                          _ctrl.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _current < total - 1
                              ? const Color(0xFF3B82F6).withOpacity(0.8)
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: _current < total - 1
                              ? Colors.white
                              : Colors.white38,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    const spacing = 50.0;
    for (double i = 0; i < size.width; i += spacing)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += spacing)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
