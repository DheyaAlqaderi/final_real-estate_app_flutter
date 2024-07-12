
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class TestApi{
  static Future<Map<String, dynamic>> get({required int propertyId, required File fileImage, required String token}) async {


    var headers = {
      'Authorization': 'token $token'
    };


    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.131:8000/api/image/feature/create/'));


    request.fields.addAll({
      'object_id': '$propertyId',
    });


    request.files.add(await http.MultipartFile.fromPath('image', fileImage.path));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
    // print(await response.stream.bytesToString());


    var resp = await response.stream.bytesToString();
    Map<String, dynamic> re = jsonDecode(resp);

    return re;
    }
    else {
    print(response.reasonPhrase);
    return {};
    }
  }
}