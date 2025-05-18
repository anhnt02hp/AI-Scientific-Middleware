import 'dart:convert';
import 'package:http/http.dart' as http;

class LatexRendererService {
  final String baseUrl = 'http://192.168.92.200:5000';

  Future<List<String>> renderLatexFromText(String latexText) async {
    final url = Uri.parse('$baseUrl/render_latex');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'latex_code': latexText});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['images']);
    } else {
      throw Exception('Failed to render LaTeX: ${response.body}');
    }
  }
}
