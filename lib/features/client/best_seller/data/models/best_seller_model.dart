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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['username'] = this.username;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['property_count'] = this.propertyCount;
    data['user_type'] = this.userType;
    data['rate_review'] = this.rateReview;
    return data;
  }
}
