import 'package:smart_real_estate/features/client/category_property/domain/manager/property_cubit/property_state.dart';
import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyCubit extends Cubit<PropertyState>{
  final PropertyRepo _getProperty;

  PropertyCubit(this._getProperty) : super(InitPropertyState());

  Future<void> getPropertyByMainCategory({
    int pageNumber = 1,
    int pageSize = 200,
    required int mainCategory 
  }) async {
    // Emit loading state
    emit(LoadingPropertyState());
    try {
      // Perform login operation
      final response = await _getProperty.getPropertyByMainCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          mainCategory: mainCategory);
      // Emit success state with response data
      emit(SuccessPropertyState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorPropertyState(e.toString()));
    }
  }

  Future<void> getPropertyBySubCategory({
    int pageNumber = 1,
    int pageSize = 200,
    required int subCategory
  }) async {
    // Emit loading state
    emit(LoadingPropertyState());
    try {
      // Perform login operation
      final response = await _getProperty.getPropertyBySubCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          subCategory: subCategory);
      // Emit success state with response data
      emit(SuccessPropertyState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorPropertyState(e.toString()));
    }
  }
}