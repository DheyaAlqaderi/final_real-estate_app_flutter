import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/core/constant/app_constants.dart';
class UpdatePropertyRepository{

  static Future<void> update({required Map<String, dynamic> body, required int propertyId, required String token}) async{

    try{
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('PATCH', Uri.parse('${AppConstants.baseUrl}api/address/$propertyId/update/'));
      request.body = json.encode(body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "property updated successfully");
        print(await response.stream.bytesToString());
      } else {
        Get.snackbar("bad request", "error");
        print(response.reasonPhrase);
      }
    } catch(e){
      Get.snackbar("something wrong", "error");
    }
  }
}