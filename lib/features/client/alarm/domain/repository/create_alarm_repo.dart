

import '../../data/models/alarm_model.dart';
import '../../data/models/response_create_alarm.dart';
import '../../data/remote/alarm_api.dart';

class CreateAlarmRepository {
  final AlarmApi alarmApi;

  CreateAlarmRepository({required this.alarmApi});

  Future<ResponseCreateAlarm> createAlarm(String token, AlarmModel alarmModel) async {
    try {
      final response = await alarmApi.addAlarm(token, alarmModel);
      return response;
    } catch (e) {
      throw Exception('Failed to create alarm: $e');
    }
  }
}
