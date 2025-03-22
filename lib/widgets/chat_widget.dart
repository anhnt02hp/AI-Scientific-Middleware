import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:ai_scientific_middleware/services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(AssetsManager.userImage, height: 30, width: 30,),
                const SizedBox(width: 8,),
                const TextWidget(
                  label: "Hello here our message",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
