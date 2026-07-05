import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      elevation: 6,
      child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
    );
  }
}
