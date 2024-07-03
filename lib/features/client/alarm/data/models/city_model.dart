class CityModel {
  int? id;
  String? name;

  CityModel({this.id, this.name});

  // Factory constructor for creating a new `CountryModel` instance from a map.
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
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
