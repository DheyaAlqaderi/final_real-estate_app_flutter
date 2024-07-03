import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_real_estate/core/constant/app_constants.dart';

import '../../../home/data/models/category/category_model.dart';

class CategoriesRepository {

  static Future<List<String>> fetchCategories({int parent = 0}) async {
    try {
      String url = "${AppConstants.baseUrl}api/categorie/?parent=$parent";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse JSON response into CategoryModel
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['results'];
        List<String> options2 = jsonResponse.map((item) => item['name'] as String).toList();
        return options2;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load categoriesll');
      }
    } catch (e) {
      // Catch any exceptions thrown during the HTTP request
      print('Error: $e');
      throw Exception('Failed to load categories');
    }
  }
}
