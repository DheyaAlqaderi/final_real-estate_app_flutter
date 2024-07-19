import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/core/constant/app_constants.dart';

class UpdateListAttributesRepository {
  static Future<void> updatePropertyValue(
      Map<String, dynamic> payload, String token) async {
    // Set up headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'token $token',
    };

    // Create the request
    var request = http.Request(
        'PUT', Uri.parse('${AppConstants.baseUrl}api/property/attribute/update-property-value/'));

    // Set request body
    request.body = json.encode(payload);
    request.headers.addAll(headers);

    // Send the request
    http.StreamedResponse response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      Get.snackbar("Success attributes updated", await response.stream.bytesToString());
      // print(await response.stream.bytesToString());
    } else {
      Get.snackbar("Error attributes updated", await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
  }
}
