import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

import '../../../../../core/constant/app_constants.dart';
import 'package:dio/dio.dart';

import '../../../home/data/models/category/category_model.dart';


part 'property_category_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class PropertyCategoryApi{
  factory PropertyCategoryApi(Dio dio, {String baseUrl}) = _PropertyCategoryApi;

  /// categories
  @GET('api/property')
  Future<PropertyModel> getPropertyBySubCategory(
      @Query("page") int page,
      @Query("page_size") int pageSize,
      @Query("category") int category,
      );

  @GET('api/property')
  Future<PropertyModel> getPropertyByMainCategory(
      @Query("page") int page,
      @Query("page_size") int pageSize,
      @Query("main_category") int category,
      );

  @GET('api/property')
  Future<PropertyModel> getPropertyByAllCategory(
      @Query("page") int page,
      @Query("page_size") int pageSize,
      );

  /// categories
  @GET('api/categorie')
  Future<CategoryModel> getCategories(
      @Query("page") int page,
      @Query("page_size") int pageSize,
      @Query("parent") int parent,
      );

}