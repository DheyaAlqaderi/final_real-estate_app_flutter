
import 'package:flutter/foundation.dart';
import 'package:smart_real_estate/features/client/category_property/data/remote_api/property_category_api.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

import '../../../home/data/models/category/category_model.dart';

class PropertyRepo{
  final PropertyCategoryApi _propertyCategoryApi;
  PropertyRepo(this._propertyCategoryApi);

  /// get properties by main categories id
  Future<PropertyModel> getPropertyByMainCategory({
    required int pageSize,
    required int pageNumber,
    required int mainCategory}) async{

    try{
      final response = await _propertyCategoryApi.getPropertyByMainCategory(
          pageNumber, pageSize, mainCategory);

      if (kDebugMode) {
        print("mainCategory property success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }


  /// get properties by main Category id
  Future<PropertyModel> getPropertyBySubCategory({
    required int pageSize,
    required int pageNumber,
    required int subCategory}) async{

    try{
      final response = await _propertyCategoryApi.getPropertyBySubCategory(
          pageNumber,
          pageSize, subCategory);

      if (kDebugMode) {
        print("subCategory property success");
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
    }) async{

    try{
      final response = await _propertyCategoryApi.getPropertyByAllCategory(
          pageNumber,
          pageSize);

      if (kDebugMode) {
        print("All Category properties success");
      }
      return response;
    } catch(e){
      if (kDebugMode) {
        print("error ${e.hashCode}");
      }
      throw Exception("$e");
    }
  }

  /// get categories
  Future<CategoryModel> getMainCategory({
    required int pageSize,
    required int pageNumber,
    required int parentId}) async{

    try{
      final response = await _propertyCategoryApi.getCategories(pageNumber, pageSize, parentId);

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

}