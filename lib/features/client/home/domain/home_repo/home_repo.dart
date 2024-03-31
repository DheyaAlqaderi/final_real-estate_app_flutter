
import 'package:flutter/foundation.dart';
import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/state/state_model.dart';

import '../../data/models/category/category_model.dart';
import '../../data/remote_api/home_api_service.dart';

class HomeRepository{
  final HomeApiService _homeApiService;
  HomeRepository(this._homeApiService);

  /// get categories
  Future<CategoryModel> getMainCategory({
    required int pageSize,
    required int pageNumber,
    required int parentId}) async{

    try{
      final response = await _homeApiService.getCategories(pageNumber, pageSize, parentId);

      if (kDebugMode) {
        print("main category success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }


  /// get banners
  Future<List<BannerModel>> getBanners(
      ) async{

    try{
      final response = await _homeApiService.getBanners();

      if (kDebugMode) {
        print("Banners success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  /// get banners with specific Categories
  Future<List<BannerModel>> getBannersWithCategory({required int categoryId}) async{
    try{
      final response = await _homeApiService.getBannerWithCategory(categoryId);

      if (kDebugMode) {
        print("Banners with Categories success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }


  /// get high states
  Future<List<StateModel>> getHighStates() async{
    try{
      final response = await _homeApiService.getHighStates();

      if (kDebugMode) {
        print("high state  success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  /// get Featured Property
  Future<PropertyModel> getAllFeaturedProperty({required bool isFeatured}) async{
    try{
      final response = await _homeApiService.getFeaturedProperties(isFeatured);

      if (kDebugMode) {
        print(" Featured Property success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  Future<PropertyModel> getAllFeaturedPropertyWithCategory({required bool isFeatured, required int categoryId}) async{
    try{
      final response = await _homeApiService.getFeaturedPropertiesWithCategory(categoryId, isFeatured);

      if (kDebugMode) {
        print(" Featured Property with category success");
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