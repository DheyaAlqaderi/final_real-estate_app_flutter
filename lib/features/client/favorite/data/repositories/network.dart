
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/features/client/favorite/data/models/favorite_model.dart';
import 'dart:convert';

class NetworkRequest{
  static const String url = 'http://192.168.0.86:8000/api/user/favorite/';
  static String token =  "3cbe099b83e79ab703f50eb1a09f9ad658f9fe89";

  static Future<FavoriteModel> fetchPhotos() async{

    /// 1 get the json data
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "token $token",
        });

    /// 2 convert the json to your model
    var data = FavoriteModel.fromJson(json.decode(response.body));

    return data;

  }
}