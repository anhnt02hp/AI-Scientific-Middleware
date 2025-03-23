import 'package:ai_scientific_middleware/widgets/text_widget.dart';
import 'package:flutter/material.dart';

Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF4444654);

List<String> models = [
  'Model1',
  'Model2',
  'Model3',
  'Model4',
  'Model5',
  'Model6',
];

List<DropdownMenuItem<String>>? get getModelsItem{
  List<DropdownMenuItem<String>>? modelsItems =
    List<DropdownMenuItem<String>>.generate(
        models.length,
        (index) => DropdownMenuItem(
          value: models[index],
          child: TextWidget(
            label: models[index],
            fontSize: 15,
          )
        )
    );
  return modelsItems;
}

final chatMessages = [
  {
    "msg": "Hello who are you?",
    "chatIndex": 0,
  },
  {
    "msg": "Hello, I am ChatGPT",
    "chatIndex": 1,
  },
  {
    "msg": "What is FLutter?",
    "chatIndex": 0,
  },
  {
    "msg": "Flutter is an open-source mobile application",
    "chatIndex": 1,
  }
];