
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/features/client/best_seller/data/models/best_seller_model.dart';
import '../../../../../core/constant/app_constants.dart';

part 'best_seller_repository.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)

abstract class BestSellerRepository{
  factory BestSellerRepository(Dio dio ,{String baseUrl}) = _BestSellerRepository;

  @GET("api/property/bast-seller/")
  Future<BestSellerModel> getFavorite();

}

