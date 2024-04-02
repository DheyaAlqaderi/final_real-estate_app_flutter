
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/property_home_cubit/property_home_state.dart';

class PropertyHomeCubit extends Cubit<PropertyHomeState>{
  final HomeRepository _getProperty;

  PropertyHomeCubit(this._getProperty) : super(InitPropertyHomeState());

  Future<void> getPropertyByMainCategory({
    int pageNumber = 1,
    int pageSize = 200,
    required int mainCategory 
  }) async {
    // Emit loading state
    emit(LoadingPropertyHomeState());
    try {
      // Perform login operation
      final response = await _getProperty.getPropertyByMainCategory(
          pageSize: pageSize,
          pageNumber: pageNumber,
          mainCategory: mainCategory);
      // Emit success state with response data
      emit(SuccessPropertyHomeState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorPropertyHomeState(e.toString()));
    }
  }

  
  Future<void> getPropertyByAllCategory({
    int pageNumber = 1,
    int pageSize = 200
  }) async {
    // Emit loading state
    emit(LoadingPropertyHomeState());
    try {
      // Perform login operation
      final response = await _getProperty.getPropertyByAllCategory(
          pageSize: pageSize,
          pageNumber: pageNumber);
      // Emit success state with response data
      emit(SuccessPropertyHomeState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorPropertyHomeState(e.toString()));
    }
  }
}