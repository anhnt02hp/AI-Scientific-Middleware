import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ai_scientific_middleware/constants/api_consts.dart';
import 'package:ai_scientific_middleware/models/chat_model.dart';
import 'package:ai_scientific_middleware/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService{
  //Get List Model
  static Future<List<ModelsModel>> getModels() async {
    try{
      var response = await http.get(Uri.parse("$BASE_URL/models"));

      Map jsonResponse = jsonDecode(response.body);

      if(jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        //log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("Error $error");
      rethrow;
    }
  }

  //Send Message
  static Future<List<ChatModel>> sendMessage({required String message, required String modelId}) async {
    try{
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization' : 'Bearer $API_KEY',
          "Content-Type" : "application/json",
        },
        body: jsonEncode(
            {
              "model": modelId,
              "messages": [
                {
                  "role": "user",
                  "content": message
                }
              ]

            }),
      );

      Map jsonResponse = jsonDecode(response.body);

      if(jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List<ChatModel> chatList = [];
      if(jsonResponse["choices"].length > 0){
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          )
        );
      }
      return chatList;

    } catch (error) {
      log("Error $error");
      rethrow;
    }
  }
}