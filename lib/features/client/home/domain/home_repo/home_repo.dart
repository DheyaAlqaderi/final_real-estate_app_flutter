
import 'package:flutter/foundation.dart';
import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/state/state_model.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
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
  Future<List<BannerModel>> getBanners() async{

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
  Future<List<StateModel>> getHighStates({required int mainCategory}) async{
    try{
      final response = await _homeApiService.getHighStates(mainCategory);

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
  Future<PropertyModel> getAllFeaturedProperty({required bool isFeatured, bool isActive = true}) async{
    try{
      var mToken = await _loadToken();
      String token = mToken.toString();
      final response = await _homeApiService.getFeaturedProperties(isFeatured, token, isActive);

      if (kDebugMode) {
        print(" Featured Property success $token");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  Future<PropertyModel> getAllFeaturedPropertyWithCategory({required bool isFeatured, required int categoryId, bool isActive = true}) async{
    try{
      var mToken = await _loadToken();
      String token = mToken.toString();
      final response = await _homeApiService.getFeaturedPropertiesWithCategory(categoryId, isFeatured, token,isActive);

      if (kDebugMode) {
        print(" Featured Property with category success $token");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }



  /// get properties by main categories id
  Future<PropertyModel> getPropertyByMainCategory({
    required int pageSize,
    required int pageNumber,
    required int mainCategory,
    bool isActive = true
  }) async{

    try{
      var mToken = await _loadToken();
      String token = mToken.toString();
      final response = await _homeApiService.getPropertyByMainCategory(
          pageNumber, pageSize, mainCategory, token, isActive);

      if (kDebugMode) {
        print("home mainCategory property success $token");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  /// get properties by all Category
  Future<PropertyModel> getPropertyByAllCategory({
    required int pageSize,
    required int pageNumber,
    bool isActive = true
  }) async {
    try {
      String token = await _loadToken();
      final response = await _homeApiService.getPropertyByAllCategory(
        pageNumber,
        pageSize,
        token,
        isActive
      );

      if (kDebugMode) {
        print("home All Category properties success with token: $token");
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error in getPropertyByAllCategory: $e");
      }
      throw Exception("Failed to get properties: $e");
    }
  }

  Future<String> _loadToken() async {
    await SharedPrefManager.init();
    String? loadedToken = await SharedPrefManager.getData(AppConstants.token);
    if (loadedToken == null || loadedToken.isEmpty) {
      return " ";
    }
    return "token $loadedToken";
  }



}