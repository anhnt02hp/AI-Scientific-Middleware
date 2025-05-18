import 'dart:convert';
import 'dart:typed_data';
import 'package:ai_scientific_middleware/services/latex_renderer_service.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(title: Text("Test LaTeX API")),
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
                  labelText: "Nhập đoạn LaTeX hoặc text",
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
                RichText(
                  text: TextSpan(
                    children: _segments.map<InlineSpan>((segment) {
                      if (segment['type'] == 'text') {
                        return TextSpan(
                          text: segment['content'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        );
                      } else if (segment['type'] == 'latex') {
                        String base64Str = segment['base64'] ?? '';
                        Uint8List bytes = base64Decode(base64Str);
                        return WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.memory(
                            bytes,
                            height: 20, // nhỏ gọn để vừa dòng
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      } else {
                        return TextSpan(); // fallback
                      }
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
