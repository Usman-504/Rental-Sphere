import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Text('Chat'),
      ),
    );
  }
}
