import 'dart:convert';
import 'package:http/http.dart' as http;

class LatexRendererService {
  final String baseUrl = 'http://192.168.59.200:5000';

  Future<List<Map<String, dynamic>>> renderLatexFromText(String latexText) async {
    final url = Uri.parse('$baseUrl/render_latex');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'latex_code': latexText});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Trả về nguyên list segments (text và latex)
      return List<Map<String, dynamic>>.from(data['segments']);
    } else {
      throw Exception('Failed to render LaTeX: ${response.body}');
    }
  }
}
