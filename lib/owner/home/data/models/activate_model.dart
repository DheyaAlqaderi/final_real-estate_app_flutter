class ActivateModel {
  bool? isActive;

  ActivateModel({this.isActive});

  factory ActivateModel.fromJson(Map<String, dynamic> json) {
    return ActivateModel(
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
    };
  }
}