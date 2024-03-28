import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';

import 'subCategory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryCubit extends Cubit<SubCategoryState>{
  final HomeRepository _getCategory;

  SubCategoryCubit(this._getCategory) : super(InitSubCategoryState());


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