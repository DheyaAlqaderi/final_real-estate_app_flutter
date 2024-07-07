class CreatePropertyRequest {
  Map<String, dynamic>? attributeValues;
  Address? address;
  List<FeatureData>? featureData;
  List<ImageData>? imageData;
  String? name;
  String? description;
  String? price;
  int? size;
  bool? isActive;
  bool? isDeleted;
  bool? forSale;
  bool? isFeatured;
  bool? forRent;
  int? category;

  CreatePropertyRequest({
    this.attributeValues,
    this.address,
    this.featureData,
    this.imageData,
    this.name,
    this.description,
    this.price,
    this.size,
    this.isActive,
    this.isDeleted,
    this.forSale,
    this.isFeatured,
    this.forRent,
    this.category,
  });

  factory CreatePropertyRequest.fromJson(Map<String, dynamic> json) {
    return CreatePropertyRequest(
      attributeValues: json['attribute_values'] != null ? Map<String, dynamic>.from(json['attribute_values']) : null,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      featureData: json['feature_data'] != null
          ? (json['feature_data'] as List).map((i) => FeatureData.fromJson(i)).toList()
          : null,
      imageData: json['image_data'] != null
          ? (json['image_data'] as List).map((i) => ImageData.fromJson(i)).toList()
          : null,
      name: json['name'],
      description: json['description'],
      price: json['price'],
      size: json['size'],
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      forSale: json['for_sale'],
      isFeatured: json['is_featured'],
      forRent: json['for_rent'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_values': attributeValues,
      'address': address?.toJson(),
      'feature_data': featureData?.map((i) => i.toJson()).toList(),
      'image_data': imageData?.map((i) => i.toJson()).toList(),
      'name': name,
      'description': description,
      'price': price,
      'size': size,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'for_sale': forSale,
      'is_featured': isFeatured,
      'for_rent': forRent,
      'category': category,
    };
  }
}

class Address {
  int? longitude;
  int? latitude;
  String? line1;
  String? line2;
  int? state;

  Address({
    this.longitude,
    this.latitude,
    this.line1,
    this.line2,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      longitude: json['longitude'],
      latitude: json['latitude'],
      line1: json['line1'],
      line2: json['line2'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'line1': line1,
      'line2': line2,
      'state': state,
    };
  }
}

class FeatureData {
  int? id;
  List<ImageData>? images;

  FeatureData({
    this.id,
    this.images,
  });

  factory FeatureData.fromJson(Map<String, dynamic> json) {
    return FeatureData(
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images?.map((i) => i.toJson()).toList(),
    };
  }
}

class ImageData {
  String? image;

  ImageData({this.image});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
    };
  }
}
