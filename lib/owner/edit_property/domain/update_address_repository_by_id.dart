import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';


class UpdateAddressById{

  static Future<void> update({required int addressId ,required Map<String, dynamic> body}) async{

    final token = await SharedPrefManager.getData(AppConstants.token);
    if(token == null){
      Get.snackbar("Authorization", "you are not allowed to update address");
      return;
    }
    try{
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('PATCH',
          Uri.parse('${AppConstants.baseUrl}api/address/$addressId/update/'));

      request.body = json.encode(body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "address updated successfully");
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