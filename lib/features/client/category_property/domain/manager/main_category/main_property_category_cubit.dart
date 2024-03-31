import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';
import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';

import 'main_category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPropertyCategoryCubit extends Cubit<MainPropertyCategoryState>{
  final PropertyRepo _getCategory;

  MainPropertyCategoryCubit(this._getCategory) : super(InitMainCategoryState());

  Future<void> getMainCategory({
  int pageSize = 200,
  int pageNumber = 1,
  int parentId = 0}) async {
    // Emit loading state
    emit(LoadingMainCategoryState());
    try {
      // Perform login operation
      final response = await _getCategory.getMainCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          parentId: parentId);
      // Emit success state with response data
      emit(SuccessMainCategoryState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorMainCategoryState(e.toString()));
    }
  }

  Future<void> getSubCategory({
    int pageSize = 200,
    int pageNumber = 1,
    required int parentId }) async {
    // Emit loading state
    emit(LoadingMainCategoryState());
    try {
      // Perform login operation
      final response = await _getCategory.getMainCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          parentId: parentId);
      // Emit success state with response data
      emit(SuccessMainCategoryState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorMainCategoryState(e.toString()));
    }
  }
}