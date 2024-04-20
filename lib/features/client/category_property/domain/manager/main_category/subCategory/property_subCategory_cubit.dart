import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';

import 'property_subCategory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertySubCategoryCubit extends Cubit<PropertySubCategoryState>{
  final PropertyRepo _getCategory;

  PropertySubCategoryCubit(this._getCategory) : super(InitSubCategoryState());


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