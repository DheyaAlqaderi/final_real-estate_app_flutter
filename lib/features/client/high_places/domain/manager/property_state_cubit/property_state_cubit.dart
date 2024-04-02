
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/high_places/domain/high_places_repo/high_places_repo.dart';
import 'package:smart_real_estate/features/client/high_places/domain/manager/property_state_cubit/property_state_state.dart';

class PropertyStateCubit extends Cubit<PropertyStateState>{
  final HighPlacesRepo _getProperty;

  PropertyStateCubit(this._getProperty) : super(InitPropertyStateState());

  Future<void> getPropertyByState({
    int pageNumber = 1,
    int pageSize = 200,
    required int stateId
  }) async {
    // Emit loading state
    emit(LoadingPropertyStateState());
    try {
      // Perform login operation
      final response = await _getProperty.getPropertyByState(
          pageSize: pageSize,
          pageNumber: pageNumber,
          stateId: stateId);
      // Emit success state with response data
      emit(SuccessPropertyStateState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorPropertyStateState(e.toString()));
    }
  }


  // Future<void> getPropertyByAllCategory({
  //   int pageNumber = 1,
  //   int pageSize = 200
  // }) async {
  //   // Emit loading state
  //   emit(LoadingPropertyHomeState());
  //   try {
  //     // Perform login operation
  //     final response = await _getProperty.getPropertyByAllCategory(
  //         pageSize: pageSize,
  //         pageNumber: pageNumber);
  //     // Emit success state with response data
  //     emit(SuccessPropertyHomeState(response));
  //
  //   } catch (e) {
  //     // Emit error state with error message
  //     emit(ErrorPropertyHomeState(e.toString()));
  //   }
  // }
}