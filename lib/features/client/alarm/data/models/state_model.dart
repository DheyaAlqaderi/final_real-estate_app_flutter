class StateModel {
  int? id;
  String? name;

  StateModel({this.id, this.name});

  // Factory constructor for creating a new `CountryModel` instance from a map.
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method for converting a `CountryModel` instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
