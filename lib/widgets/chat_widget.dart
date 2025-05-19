import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/widgets/text_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ai_scientific_middleware/services/assets_manager.dart';
import 'dart:convert';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex, this.segments,});

  final String msg;
  final int chatIndex;
  final List<Map<String, dynamic>>? segments;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                  ? AssetsManager.userImage
                  : AssetsManager.botImage,
                  height: 30, width: 30
                ),
                const SizedBox(width: 8,),
                // Expanded(
                //   child: chatIndex == 0
                //     ? TextWidget(
                //         label: msg,
                //       )
                //     : DefaultTextStyle(
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.w700,
                //           fontSize: 16
                //         ),
                //         child: AnimatedTextKit(
                //           isRepeatingAnimation: false,
                //           repeatForever: false,
                //           displayFullTextOnTap: true,
                //           totalRepeatCount: 1,
                //           animatedTexts: [TyperAnimatedText(msg.trim())])
                //       )
                // ),
                Expanded(
                  child: chatIndex == 0
                    ? TextWidget(label: msg)
                    : segments == null
                    ? DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          repeatForever: false,
                          displayFullTextOnTap: true,
                          totalRepeatCount: 1,
                          animatedTexts: [TyperAnimatedText(msg.trim())],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: segments!.map((segment) {
                          if (segment['type'] == 'text') {
                            return Text(
                              segment['content'] ?? '',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            );
                          } else if (segment['type'] == 'latex') {
                            try {
                              final imageBytes = base64Decode(segment['base64']);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.memory(imageBytes),
                              );
                            } catch (e) {
                              return const Text(
                                'Lỗi khi hiển thị ảnh LaTeX',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        }).toList(),
                      ),
                ),

                chatIndex == 0
                  ? const SizedBox.shrink()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.thumb_down_alt_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
