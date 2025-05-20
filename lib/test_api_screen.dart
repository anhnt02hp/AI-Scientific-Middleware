import 'dart:convert';
import 'dart:typed_data';

import 'package:ai_scientific_middleware/services/latex_renderer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';  // thêm

class TestApiScreen extends StatefulWidget {
  @override
  _TestApiScreenState createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  final LatexRendererService _rendererService = LatexRendererService();
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> _segments = [];
  String? _error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Test LaTeX & Markdown API")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nhập đoạn LaTeX hoặc text (hỗ trợ markdown)",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _error = null;
                    _segments = [];
                  });
                  try {
                    final text = _controller.text.trim();
                    if (text.isEmpty) {
                      setState(() {
                        _error = "Vui lòng nhập đoạn text";
                      });
                      return;
                    }
                    List<Map<String, dynamic>> segments =
                    await _rendererService.renderLatexFromText(text);
                    setState(() {
                      _segments = segments;
                    });
                    debugPrint("Received segments:");
                    segments.forEach((seg) => debugPrint(seg.toString()));
                  } catch (e) {
                    setState(() {
                      _error = "Error: $e";
                    });
                    debugPrint("Error: $e");
                  }
                },
                child: Text("Gửi"),
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),

              if (_segments.isNotEmpty)
              // Thay vì dùng RichText, ta dùng Column chứa từng segment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _segments.map<Widget>((segment) {
                    if (segment['type'] == 'text') {
                      // Render markdown cho đoạn text này
                      return MarkdownBody(
                        data: segment['content'] ?? '',
                        styleSheet:
                        MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          strong: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          em: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else if (segment['type'] == 'latex') {
                      String base64Str = segment['base64'] ?? '';
                      Uint8List bytes = base64Decode(base64Str);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.memory(
                          bytes,
                          height: 20,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    } else {
                      return SizedBox.shrink(); // fallback
                    }
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
