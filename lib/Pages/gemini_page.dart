import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:growth/widgets/gemini_chat_bot.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  
  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe6f4ea), Color(0xFFcdeac0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Decorative leaves (optional)
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset('assets/images/leaf_top_left.png', width: 100),
        ),
        if(isArabic == false)
         Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            'assets/images/leaf_bottom_right.png',
            width: 130,
          ),
        )
        else
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/images/leaf_bottom_left.png',
            width: 130,
          ),
        ),

        // Main content
        SafeArea(
          child: Column(
            children: [
              // Custom app bar replacement
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Smart Assistant'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(Icons.chat_bubble_outline, color: Colors.green),
                  ],
                ),
              ),

              // Chatbot body
              const Expanded(
                child: GeminiChatBot(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
