class CreatePropertyResponse {
  int? id;
  Address? address;
  String? name;
  String? description;
  String? price;
  int? size;
  bool? isActive;
  bool? isDeleted;
  String? timeCreated;
  String? uniqueNumber;
  bool? forSale;
  bool? isFeatured;
  bool? forRent;
  int? category;

  CreatePropertyResponse({
    this.id,
    this.address,
    this.name,
    this.description,
    this.price,
    this.size,
    this.isActive,
    this.isDeleted,
    this.timeCreated,
    this.uniqueNumber,
    this.forSale,
    this.isFeatured,
    this.forRent,
    this.category,
  });

  factory CreatePropertyResponse.fromJson(Map<String, dynamic> json) {
    return CreatePropertyResponse(
      id: json['id'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      name: json['name'],
      description: json['description'],
      price: json['price'],
      size: json['size'],
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      timeCreated: json['time_created'],
      uniqueNumber: json['unique_number'],
      forSale: json['for_sale'],
      isFeatured: json['is_featured'],
      forRent: json['for_rent'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address?.toJson(),
      'name': name,
      'description': description,
      'price': price,
      'size': size,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'time_created': timeCreated,
      'unique_number': uniqueNumber,
      'for_sale': forSale,
      'is_featured': isFeatured,
      'for_rent': forRent,
      'category': category,
    };
  }
}

class Address {
  int? id;
  double? longitude;
  double? latitude;
  String? line1;
  String? line2;
  int? state;

  Address({
    this.id,
    this.longitude,
    this.latitude,
    this.line1,
    this.line2,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      line1: json['line1'],
      line2: json['line2'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'line1': line1,
      'line2': line2,
      'state': state,
    };
  }
}
