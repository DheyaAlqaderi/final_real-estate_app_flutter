import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';

import 'banners_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannersCubit extends Cubit<BannersState>{
  final HomeRepository _getBanners;


  BannersCubit(this._getBanners) : super(InitBannersState());

  Future<void> getBanners() async {
    // Emit loading state
    emit(LoadingBannersState());
    try {
      // Perform login operation
      final response = await _getBanners.getBanners();
      // Emit success state with response data
      emit(SuccessBannersState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorBannersState(e.toString()));
    }
  }

  Future<void> getBannersWithCategory({required int categoryId}) async {
    // Emit loading state
    emit(LoadingBannersState());
    try {
      // Perform login operation
      final response = await _getBanners.getBannersWithCategory(
          categoryId: categoryId
      );
      // Emit success state with response data
      emit(SuccessBannersState(response));

    } catch (e) {
      // Emit error state with error message
      emit(ErrorBannersState(e.toString()));
    }
  }
}