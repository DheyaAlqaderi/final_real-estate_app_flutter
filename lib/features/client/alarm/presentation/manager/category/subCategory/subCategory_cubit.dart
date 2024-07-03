

import 'package:smart_real_estate/features/client/alarm/domain/repository/category_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/subCategory/subCategory_state.dart';

class SubCategoryAlarmCubit extends Cubit<SubCategoryAlarmCubitState>{
  final CategoryAlarmRepository _getCategory;

  SubCategoryAlarmCubit(this._getCategory) : super(InitSubCategoryState());


  Future<void> getSubCategory({
    int pageSize = 200,
    int pageNumber = 1,
    required int parentId }) async {
    // Emit loading state
    emit(LoadingSubCategoryState());
    try {
      // Perform login operation
      final response = await _getCategory.getMainCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          parentId: parentId);
      // Emit success state with response data
      emit(SuccessSubCategoryState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorSubCategoryState(e.toString()));
    }
  }
}