
import '../../../data/models/response_create_alarm.dart';

abstract class CreateAlarmState {}

class CreateAlarmInitial extends CreateAlarmState {}

class CreateAlarmLoading extends CreateAlarmState {}

class CreateAlarmSuccess extends CreateAlarmState {
  ResponseCreateAlarm responseCreateAlarm;
  CreateAlarmSuccess(this.responseCreateAlarm);
}

class CreateAlarmFailure extends CreateAlarmState {
  final String error;
  CreateAlarmFailure(this.error);
}
