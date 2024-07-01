class BestSellerModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  BestSellerModel({this.count, this.next, this.previous, this.results});

  BestSellerModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = [];
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
  String? email;
  String? phoneNumber;
  String? username;
  String? name;
  bool? isActive;
  String? image;
  int? propertyCount;
  String? userType;
  double? rateReview;

  Results(
      {this.id,
        this.email,
        this.phoneNumber,
        this.username,
        this.name,
        this.isActive,
        this.image,
        this.propertyCount,
        this.userType,
        this.rateReview});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    username = json['username'];
    name = json['name'];
    isActive = json['is_active'];
    image = json['image'];
    propertyCount = json['property_count'];
    userType = json['user_type'];
    rateReview = json['rate_review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['username'] = username;
    data['name'] = name;
    data['is_active'] = isActive;
    data['image'] = image;
    data['property_count'] = propertyCount;
    data['user_type'] = userType;
    data['rate_review'] = rateReview;
    return data;
  }
}
