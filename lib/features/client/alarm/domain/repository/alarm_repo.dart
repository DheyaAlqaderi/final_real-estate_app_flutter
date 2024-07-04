import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/features/client/alarm/data/remote/alarm_api.dart';

import '../../data/models/alarm_model.dart';


class AlarmRepository {

  static Future<void> addAlarm(String token, Map<String, dynamic> alarmModel) async {
    try {
      final AlarmApi alarmService;
      alarmService = AlarmApi(Dio());
      await alarmService.addAlarm(token, alarmModel);
      Get.snackbar('Success', 'Alarm created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
