
import 'package:smart_real_estate/features/client/favorite/data/models/rest_modle_favorite.dart';

class FavoriteModel {
  final int? count;
  final String? next;
  final String? previous;
  final List<FavoriteResult>? results;

  FavoriteModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List<dynamic>;
    List<FavoriteResult> results = resultsList.map((e) => FavoriteResult.fromJson(e)).toList();

    return FavoriteModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: results,
    );
  }
}

