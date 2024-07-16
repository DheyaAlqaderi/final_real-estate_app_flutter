class PropertyModel {
  final int? count;
  final String? next;
  final String? previous;
  final List<PropertyResult>? results;

  PropertyModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PropertyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PropertyModel(); // Return empty model if JSON is null

    List<PropertyResult>? results;
    if (json['results'] != null) {
      results = List<PropertyResult>.from(
          json['results']!.map((result) => PropertyResult.fromJson(result)));
    }
    return PropertyModel(
      count: json['count'],
      next: json['next'] ,
      previous: json['previous'],
      results: results,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((result) => result.toJson()).toList(),
    };
  }
}

class PropertyResult {
  final int? id;
  final double? rate;
  final bool? inFavorite;
  final List<PropertyImage>? image;
  final String? name;
  final String? description;
  final String? price;
  final int? size;
  final bool? isActive;
  final bool? isDeleted;
  final String? timeCreated;
  final String? uniqueNumber;
  final bool? forSale;
  final bool? isFeatured;
  final int? user;
  final int? category;
  final Map<String, dynamic>? address;

  PropertyResult({
    this.id,
    this.rate,
    this.inFavorite,
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
    this.user,
    this.category,
    this.address,
  });

  factory PropertyResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PropertyResult(); // Return empty result if JSON is null

    List<PropertyImage>? image;
    if (json['image'] != null) {
      image = List<PropertyImage>.from(
          json['image']!.map((img) => PropertyImage.fromJson(img)));
    }
    return PropertyResult(
      id: json['id'] ,
      rate: json['rate_review'] ,
      inFavorite: json['in_favorite'],
      image: image,
      name: json['name'] ,
      description: json['description'] ,
      price: json['price'] ,
      size: json['size'],
      isActive: json['is_active'] ,
      isDeleted: json['is_deleted'] ,
      timeCreated: json['time_created'] ,
      uniqueNumber: json['unique_number'],
      forSale: json['for_sale'] ,
      isFeatured: json['is_featured'] ,
      user: json['user'] ,
      category: json['category'] ,
      address: json['address'] ,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'id': id,
      'rate_review': rate,
      'in_favorite': inFavorite,
      'image': image?.map((img) => img.toJson()).toList(),
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
      'user': user,
      'category': category,
      'address': address,
    };
  }
}

class PropertyImage {
  final String? image;
  final int? id;

  PropertyImage({
    this.image,
    this.id,
  });

  factory PropertyImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PropertyImage(); // Return empty image if JSON is null

    return PropertyImage(
      image: json['image'],
      id: json['id'],
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'image': image,
      'id': id,
    };
  }
}
