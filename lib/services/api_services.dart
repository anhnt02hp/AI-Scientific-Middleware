import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ai_scientific_middleware/constants/api_consts.dart';
import 'package:ai_scientific_middleware/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService{
  static Future<List<ModelsModel>> getModels() async {
    try{
      var response = await http.get(Uri.parse("$BASE_URL/models"), headers: {'Authorization': 'Bearer $API_KEY'});

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
}