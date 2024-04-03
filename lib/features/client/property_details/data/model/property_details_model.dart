class PropertyDetailsModel {
  final int? id;
  final List<FeatureProperty>? featureProperty;
  final List<PropertyValue>? propertyValue;
  final double? rate;
  final bool? inFavorite;
  final Address? address;
  final Category? category;
  final User? user;
  final List<ImageModel>? image;
  final String? name;
  final String? description;
  final String? price;
  final double? size;
  final bool? isActive;
  final bool? isDeleted;
  final String? timeCreated;
  final String? uniqueNumber;
  final bool? forSale;
  final bool? isFeatured;

  PropertyDetailsModel({
    this.id,
    this.featureProperty,
    this.propertyValue,
    this.rate,
    this.inFavorite,
    this.address,
    this.category,
    this.user,
    this.image,
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
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsModel(
      id: json['id'],
      featureProperty: (json['feature_property'] as List<dynamic>?)
          ?.map((e) => FeatureProperty.fromJson(e))
          .toList(),
      propertyValue: (json['property_value'] as List<dynamic>?)
          ?.map((e) => PropertyValue.fromJson(e))
          .toList(),
      rate: json['rate']?.toDouble(),
      inFavorite: json['in_favorite'],
      address: json['address'] is String ? Address(line1: json['address']) : Address.fromJson(json['address']),
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList(),
      name: json['name'],
      description: json['description'],
      price: json['price'],
      size: json['size']?.toDouble(),
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      timeCreated: json['time_created'],
      uniqueNumber: json['unique_number'],
      forSale: json['for_sale'],
      isFeatured: json['is_featured'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feature_property': featureProperty?.map((e) => e.toJson()).toList(),
      'property_value': propertyValue?.map((e) => e.toJson()).toList(),
      'rate': rate,
      'in_favorite': inFavorite,
      'address': address?.toJson(),
      'category': category?.toJson(),
      'user': user?.toJson(),
      'image': image?.map((e) => e.toJson()).toList(),
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
    };
  }
}

class FeatureProperty {
  final int? id;
  final Feature? feature;
  final List<ImageModel>? image;
  final int? property;

  FeatureProperty({
    this.id,
    this.feature,
    this.image,
    this.property,
  });

  factory FeatureProperty.fromJson(Map<String, dynamic> json) {
    return FeatureProperty(
      id: json['id'],
      feature: json['feature'] != null ? Feature.fromJson(json['feature']) : null,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList(),
      property: json['property'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feature': feature?.toJson(),
      'image': image?.map((e) => e.toJson()).toList(),
      'property': property,
    };
  }
}

class Feature {
  final int? id;
  final String? name;
  final List<int>? cate;

  Feature({
    this.id,
    this.name,
    this.cate,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      name: json['name'],
      cate: (json['cate'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cate': cate,
    };
  }
}

class PropertyValue {
  final int? id;
  final Value? value;
  final int? property;

  PropertyValue({
    this.id,
    this.value,
    this.property,
  });

  factory PropertyValue.fromJson(Map<String, dynamic> json) {
    return PropertyValue(
      id: json['id'],
      value: json['value'] != null ? Value.fromJson(json['value']) : null,
      property: json['property'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value?.toJson(),
      'property': property,
    };
  }
}

class Value {
  final int? id;
  final Attribute? attribute;
  final String? value;

  Value({
    this.id,
    this.attribute,
    this.value,
  });

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      id: json['id'],
      attribute: json['attribute'] != null ? Attribute.fromJson(json['attribute']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute': attribute?.toJson(),
      'value': value,
    };
  }
}

class Attribute {
  final int? id;
  final String? name;
  final String? dataType;
  final List<int>? category;

  Attribute({
    this.id,
    this.name,
    this.dataType,
    this.category,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      name: json['name'],
      dataType: json['data_type'],
      category: (json['category'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data_type': dataType,
      'category': category,
    };
  }
}

class Address {
  final int? id;
  final State? state;
  final String? longitude;
  final String? latitude;
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

class State {
  final int? id;
  final List<ImageModel>? image;
  final String? name;
  final int? city;

  State({
    this.id,
    this.image,
    this.name,
    this.city,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList(),
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image?.map((e) => e.toJson()).toList(),
      'name': name,
      'city': city,
    };
  }
}

class Category {
  final int? id;
  final List<ImageModel>? image;
  final bool? haveChildren;
  final String? name;
  final int? lft;
  final int? rght;
  final int? treeId;
  final int? level;
  final int? parent;

  Category({
    this.id,
    this.image,
    this.haveChildren,
    this.name,
    this.lft,
    this.rght,
    this.treeId,
    this.level,
    this.parent,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList(),
      haveChildren: json['have_children'],
      name: json['name'],
      lft: json['lft'],
      rght: json['rght'],
      treeId: json['tree_id'],
      level: json['level'],
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image?.map((e) => e.toJson()).toList(),
      'have_children': haveChildren,
      'name': name,
      'lft': lft,
      'rght': rght,
      'tree_id': treeId,
      'level': level,
      'parent': parent,
    };
  }
}

class User {
  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? username;
  final String? name;
  final String? registerData;
  final bool? isActive;
  final String? image;
  final bool? isDeleted;

  User({
    this.id,
    this.email,
    this.phoneNumber,
    this.username,
    this.name,
    this.registerData,
    this.isActive,
    this.image,
    this.isDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      username: json['username'],
      name: json['name'],
      registerData: json['register_data'],
      isActive: json['is_active'],
      image: json['image'],
      isDeleted: json['is_deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'name': name,
      'register_data': registerData,
      'is_active': isActive,
      'image': image,
      'is_deleted': isDeleted,
    };
  }
}

class ImageModel {
  final String? image;
  final int? id;

  ImageModel({
    this.image,
    this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      image: json['image'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'id': id,
    };
  }
}
