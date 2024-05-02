
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/features/client/favorite/data/models/favorite_model.dart';
import 'dart:convert';

class NetworkRequest {
  static const String url = 'http://192.168.0.86:8000/api/user/favorite/';
  static String token = "3cbe099b83e79ab703f50eb1a09f9ad658f9fe89";

  static Future<FavoriteModel?> fetchPhotos() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "token $token",
        },
      );

      if (response.statusCode == 200) {
        return FavoriteModel.fromJson(json.decode(response.body));
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}