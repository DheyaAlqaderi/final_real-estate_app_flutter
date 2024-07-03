import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/attribute_alarm_repository.dart';
import 'attribute_alarm_cubit_state.dart';

class AttributeAlarmCubit extends Cubit<AttributeAlarmState> {
  final AttributeAlarmRepository repository;

  AttributeAlarmCubit({required this.repository}) : super(AttributeAlarmInitial());

  Future<void> fetchAttributesByCategory({required int categoryId}) async {
    emit(AttributeAlarmLoading());
    try {
      final attributes = await repository.getAttributesByCategory(categoryId);
      emit(AttributeAlarmLoaded(attributes));
    } catch (e) {
      emit(AttributeAlarmFailure(e.toString()));
    }
  }
}
