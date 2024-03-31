import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';

import 'high_state_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HighStateCubit extends Cubit<HighStateState>{
  final HomeRepository _getHighStates;

  HighStateCubit(this._getHighStates) : super(InitHighStateState());

  Future<void> getHighStates(
      // {int categoryId = 0}
      ) async {
    // Emit loading state
    emit(LoadingHighStateState());
    try {
      // Perform login operation
      final response = await _getHighStates.getHighStates();
      // Emit success state with response data
      emit(SuccessHighStateState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorHighStateState(e.toString()));
    }
  }

  // Future<void> getBannersWithCategory(
  //     {required int categoryId}
  //     ) async {
  //   // Emit loading state
  //   emit(LoadingBannersState());
  //   try {
  //     // Perform login operation
  //     final response = await _getBanners.getBannersWithCategory(
  //         categoryId: categoryId
  //     );
  //     // Emit success state with response data
  //     emit(SuccessBannersState(response));
  //
  //   } catch (e) {
  //     // Emit error state with error message
  //     emit(ErrorBannersState(e.toString()));
  //   }
  // }
}