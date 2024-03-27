import 'package:retrofit/retrofit.dart';

import '../../../../../core/constant/app_constants.dart';
import 'package:dio/dio.dart';

import '../models/category/category_model.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class HomeApiService{
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET('/api/categorie')
  Future<CategoryModel> getMainCategories();

}