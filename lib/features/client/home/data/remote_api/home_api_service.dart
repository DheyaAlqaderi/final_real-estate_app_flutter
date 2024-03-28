import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';

import '../../../../../core/constant/app_constants.dart';
import 'package:dio/dio.dart';

import '../models/category/category_model.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class HomeApiService{
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET('api/categorie')
  Future<CategoryModel> getCategories(
    @Query("page") int page,
    @Query("page_size") int pageSize,
    @Query("parent") int parent,
  );

  @GET('api/banners')
  Future<List<BannerModel>> getBanners();

}