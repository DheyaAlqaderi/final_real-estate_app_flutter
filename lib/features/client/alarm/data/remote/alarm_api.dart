

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/alarm_model.dart';

part 'alarm_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class AlarmApi{
  factory AlarmApi(Dio dio, {String baseUrl}) = _AlarmApi;

  @POST("api/user/alarms/create")
  Future<void> addAlarm(
      @Header("Authorization")String token,
      @Body() AlarmModel alarmModel
      );

}