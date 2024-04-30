
import 'dart:ffi';

import 'package:http/http.dart' as http;
class RatingRepository{

  static Future<String> postReview(
      {required double rating, required String review, required int idProperty, required String token}) async {
    /// the url
    final String url ="j";

    /// set data to model
    Map<String, dynamic> mapData = {
      "propertyId": idProperty,
      "rating": rating,
      "review": review
    };

    /// post to the server
    final response = await http.post(
        Uri.parse(url),
        body: mapData,
      headers: {
          "Authorization": "token $token"
      }
    );

    /// get response
    return response.body;

  }

}