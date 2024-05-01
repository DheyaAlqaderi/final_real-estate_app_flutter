class ReviewResponseModel {
  final int id;
  final DateTime timeCreated;
  final String review;
  final double rateReview;
  final int prop;

  ReviewResponseModel({
    required this.id,
    required this.timeCreated,
    required this.review,
    required this.rateReview,
    required this.prop,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      id: json['id'],
      timeCreated: DateTime.parse(json['time_created']),
      review: json['review'],
      rateReview: json['rate_review'].toDouble(),
      prop: json['prop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time_created': timeCreated.toIso8601String(),
      'review': review,
      'rate_review': rateReview,
      'prop': prop,
    };
  }
}
