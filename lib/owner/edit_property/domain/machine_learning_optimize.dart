import 'dart:convert';
import 'package:http/http.dart' as http;

class  MachineLearningOptimize{
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  static const String apiKey = 'AIzaSyAT6tEE2sryx8yPrYKZHhTZPpBCLVHdtVo';

  static Future<String> generateContent(String text) async {
    final url = Uri.parse('$apiUrl?key=$apiKey');

    var headers = {
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'contents': [
        {
          'parts': [
            {'text': "اعطيني تحسين لهذا العقار : $text"}
          ]
        }
      ]
    });

    var request = http.Request('POST', url)
      ..body = body
      ..headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        var textContent = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        print(textContent);
        return textContent;
      } else {
        print('Failed to generate content. Status code: ${response.statusCode}');
        print('Response reason: ${response.reasonPhrase}');
        return "error";
      }
    } catch (e) {
      print('Error: $e');
      return "error";
    }
  }
}

