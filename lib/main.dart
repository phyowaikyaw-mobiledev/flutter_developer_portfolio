import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

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

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({Key? key}) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scrollController.addListener(() {
      setState(() {
        _showAppBar = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openGmail() {
    final email = 'phyowaikyawdeveloper@gmail.com';
    final subject = 'Portfolio Contact - Flutter Developer Opportunity';
    final body = 'Hello Phyo Wai Kyaw,\n\nI came across your portfolio and would like to connect with you regarding Flutter development opportunities.\n\nBest regards,';

    final gmailUrl =
        'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    _launchURL(gmailUrl);
  }

  void _openProjectRepo(String repoUrl) async {
    final Uri uri = Uri.parse(repoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

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

                SizedBox(height: isMobile ? 20 : 30),
                _buildProfileSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
                _buildSkillsSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
                _buildProjectsSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
                _buildExperienceSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
                _buildEducationSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
                _buildAwardsSection(isMobile),

                SizedBox(height: isMobile ? 20 : 30),
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
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
            )
          ]
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.flutter_dash,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Phyo Wai Kyaw',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  Row(
                    children: [
                      _buildNavButton('Home', 0),
                      _buildNavButton('Profile', 800),
                      _buildNavButton('Skills', 1550),
                      _buildNavButton('Projects', 2450),
                      _buildNavButton('Experience', 4500),
                      _buildNavButton('Contact', 7600),
                    ],
                  )
                else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (value) {
                      switch (value) {
                        case 'Home':
                          _scrollToSection(0);
                          break;
                        case 'Profile':
                          _scrollToSection(700);
                          break;
                        case 'Skills':
                          _scrollToSection(1700);
                          break;
                        case 'Projects':
                          _scrollToSection(3000);
                          break;
                        case 'Experience':
                          _scrollToSection(4950);
                          break;
                        case 'Contact':
                          _scrollToSection(8000);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                          value: 'Home', child: Text('Home')),
                      const PopupMenuItem<String>(
                          value: 'Profile', child: Text('Profile')),
                      const PopupMenuItem<String>(
                          value: 'Skills', child: Text('Skills')),
                      const PopupMenuItem<String>(
                          value: 'Projects', child: Text('Projects')),
                      const PopupMenuItem<String>(
                          value: 'Experience', child: Text('Experience')),
                      const PopupMenuItem<String>(
                          value: 'Contact', child: Text('Contact')),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String label, double offset) {
    return TextButton(
      onPressed: () => _scrollToSection(offset),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
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
        );
      },
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      height: isMobile ? 700 : 800,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            0, math.sin(_floatingController.value * math.pi) * 20),
                        child: child,
                      );
                    },
                    child: Container(
                      width: isMobile ? 160 : 200,
                      height: isMobile ? 160 : 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/phyo.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: isMobile ? 60 : 80,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 30 : 50),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
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
                        SizedBox(height: isMobile ? 12 : 20),
                        Text(
                          'Junior Flutter Developer',
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24,
                            color: Colors.white60,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 16),
                        Text(
                          'Building Mobile Apps with Passion & Purpose',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white70, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Bangkok, Thailand | From Myanmar',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isMobile ? 12 : 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 60),
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

  Widget _buildSocialLinks(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
            FontAwesomeIcons.github, 'https://github.com/phyowaikyaw-mobiledev', isMobile),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIcon(FontAwesomeIcons.linkedin,
            'https://www.linkedin.com/in/phyowaikyaw-dev', isMobile),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIcon(FontAwesomeIcons.facebook,
            'https://facebook.com/learnersgateway30', isMobile),
        SizedBox(width: isMobile ? 20 : 30),
        _buildSocialIconWithEmail(isMobile),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, bool isMobile) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () => _launchURL(url),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isHovered
                      ? const Color(0xFF3B82F6)
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: FaIcon(
                icon,
                color: isHovered ? const Color(0xFF3B82F6) : Colors.white70,
                size: isMobile ? 20 : 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialIconWithEmail(bool isMobile) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: _openGmail,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isHovered
                      ? const Color(0xFF3B82F6)
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.envelope,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTAButtons(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _scrollToSection(6000),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32, vertical: isMobile ? 12 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Hire Me',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 16 : 20),
        OutlinedButton(
          onPressed: () => _scrollToSection(2200),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white70),
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32, vertical: isMobile ? 12 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'View Projects',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60, horizontal: isMobile ? 20 : 40),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello! I\'m Phyo Wai Kyaw',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'A passionate Junior Flutter Developer with hands-on experience in building production-level mobile applications under professional mentorship. I bring a unique perspective from my background in Quality Assurance, which helps me write cleaner, more maintainable code with strong attention to detail.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Currently based in Bangkok, Thailand, I\'m actively seeking opportunities to contribute to meaningful projects while continuously growing as a Flutter developer.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTechStack(isMobile),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildInfoCard(
                  'Current Focus',
                  Icons.code,
                  [
                    'Working on E-commerce Flutter App with mentorship',
                    'Learning State Management (BLoC, Provider, GetX)',
                    'Clean Architecture & Firebase Integration',
                    'Creating intuitive user experiences'
                  ],
                  isMobile,
                ),
                SizedBox(height: 15),

                // Then Career Goal
                _buildInfoCard(
                  'Career Goal',
                  Icons.flag,
                  [
                    'Contributing to meaningful projects',
                    'Continuous learning and growth',
                    'Building production-ready applications',
                    'Team collaboration and knowledge sharing'
                  ],
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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello! I\'m Phyo Wai Kyaw',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'A passionate Junior Flutter Developer with hands-on experience in building production-level mobile applications under professional mentorship. I bring a unique perspective from my background in Quality Assurance, which helps me write cleaner, more maintainable code with strong attention to detail.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Currently based in Bangkok, Thailand, I\'m actively seeking opportunities to contribute to meaningful projects while continuously growing as a Flutter developer.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 30),
                            _buildTechStack(isMobile),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildInfoCard(
                            'Current Focus',
                            Icons.code,
                            [
                              'Working on E-commerce Flutter App with mentorship',
                              'Learning State Management (BLoC, Provider, GetX)',
                              'Clean Architecture & Firebase Integration',
                              'Creating intuitive user experiences'
                            ],
                            isMobile,
                          ),
                          SizedBox(height: 15),
                          _buildInfoCard(
                            'Career Goal',
                            Icons.flag,
                            [
                              'Contributing to meaningful projects',
                              'Continuous learning and growth',
                              'Building production-ready applications',
                              'Team collaboration and knowledge sharing'
                            ],
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
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Flutter',
            'Dart',
            'Firebase',
            'GetX',
            'BLoC',
            'REST API',
            'Git',
            'Figma'
          ].map((tech) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF3B82F6),
                width: 1,
              ),
            ),
            child: Text(
              tech,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.white,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<String> points, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
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
          SizedBox(height: 12),
          ...points.map((point) => Padding(
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
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60, horizontal: isMobile ? 16 : 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              _buildSectionTitle('Technical Skills', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  mainAxisExtent: isMobile ? 155 : 175,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final skills = [
                    ['Mobile Development', Icons.phone_android, ['Flutter', 'Dart', 'Android', 'VS Code', 'Material Design'], const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
                    ['State Management', Icons.settings, ['GetX', 'BLoC', 'Provider', 'State Patterns'], const Color(0xFF3B82F6), const Color(0xFF1E40AF)],
                    ['Backend & Services', Icons.cloud, ['Firebase', 'REST API', 'Firestore', 'FCM', 'Postman'], const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
                    ['Database & Storage', Icons.storage, ['Firestore', 'Realm', 'SQLite', 'Hive', 'Local Storage'], const Color(0xFF3B82F6), const Color(0xFF1E40AF)],
                    ['Development Tools', Icons.build, ['Git', 'GitHub', 'Figma', 'DevTools', 'Studio'], const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
                    ['Architecture', Icons.architecture, ['MVC', 'Clean Code', 'Widgets', 'Navigation'], const Color(0xFF3B82F6), const Color(0xFF1E40AF)],
                  ];
                  return _buildIconSkillCard(
                    skills[index][0] as String,
                    skills[index][1] as IconData,
                    skills[index][2] as List<String>,
                    skills[index][3] as Color,
                    skills[index][4] as Color,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconSkillCard(
      String title, IconData icon, List<String> skills, Color primaryColor, Color secondaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            secondaryColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, secondaryColor],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: skills.map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Personal Projects', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              Column(
                children: [
                  _buildProjectCard(
                    'Learners Gateway - Blog Platform',
                    'Flutter Web Application',
                    'assets/images/learners_gateway.jpg',
                    'Modern, responsive blog platform built with Flutter Web & Firebase for my tech education community. Features blog system with post listing, admin dashboard, real-time updates, and responsive design.',
                    [
                      'Flutter Web',
                      'Firebase Auth',
                      'Cloud Firestore',
                      'Provider',
                      'go_router'
                    ],
                    'https://learners-gateway.web.app',
                    'https://github.com/phyowaikyaw-mobiledev/learners_gateway_website',
                    Icons.web,
                    isMobile,
                    status: 'In Development (65% Complete)',
                  ),
                  SizedBox(height: isMobile ? 20 : 25),
                  _buildProjectCard(
                    'E-Commerce Mobile App',
                    'Production-Level Application',
                    'assets/images/ecommerce_app.jpg',
                    'Full-featured shopping platform built under senior developer guidance. Features product catalog, shopping cart, Firebase Authentication, push notifications, and Myanmar language support.',
                    [
                      'Flutter',
                      'Firebase',
                      'REST API',
                      'GetX',
                      'FCM'
                    ],
                    null,
                    'https://github.com/phyowaikyaw-mobiledev/e_commerce',
                    Icons.shopping_cart,
                    isMobile,
                    status: 'Ongoing - Mentorship Project',
                  ),
                  SizedBox(height: isMobile ? 20 : 25),
                  _buildProjectCard(
                    'Pardon Diary - Note Taking App',
                    'Feature-rich Note Application',
                    'assets/images/note_app.jpg',
                    'Google Keep-inspired note app with local database persistence. Features CRUD operations, real-time updates, staggered grid layout, full-text search, and dark theme.',
                    [
                      'Flutter',
                      'Realm Database',
                      'Streams',
                      'Material Design 3'
                    ],
                    null,
                    'https://github.com/phyowaikyaw-mobiledev/pardon_diary-note',
                    Icons.note_alt,
                    isMobile,
                    status: 'Completed',
                  ),
                  SizedBox(height: isMobile ? 20 : 25),
                  _buildProjectCard(
                    'Ying Music - Streaming App UI',
                    'Music Player Interface',
                    'assets/images/music_app.jpg',
                    'Modern music streaming app UI clone inspired by Spotify and Joox. Features gradient designs, artist profiles, bottom sheet interactions, and hero animations.',
                    [
                      'Flutter',
                      'Material Design 3',
                      'Animations',
                      'Custom Widgets'
                    ],
                    null,
                    'https://github.com/phyowaikyaw-mobiledev/music_app',
                    Icons.music_note,
                    isMobile,
                    status: 'Completed',
                  ),
                  SizedBox(height: isMobile ? 20 : 25),
                  _buildProjectCard(
                    'SocialHub - Social Media UI Clone',
                    'Facebook-inspired Interface',
                    'assets/images/social_app.jpg',
                    'Facebook-inspired social media app with modern design elements. Features news feed, interactive posts, notification system, contact management, and phone integration.',
                    [
                      'Flutter',
                      'Material Design',
                      'Complex UI',
                      'Navigation'
                    ],
                    null,
                    'https://github.com/phyowaikyaw-mobiledev/social_media_ui_clone',
                    Icons.people,
                    isMobile,
                    status: 'Completed',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
      String title,
      String subtitle,
      String imagePath,
      String description,
      List<String> technologies,
      String? liveDemoUrl,
      String githubUrl,
      IconData icon,
      bool isMobile, {
        String status = 'Completed',
      }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isMobile ? 80 : 120,
                height: isMobile ? 80 : 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 40),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.contains('Development')
                                ? Colors.orange.withOpacity(0.2)
                                : status.contains('Ongoing')
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: status.contains('Development')
                                  ? Colors.orange
                                  : status.contains('Ongoing')
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 12,
                              color: status.contains('Development')
                                  ? Colors.orange
                                  : status.contains('Ongoing')
                                  ? Colors.blue
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technologies.map((tech) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF3B82F6),
                  width: 1,
                ),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.white,
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              if (liveDemoUrl != null)
                ElevatedButton.icon(
                  onPressed: () => _launchURL(liveDemoUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.launch, size: 16),
                  label: const Text('Live Demo'),
                ),
              if (liveDemoUrl != null) SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _openProjectRepo(githubUrl),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                label: const Text('View Code'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Professional Experience', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              _buildExperienceCard(
                'Junior Flutter Developer (Mentorship)',
                'Current Project',
                '2024 - Present',
                [
                  'Collaborating with senior developers on production e-commerce application',
                  'Implementing UI screens based on Figma designs and specifications',
                  'Integrating Firebase services (Auth, Firestore, Cloud Messaging)',
                  'Working with REST APIs for product catalog management',
                  'Participating in code reviews and implementing feedback',
                  'Writing clean, maintainable code following team standards'
                ],
                ['Flutter', 'Dart', 'Firebase', 'REST API', 'Git'],
                Icons.work,
                isMobile,
              ),
              SizedBox(height: isMobile ? 15 : 20),
              _buildExperienceCard(
                'Junior Quality Assurance Tester',
                'Techno-Wave Software House',
                'Feb 2024 - Sept 2024',
                [
                  'Executed manual test cases for mobile and web applications',
                  'Identified and documented 100+ software defects',
                  'Collaborated with developers in Agile/Scrum environment',
                  'Tested REST API endpoints using Postman',
                  'Conducted cross-browser and cross-platform testing'
                ],
                ['Manual Testing', 'Agile/Scrum', 'Postman', 'Jira'],
                Icons.bug_report,
                isMobile,
                note: 'Company ceased operations due to political situation in Sept 2024',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceCard(
      String title,
      String company,
      String period,
      List<String> responsibilities,
      List<String> technologies,
      IconData icon,
      bool isMobile, {
        String note = '',
      }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1,
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
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
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3B82F6),
                    width: 1,
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (note.isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.orange.withOpacity(0.9),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responsibilities.map((responsibility) => Padding(
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      responsibility,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technologies.map((tech) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF3B82F6),
                  width: 1,
                ),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.white,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Education & Training', isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              _buildEducationCard(
                'Computer Science Major',
                'Computer University, Mandalay (Myanmar)',
                '2019 - 2021 (2 Years Completed)',
                [
                  'Data Structures & Algorithms',
                  'Database Management Systems',
                  'Software Engineering Principles',
                  'Object-Oriented Programming',
                  'Computer Architecture'
                ],
                Icons.school,
                isMobile,
              ),
              SizedBox(height: isMobile ? 15 : 20),
              _buildEducationCard(
                'Professional Flutter Development Program',
                'One-on-one Mentorship with Senior Developer',
                '2024 - Present',
                [
                  'Personalized Flutter training sessions with industry professional',
                  'Regular code reviews emphasizing best practices and design patterns',
                  'Collaborative work on production-level project implementations',
                  'Professional guidance on clean code principles and maintainable architecture',
                  'Learning enterprise-level standards from day one'
                ],
                Icons.code,
                isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(String title, String institution, String period,
      List<String> details, IconData icon, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1,
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
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
                      institution,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6),
                width: 1,
              ),
            ),
            child: Text(
              period,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: details.map((detail) => Padding(
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      detail,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 30 : 50, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionTitle('Awards & Achievements', isMobile),
              // ✅ CHANGED: Reduced spacing from 40/60 to 20/30
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
                      '🏆 1st Place Winner',
                      style: TextStyle(
                        fontSize: isMobile ? 22 : 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Oway Travel Hackathon 2020',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Organized by Oway Group | Mandalay, Myanmar',
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
                width: 1,
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
                    SizedBox(width: 10),
                    Text(
                      'Award: AWS Cloud Credits (\$1000 value)',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildAwardDetail('Project', 'Travel-related application solution (hackathon challenge)', isMobile),
                _buildAwardDetail('Team Role', 'Developer and team collaborator', isMobile),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  'Skills Demonstrated:',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Problem-solving',
                    'Team Collaboration',
                    'Rapid Prototyping',
                    'Presentation Skills',
                    'Time Management',
                  ]
                      .map((skill) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 12,
                      vertical: isMobile ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: Colors.white,
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),
          isMobile
              ? Column(
            children: [
              _buildHackathonImage(
                'assets/images/hackathon_award.jpg',
                'Hackathon Award Ceremony',
                isMobile,
              ),
              SizedBox(height: 16),
              _buildHackathonImage(
                'assets/images/hackathon_team.jpg',
                'Team Photo',
                isMobile,
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _buildHackathonImage(
                  'assets/images/hackathon_award.jpg',
                  'Hackathon Award Ceremony',
                  isMobile,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildHackathonImage(
                  'assets/images/hackathon_team.jpg',
                  'Team Photo',
                  isMobile,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 14),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: isMobile ? 18 : 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Note: University closure due to COVID-19 pandemic prevented full utilization of award.',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 13,
                      color: Colors.orange.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHackathonImage(String assetPath, String caption, bool isMobile) {
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: isMobile ? 40 : 60,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      SizedBox(height: 10),
                      Text(
                        caption,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
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

  Widget _buildAwardDetail(String label, String value, bool isMobile) {
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

  Widget _buildContactSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 50 : 80, horizontal: isMobile ? 20 : 40),
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
              // Header Section
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      '💬 Let\'s Connect',
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
                ],
              ),

              SizedBox(height: isMobile ? 30 : 40),

              isMobile ? _buildMobileContactLayout() : _buildDesktopContactLayout(),
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
              _buildEnhancedContactCard(
                Icons.email_outlined,
                'Email',
                'phyowaikyawdeveloper@gmail.com',
                'Drop me an email anytime',
                _openGmail,
                const Color(0xFF3B82F6),
                const Color(0xFF60A5FA),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedContactCard(
                      FontAwesomeIcons.github,
                      'GitHub',
                      'phyowaikyaw-mobiledev',
                      'Check out my projects',
                          () => _launchURL('https://github.com/phyowaikyaw-mobiledev'),
                      const Color(0xFF6366F1),
                      const Color(0xFF818CF8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEnhancedContactCard(
                      FontAwesomeIcons.linkedin,
                      'LinkedIn',
                      'Phyo Wai Kyaw',
                      'Let\'s connect professionally',
                          () => _launchURL('https://www.linkedin.com/in/phyowaikyaw-dev'),
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

        Expanded(
          flex: 2,
          child: _buildOpportunityCard(false),
        ),
      ],
    );
  }

  Widget _buildMobileContactLayout() {
    return Column(
      children: [
        _buildEnhancedContactCard(
          Icons.email_outlined,
          'Email',
          'phyowaikyawdeveloper@gmail.com',
          'Drop me an email anytime',
          _openGmail,
          const Color(0xFF3B82F6),
          const Color(0xFF60A5FA),
        ),
        const SizedBox(height: 15),
        _buildEnhancedContactCard(
          FontAwesomeIcons.github,
          'GitHub',
          'phyowaikyaw-mobiledev',
          'Check out my projects',
              () => _launchURL('https://github.com/phyowaikyaw-mobiledev'),
          const Color(0xFF6366F1),
          const Color(0xFF818CF8),
        ),
        const SizedBox(height: 15),
        _buildEnhancedContactCard(
          FontAwesomeIcons.linkedin,
          'LinkedIn',
          'Phyo Wai Kyaw',
          'Let\'s connect professionally',
              () => _launchURL('https://www.linkedin.com/in/phyowaikyaw-dev'),
          const Color(0xFF8B5CF6),
          const Color(0xFFA78BFA),
        ),
        const SizedBox(height: 20),
        _buildOpportunityCard(true),
      ],
    );
  }

  Widget _buildEnhancedContactCard(
      IconData icon,
      String title,
      String value,
      String subtitle,
      VoidCallback onTap,
      Color primaryColor,
      Color secondaryColor,
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
              colors: [
                primaryColor.withOpacity(0.1),
                secondaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
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
                color: primaryColor.withOpacity(0.6),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
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
            'Currently seeking exciting roles and projects',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildOpportunityItem('💼', 'Full-time positions'),
          const SizedBox(height: 12),
          _buildOpportunityItem('🌏', 'Remote work'),
          const SizedBox(height: 12),
          _buildOpportunityItem('🚀', 'Freelance projects'),
          const SizedBox(height: 12),
          _buildOpportunityItem('💻', 'Open-source contributions'),
          const SizedBox(height: 28),
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
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildOpportunityItem(String emoji, String text) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
          ],
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
            SizedBox(height: 8),
            Text(
              '© 2025 Phyo Wai Kyaw. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
            SizedBox(height: 20),
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
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 50.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}