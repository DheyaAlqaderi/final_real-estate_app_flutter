class ProfileModel {
  int? id;
  String? email;
  String? phoneNumber;
  String? username;
  String? name;
  String? registerData;
  String? image;
  String? userType;
  int? countReview;
  double? reting;
  int? soldProperty;
  int? propertyCount;

  ProfileModel(
      {this.id,
        this.email,
        this.phoneNumber,
        this.username,
        this.name,
        this.registerData,
        this.image,
        this.userType,
        this.countReview,
        this.reting,
        this.soldProperty,
        this.propertyCount});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    username = json['username'];
    name = json['name'];
    registerData = json['register_data'];
    image = json['image'];
    userType = json['user_type'];
    countReview = json['count_review'];
    reting = json['reting'];
    soldProperty = json['sold_property'];
    propertyCount = json['property_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['username'] = username;
    data['name'] = name;
    data['register_data'] = registerData;
    data['image'] = image;
    data['user_type'] = userType;
    data['count_review'] = countReview;
    data['reting'] = reting;
    data['sold_property'] = soldProperty;
    data['property_count'] = propertyCount;
    return data;
  }
}