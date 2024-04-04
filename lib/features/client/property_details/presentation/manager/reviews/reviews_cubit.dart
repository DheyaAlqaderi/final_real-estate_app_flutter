import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/reviews_state.dart';

import '../../../domain/repo/property_details_repo.dart';

class ReviewsPropertyCubit extends Cubit<ReviewsPropertyState> {
  final PropertyDetailsRepository _repository;

  ReviewsPropertyCubit(this._repository) : super(ReviewsPropertyInitial());

  Future<void> getReviewsProperty(int propertyId) async {
    emit(ReviewsPropertyLoading());
    try {
      final reviewModel = await _repository.getReviewsPropertyById(propertyId);
      emit(ReviewsPropertyLoaded(reviewModel));
    } catch (e) {
      emit(ReviewsPropertyError('Failed to fetch property reviews'));
    }
  }
}
