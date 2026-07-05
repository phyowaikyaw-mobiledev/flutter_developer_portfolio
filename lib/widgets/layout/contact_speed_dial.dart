import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';

class ContactSpeedDial extends StatefulWidget {
  const ContactSpeedDial({super.key});

  @override
  State<ContactSpeedDial> createState() => _ContactSpeedDialState();
}

class _ContactSpeedDialState extends State<ContactSpeedDial>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          ScaleTransition(
            scale: _scale,
            child: Column(
              children: [
                _dialBtn(
                  icon: const FaIcon(FontAwesomeIcons.linkedin, size: 18),
                  onTap: () => _launch(AppStrings.linkedin),
                ),
                const SizedBox(height: 10),
                _dialBtn(
                  icon: const Icon(Icons.phone_outlined, size: 20),
                  onTap: () => _launch(AppStrings.phoneTel),
                ),
                const SizedBox(height: 10),
                _dialBtn(
                  icon: const Icon(Icons.email_outlined, size: 20),
                  onTap: () => _launch('mailto:${AppStrings.email}'),
                ),
                const SizedBox(height: 10),
                _dialBtn(
                  icon: const Icon(Icons.close, size: 20),
                  isClose: true,
                  onTap: _toggle,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
        FloatingActionButton(
          onPressed: _open ? _toggle : _toggle,
          backgroundColor: AppColors.primary,
          child: Icon(
            _open ? Icons.close : Icons.chat_bubble_outline,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _dialBtn({
    required Widget icon,
    required VoidCallback onTap,
    bool isClose = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isClose
                ? const Color(0xFFEF4444).withValues(alpha: 0.9)
                : const Color(0xFF1E1E1E),
            border: Border.all(
              color: isClose ? Colors.transparent : const Color(0xFF3A3A3A),
            ),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
