import 'package:ai_scientific_middleware/models/chat_model.dart';
import 'package:ai_scientific_middleware/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:ai_scientific_middleware/services/latex_renderer_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  final LatexRendererService _latexService = LatexRendererService();

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  // Future<void> sendMessageAndGetAnswer({required String msg, required String chosenModelId}) async {
  //   chatList.addAll(await ApiService.sendMessage(
  //     message: msg,
  //     modelId: chosenModelId,
  //   ));
  //   notifyListeners();
  // }

  Future<void> sendMessageAndGetAnswer({
    required String msg,
    required String chosenModelId,
  }) async {
    // Gửi message đến AI
    final List<ChatModel> rawResponse = await ApiService.sendMessage(
      message: msg,
      modelId: chosenModelId,
    );

    // Giả sử AI chỉ trả về 1 đoạn (chatIndex: 1)
    final ChatModel aiRawMsg = rawResponse.first;

    // Gửi response tới middleware để render LaTeX
    try {
      final List<Map<String, dynamic>> segments =
      await _latexService.renderLatexFromText(aiRawMsg.msg);

      // Gắn kết quả vào ChatModel mới
      final ChatModel finalChat = ChatModel(
        msg: aiRawMsg.msg,
        chatIndex: 1,
        segments: segments,
      );

      chatList.add(finalChat);
    } catch (e) {
      // Nếu lỗi, vẫn hiển thị text thuần
      chatList.add(aiRawMsg);
    }

    notifyListeners();
  }

}