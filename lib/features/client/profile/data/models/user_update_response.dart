class UserUpdateResponse {
  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? username;
  final String? name;
  final String? registerData;
  final String? image;
  final String? userType;

  UserUpdateResponse({
    this.id,
    this.email,
    this.phoneNumber,
    this.username,
    this.name,
    this.registerData,
    this.image,
    this.userType,
  });

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserUpdateResponse(
      id: json['id'] as int?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      registerData: json['register_data'] as String?,
      image: json['image'] as String?,
      userType: json['user_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'name': name,
      'register_data': registerData,
      'image': image,
      'user_type': userType,
    };
  }
}
