

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/alarm_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/attribute_alarm_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/city_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/country_model.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/response_create_alarm.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/state_model.dart';

import '../../../home/data/models/category/category_model.dart';

part 'alarm_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class AlarmApi{
  factory AlarmApi(Dio dio, {String baseUrl}) = _AlarmApi;


  /// create an alarm
  @POST("api/user/alarms/create")
  Future<ResponseCreateAlarm> addAlarm(
      @Header("Authorization") String token,
      @Body() AlarmModel alarmModel
      );

  /// get countries
  @GET("api/address/country/")
  Future<List<CountryModel>> getCountries();
  
  /// get cities
  @GET("api/address/city/")
  Future<List<CityModel>> getCities(
      @Query("country") int countryId
      );
  
  /// get states
  @GET("api/address/state/")
  Future<List<StateModel>> getStates(
      @Query("city") int cityId
      );

  /// get main categories and sub categories
  @GET('api/categorie')
  Future<CategoryModel> getCategories(
      @Query("page") int page,
      @Query("page_size") int pageSize,
      @Query("parent") int parent,
      );

  /// get attributes by category id
  @GET('api/categorie/attributes/')
  Future<List<AttributesAlarmModel>> getAttributesByCategoryId(
      @Query("category") int categoryId
      );

}