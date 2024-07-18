
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/app_constants.dart';


class FeatureRepository {
  static Future<List<Map<String, dynamic>>> fetchFeatures({required int categoryId}) async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse('${AppConstants.baseUrl}api/categorie/features/?category=$categoryId'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        List<dynamic> decoded = json.decode(responseBody);
        return decoded.map((feature) => feature as Map<String, dynamic>).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch features: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return [];
    }
  }
}



