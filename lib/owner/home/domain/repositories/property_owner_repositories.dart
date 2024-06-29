import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../features/client/favorite/data/models/rest_modle_favorite.dart';

//part 'property_details_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class OwnerPropertyRepostry{
  //factory OwnerPropertyRepostry(Dio dio, {String baseUrl}) = _OwnerPropertyRepostry;

  @GET('api/property/')
  Future<PropertyModel> getPropertyOwnerByUserId(
      @Query("user") int userId,
      );
}