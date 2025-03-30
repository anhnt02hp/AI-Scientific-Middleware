import 'package:ai_scientific_middleware/models/models_model.dart';
import 'package:ai_scientific_middleware/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier{
  String currentModel = "open-r1/olympiccoder-32b:free";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel (String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels () async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}