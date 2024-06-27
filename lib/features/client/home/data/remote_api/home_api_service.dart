import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/home/data/models/state/state_model.dart';

import '../../../../../core/constant/app_constants.dart';
import 'package:dio/dio.dart';

import '../models/category/category_model.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class HomeApiService{
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  /// categories
  @GET('api/categorie')
  Future<CategoryModel> getCategories(
    @Query("page") int page,
    @Query("page_size") int pageSize,
    @Query("parent") int parent,
  );



  /// banners
  @GET('api/banners')
  Future<List<BannerModel>> getBanners();

  @GET('api/banners')
  Future<List<BannerModel>> getBannerWithCategory(
      @Query("category") int categoryId,
      );



  /// feature property
  @GET('api/property')
  Future<PropertyModel> getFeaturedProperties(
      @Query("is_featured") bool isFeatured,
      );

  @GET('api/property')
  Future<PropertyModel> getFeaturedPropertiesWithCategory(
      @Query("main_category") int categoryId,
      @Query("is_featured") bool isFeatured,
      );


  /// get states address
  @GET('api/address/state')
  Future<List<StateModel>> getHighStates(
      @Query("main_category") int mainCategory
      );



  /// get properties
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
}