import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/providers/chats_provider.dart';
import 'package:ai_scientific_middleware/providers/models_provider.dart';
import 'package:ai_scientific_middleware/screens/chat_screen.dart';
import 'package:ai_scientific_middleware/test_api_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
              color: cardColor
          ),
      
        ),
        home: const ChatScreen(),
        //home: TestApiScreen(),
      ),
    );
  }
}


