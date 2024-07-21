

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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


  /// delete the feature from category
  static Future<void> deleteFeature(int featureId, String token) async {
    var headers = {
      'Authorization': 'token $token',
    };
    var dio = Dio();

    try {
      var response = await dio.request(
        '${AppConstants.baseUrl}api/property/feature/$featureId/delete/',
        options: Options(
          method: 'DELETE',
          headers: headers,
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 204) {
        Get.snackbar("Success", "Feature deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        print(json.encode(response.data));
      } else if (response.statusCode == 404) {
        Get.snackbar("Error", "Feature not found: ${response.statusMessage}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(response.statusMessage);
      } else {
        Get.snackbar("Error", "Failed to delete feature: ${response.statusMessage}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(response.statusMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete feature: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(e);
    }
  }

}