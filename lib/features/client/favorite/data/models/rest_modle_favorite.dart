class FavoriteResult {
  final int? id;
  final PropertyModel? prop;
  final String? timeCreated;

  FavoriteResult({
    this.id,
    this.prop,
    this.timeCreated,
  });

  factory FavoriteResult.fromJson(Map<String, dynamic> json) {
    return FavoriteResult(
      id: json['id'],
      prop: PropertyModel.fromJson(json['prop']),
      timeCreated: json['time_created'],
    );
  }
}

class PropertyModel {
  final int? id;
  final double? rateReview;
  final bool? inFavorite;
  final List<ImageModel>? image;
  final String? address;
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
  final bool? forRent;
  final int? user;
  final int? category;

  PropertyModel({
    this.id,
    this.rateReview,
    this.inFavorite,
    this.image,
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
    this.user,
    this.category,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    var imageList = json['image'] as List<dynamic>;
    List<ImageModel> image = imageList.map((e) => ImageModel.fromJson(e)).toList();

    return PropertyModel(
      id: json['id'],
      rateReview: json['rate_review'],
      inFavorite: json['in_favorite'],
      image: image,
      address: json['address'],
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
      user: json['user'],
      category: json['category'],
    );
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
}
