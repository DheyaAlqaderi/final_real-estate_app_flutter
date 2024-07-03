

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/alarm_model.dart';
import '../../../domain/repository/create_alarm_repo.dart';
import 'create_alarm_cubit_state.dart';

class CreateAlarmCubit extends Cubit<CreateAlarmState> {
  final CreateAlarmRepository repository;

  CreateAlarmCubit({required this.repository}) : super(CreateAlarmInitial());

  Future<void> createAlarm(String token, AlarmModel alarmModel) async {
    emit(CreateAlarmLoading());
    try {
      final response = await repository.createAlarm(token, alarmModel);
      emit(CreateAlarmSuccess(response));
    } catch (e) {
      emit(CreateAlarmFailure(e.toString()));
    }
  }
}
