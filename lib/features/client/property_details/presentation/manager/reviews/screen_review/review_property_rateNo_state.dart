import '../../../../data/model/review_model.dart';

enum ReviewsPropertyByRateNoStatus { loading, loaded, error }

class ReviewsPropertyByRateNoState {
  final ReviewsPropertyByRateNoStatus status;
  final ReviewModel? reviewModel;
  final String? error;

  ReviewsPropertyByRateNoState({
    required this.status,
    this.reviewModel,
    this.error,
  });

  factory ReviewsPropertyByRateNoState.loading() =>
      ReviewsPropertyByRateNoState(status: ReviewsPropertyByRateNoStatus.loading);

  factory ReviewsPropertyByRateNoState.loaded(ReviewModel reviewModel) =>
      ReviewsPropertyByRateNoState(status: ReviewsPropertyByRateNoStatus.loaded, reviewModel: reviewModel);

  factory ReviewsPropertyByRateNoState.error(String error) =>
      ReviewsPropertyByRateNoState(status: ReviewsPropertyByRateNoStatus.error, error: error);
}
