import 'dart:developer';

import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/providers/chats_provider.dart';
import 'package:ai_scientific_middleware/providers/models_provider.dart';
import 'package:ai_scientific_middleware/services/assets_manager.dart';
import 'package:ai_scientific_middleware/services/services.dart';
import 'package:ai_scientific_middleware/widgets/chat_widget.dart';
import 'package:ai_scientific_middleware/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
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
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    segments: chatProvider.getChatList[index].segments,
                  );
                },
              ),
            ),
            if(_isTyping)...[
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 18,
              ),
            ],
            const SizedBox(height: 15,),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(color: Colors.grey,)
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);
                      },
                      icon: const Icon(Icons.send, color: Colors.white,)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut
    );
  }
  //Send message
  Future<void> sendMessageFCT({required ModelsProvider modelsProvider, required ChatProvider chatProvider}) async {
    if(_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TextWidget(
              label: "You can not send multiple messages at a time!",
            ),
            backgroundColor: Colors.red,
          ));
      return;
    }

    if(textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ));
      return;
    }
    try{
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswer(msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    }catch (error) {
      log("Error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
