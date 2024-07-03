

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/category_repository.dart';

import 'category_cubit_state.dart';

class CategoryAlarmCubit extends Cubit<CategoryAlarmState> {
  final CategoryAlarmRepository repository;

  CategoryAlarmCubit({required this.repository}) : super(CategoryAlarmInitial());

  Future<void> fetchMainCategory({int pageSize = 200,int pageNumber = 1, int parentId = 0}) async {
    emit(CategoryAlarmLoading());
    try {
      final category = await repository.getMainCategory(
        pageSize: pageSize,
        pageNumber: pageNumber,
        parentId: parentId,
      );
      emit(CategoryAlarmLoaded(category));
    } catch (e) {
      emit(CategoryAlarmFailure(e.toString()));
    }
  }
}
