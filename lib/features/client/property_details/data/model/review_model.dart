class ReviewModel {
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<ReviewResult> results;

  ReviewModel({
    this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List<dynamic>;
    List<ReviewResult> results = resultsList.map((e) => ReviewResult.fromJson(e)).toList();

    return ReviewModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> resultsJsonList = results.map((e) => e.toJson()).toList();

    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': resultsJsonList,
    };
  }
}

class ReviewResult {
  final int? id;
  final String? user;
  final String? timeCreated;
  final String? review;
  final double? rating;
  final String? profile;

  ReviewResult({
    this.id,
    this.user,
    this.timeCreated,
    this.review,
    this.rating,
    this.profile,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> json) {
    return ReviewResult(
      id: json['id'],
      user: json['user'],
      timeCreated: json['time_created'],
      review: json['review'],
      rating: json['rating'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'time_created': timeCreated,
      'review': review,
      'rating': rating,
      'profile': profile,
    };
  }
}
