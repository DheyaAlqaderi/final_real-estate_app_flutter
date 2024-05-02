class Review {
  final String review;
  final double rateReview;
  final int prop;

  Review({
    required this.review,
    required this.rateReview,
    required this.prop,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      review: json['review'],
      rateReview: json['rate_review'],
      prop: json['prop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'rate_review': rateReview,
      'prop': prop,
    };
  }
}