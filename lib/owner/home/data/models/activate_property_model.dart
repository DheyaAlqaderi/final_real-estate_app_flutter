class ActivatePropertyModel {
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

  ActivatePropertyModel(
      {this.id,
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
        this.category});

  ActivatePropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    name = json['name'];
    description = json['description'];
    price = json['price'];
    size = json['size'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    timeCreated = json['time_created'];
    uniqueNumber = json['unique_number'];
    forSale = json['for_sale'];
    isFeatured = json['is_featured'];
    forRent = json['for_rent'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['size'] = this.size;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['time_created'] = this.timeCreated;
    data['unique_number'] = this.uniqueNumber;
    data['for_sale'] = this.forSale;
    data['is_featured'] = this.isFeatured;
    data['for_rent'] = this.forRent;
    data['category'] = this.category;
    return data;
  }
}

class Address {
  int? id;
  double? longitude;
  double? latitude;
  String? line1;
  String? line2;
  int? state;

  Address(
      {this.id,
        this.longitude,
        this.latitude,
        this.line1,
        this.line2,
        this.state});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    line1 = json['line1'];
    line2 = json['line2'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['state'] = this.state;
    return data;
  }
}