class StateModel {
  final int? id;
  final String? name;
  final int? city;

  StateModel({
    required this.id,
    required this.name,
    required this.city,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
    };
  }
}
