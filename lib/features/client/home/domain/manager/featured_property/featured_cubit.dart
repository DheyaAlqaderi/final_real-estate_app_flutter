import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';

import 'featured_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedCubit extends Cubit<FeaturedState>{
  final HomeRepository _getFeaturedProperties;

  FeaturedCubit(this._getFeaturedProperties) : super(InitFeaturedState());

  Future<void> getFeatured(
      {bool isFeatured = true}
      ) async {
    // Emit loading state
    emit(LoadingFeaturedState());
    try {
      // Perform login operation
      final response = await _getFeaturedProperties
          .getAllFeaturedProperty(isFeatured: isFeatured);
      // Emit success state with response data
      emit(SuccessFeaturedState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorFeaturedState(e.toString()));
    }
  }

  Future<void> getFeaturedWithCategory(
      {
        required int categoryId,
        bool isFeatured = true,
      }
      ) async {
    // Emit loading state
    emit(LoadingFeaturedState());
    try {
      // Perform login operation
      final response = await _getFeaturedProperties
          .getAllFeaturedPropertyWithCategory(
          isFeatured: isFeatured,
          categoryId: categoryId
      );
      // Emit success state with response data
      emit(SuccessFeaturedState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorFeaturedState(e.toString()));
    }
  }
}