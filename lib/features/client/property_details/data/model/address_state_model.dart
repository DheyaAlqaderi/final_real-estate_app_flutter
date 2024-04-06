
import 'package:smart_real_estate/features/client/property_details/data/model/property_details_model.dart';

class Address {
  final int? id;
  final State? state;
  final double? longitude;
  final double? latitude;
  final String? line1;
  final String? line2;

  Address({
    this.id,
    this.state,
    this.longitude,
    this.latitude,
    this.line1,
    this.line2,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      state: json['state'] != null ? State.fromJson(json['state']) : null,
      longitude: json['longitude'],
      latitude: json['latitude'],
      line1: json['line1'],
      line2: json['line2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state?.toJson(),
      'longitude': longitude,
      'latitude': latitude,
      'line1': line1,
      'line2': line2,
    };
  }
}

