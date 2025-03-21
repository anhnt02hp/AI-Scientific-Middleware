import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/services/assets_manager.dart';
import 'package:ai_scientific_middleware/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white,)
          ),
        ],
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text('ChatGPT', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const ChatWidget();
                },
              ),
            ),
            if(_isTyping)...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(height: 15,),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value){
                            // TODO send message
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you?",
                            hintStyle: TextStyle(color: Colors.grey,)
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                        },
                        icon: const Icon(Icons.send, color: Colors.white,)
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
