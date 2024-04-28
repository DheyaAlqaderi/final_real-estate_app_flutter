

import 'package:smart_real_estate/features/client/favorite/data/models/rest_modle_favorite.dart';

class FavoriteModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  FavoriteModel({this.count, this.next, this.previous, this.results});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  Prop? prop;
  String? timeCreated;

  Results({this.id, this.prop, this.timeCreated});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prop = json['prop'] != null ? Prop.fromJson(json['prop']) : null;
    timeCreated = json['time_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (prop != null) {
      data['prop'] = prop!.toJson();
    }
    data['time_created'] = timeCreated;
    return data;
  }
}


