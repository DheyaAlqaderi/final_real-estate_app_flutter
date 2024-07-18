

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/app_constants.dart';


class CreateFeaturePropertyRepository {

  static Future<Map<String, dynamic>> createFeature({required int propertyId, required int featureId, required String token}) async {
    try {
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('${AppConstants.baseUrl}api/property/feature/create/'));
      request.body = json.encode({
        "property": propertyId,
        "feature": featureId
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> decoded = json.decode(responseBody);
        Get.snackbar("Success", "Features Created successfully");
        return decoded;
      } else {
        // Get.snackbar("Error", "Failed to create features: ${response.reasonPhrase}");
        return {};
      }


    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return {};
    }
  }

}