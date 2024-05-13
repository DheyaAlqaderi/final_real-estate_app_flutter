class TypesFeedbackModel {
  int? id;
  String? type;

  TypesFeedbackModel({
    this.id,
    this.type,
  });

  factory TypesFeedbackModel.fromJson(Map<String, dynamic> json) {
    return TypesFeedbackModel(
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
