class MyModel {
  final Map<String, dynamic> data;

  MyModel({required this.data});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(data: json);
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}