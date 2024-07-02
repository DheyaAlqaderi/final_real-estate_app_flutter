import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../home/data/models/property/property_model.dart';

part 'high_state_api.g.dart'; //  this line

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class HighStateApi{
  factory HighStateApi(Dio dio, {String baseUrl}) = _HighStateApi;


  /// get properties by state id
  @GET('api/property/by-state')
  Future<PropertyModel> getPropertyByState(
      @Query("page") int propertyId,
      @Query("page_size") int pageSize,
      @Query("state") int state,
      @Header("Authorization") String token
      );
}