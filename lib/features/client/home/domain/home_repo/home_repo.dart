
import 'package:flutter/foundation.dart';
import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';

import '../../data/models/category/category_model.dart';
import '../../data/remote_api/home_api_service.dart';

class HomeRepository{
  final HomeApiService _homeApiService;
  HomeRepository(this._homeApiService);

  Future<CategoryModel> getMainCategory({
    required int pageSize,
    required int pageNumber,
    required int parentId}) async{

    try{
      final response = await _homeApiService.getCategories(pageNumber, pageSize, parentId);

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

  Future<List<BannerModel>> getBanners() async{

    try{
      final response = await _homeApiService.getBanners();

      if (kDebugMode) {
        print("Banners sucess");
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