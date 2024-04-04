import '../../../data/model/review_model.dart';

abstract class ReviewsPropertyState {}

class ReviewsPropertyInitial extends ReviewsPropertyState {}

class ReviewsPropertyLoading extends ReviewsPropertyState {}

class ReviewsPropertyLoaded extends ReviewsPropertyState {
  final ReviewModel reviewModel;

  ReviewsPropertyLoaded(this.reviewModel);
}

class ReviewsPropertyError extends ReviewsPropertyState {
  final String message;

  ReviewsPropertyError(this.message);
}
