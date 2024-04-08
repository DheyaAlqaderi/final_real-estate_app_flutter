class ProfileUserModel {
  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? username;
  final String? name;
  final String? registerDate;
  final String? image;
  final String? userType;
  final int? countReview;
  final double? rating;
  final int? soldProperty;
  final int? propertyCount;

  ProfileUserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.username,
    this.name,
    this.registerDate,
    this.image,
    this.userType,
    this.countReview,
    this.rating,
    this.soldProperty,
    this.propertyCount,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileUserModel(); // Return empty model if JSON is null

    return ProfileUserModel(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      username: json['username'],
      name: json['name'],
      registerDate: json['register_data'],
      image: json['image'],
      userType: json['user_type'],
      countReview: json['count_review'],
      rating: json['reting']?.toDouble(),
      soldProperty: json['sold_property'],
      propertyCount: json['property_count'],
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'name': name,
      'register_data': registerDate,
      'image': image,
      'user_type': userType,
      'count_review': countReview,
      'reting': rating,
      'sold_property': soldProperty,
      'property_count': propertyCount,
    };
  }
}
