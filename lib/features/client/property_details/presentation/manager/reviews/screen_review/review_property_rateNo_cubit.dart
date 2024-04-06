import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/domain/repo/property_details_repo.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/screen_review/review_property_rateNo_state.dart';

class ReviewsPropertyByRateNoCubit extends Cubit<ReviewsPropertyByRateNoState> {
  final PropertyDetailsRepository _repository;

  ReviewsPropertyByRateNoCubit(this._repository) : super(ReviewsPropertyByRateNoState.loading());

  Future<void> fetchReviewsPropertyByRateNo(int propertyId, int rateReview) async {
    emit(ReviewsPropertyByRateNoState.loading());
    try {
      final reviewModel = await _repository.getReviewsPropertyByRateNo(propertyId, rateReview);
      emit(ReviewsPropertyByRateNoState.loaded(reviewModel));
    } catch (e) {
      emit(ReviewsPropertyByRateNoState.error('Failed to fetch reviews: $e'));
    }
  }
}