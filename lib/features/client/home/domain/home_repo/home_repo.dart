
import 'package:flutter/foundation.dart';

import '../../data/models/category/category_model.dart';
import '../../data/remote_api/home_api_service.dart';

class HomeRepository{
  final HomeApiService _homeApiService;
  HomeRepository(this._homeApiService);

  Future<CategoryModel> getMainCategory() async{

    try{
      final response = await _homeApiService.getMainCategories();

      if (kDebugMode) {
        print("main category sucess");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

}