
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/features/client/favorite/data/models/favorite_model.dart';
import '../../../../../core/constant/app_constants.dart';

part 'network.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class FavoriteRepository{
  factory FavoriteRepository(Dio dio, {String baseUrl}) = _FavoriteRepository;

  @GET("api/user/favorite/")
  Future<FavoriteModel> getFavorite(
      @Header("Authorization")String token,
      );
  
  @DELETE("api/user/favorite/{prop_id}/delete/")
  Future<void> deleteFavorite(
      @Header("Authorization")String token,
      @Path("prop_id") int propId
      );

}