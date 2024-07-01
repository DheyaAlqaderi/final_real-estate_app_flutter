import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';

class AddFavoriteRepository {
  // static const String token = '744b28bc857ac73af9a88bbf4557f695889b44c4';

  static Future<void> addFavorite(int propId, String token) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}api/user/favorite/create/');
      final headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'prop': propId});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Favorite added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add favorite. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add favorite: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
