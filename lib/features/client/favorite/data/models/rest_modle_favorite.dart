
class Image {
  String? image;
  int? id;

  Image({this.image, this.id});

  Image.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['id'] = id;
    return data;
  }
}
//
// class Address {
//   int? id;
//   State? state;
//   int? longitude;
//   int? latitude;
//   String? line1;
//   String? line2;
//
//   Address(
//       {this.id,
//         this.state,
//         this.longitude,
//         this.latitude,
//         this.line1,
//         this.line2});
//
//   Address.fromJson(Map<dynamic, dynamic> json) {
//     id = json['id'];
//     state = json['state'] != null ? State.fromJson(json['state']) : null;
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//     line1 = json['line1'];
//     line2 = json['line2'];
//   }
//
//   Map<dynamic, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     if (state != null) {
//       data['state'] = state!.toJson();
//     }
//     data['longitude'] = longitude;
//     data['latitude'] = latitude;
//     data['line1'] = line1;
//     data['line2'] = line2;
//     return data;
//   }
// }
//
// class State {
//   int? id;
//   List<Image>? image;
//   String? name;
//   int? city;
//
//   State({this.id, this.image, this.name, this.city});
//
//   State.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     if (json['image'] != null) {
//       image = <Image>[];
//       json['image'].forEach((v) {
//         image!.add(Image.fromJson(v));
//       });
//     }
//     name = json['name'];
//     city = json['city'];
//   }
//
//   Map<dynamic, dynamic> toJson() {
//     final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
//     data['id'] = id;
//     if (image != null) {
//       data['image'] = image!.map((v) => v.toJson()).toList();
//     }
//     data['name'] = name;
//     data['city'] = city;
//     return data;
//   }
// }
//

class Prop {
  int? id;
  double? rateReview;
  // bool? inFavorite;
  List<Image>? image;
  // Address? address;
  String? name;
  // String? description;
  String? price;
  // int? size;
  // bool? isActive;
  // bool? isDeleted;
  // String? timeCreated;
  // String? uniqueNumber;
  // bool? forSale;
  // bool? isFeatured;
  // bool? forRent;
  // int? user;
  // int? category;

  Prop(
      {this.id,
        this.rateReview,
        // this.inFavorite,
        this.image,
        // this.address,
        this.name,
        // this.description,
        this.price,
        // this.size,
        // this.isActive,
        // this.isDeleted,
        // this.timeCreated,
        // this.uniqueNumber,
        // this.forSale,
        // this.isFeatured,
        // this.forRent,
        // this.user,
        // this.category
      });

  Prop.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    rateReview = json['rate_review'];
    // inFavorite = json['in_favorite'];
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image!.add(Image.fromJson(v));
      });
    }
    // address =
    // json['address'] != null ? Address.fromJson(json['address']) : null;
    name = json['name'];
    // description = json['description'];
    price = json['price'];
    // size = json['size'];
    // isActive = json['is_active'];
    // isDeleted = json['is_deleted'];
    // timeCreated = json['time_created'];
    // uniqueNumber = json['unique_number'];
    // forSale = json['for_sale'];
    // isFeatured = json['is_featured'];
    // forRent = json['for_rent'];
    // user = json['user'];
    // category = json['category'];
  }

  Map<dynamic, dynamic>? toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['rate_review'] = rateReview;
    // data['in_favorite'] = inFavorite;
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    // if (address != null) {
    //   data['address'] = address!.toJson();
    // }
    data['name'] = name;
    // data['description'] = description;
    data['price'] = price;
    // data['size'] = size;
    // data['is_active'] = isActive;
    // data['is_deleted'] = isDeleted;
    // data['time_created'] = timeCreated;
    // data['unique_number'] = uniqueNumber;
    // data['for_sale'] = forSale;
    // data['is_featured'] = isFeatured;
    // data['for_rent'] = forRent;
    // data['user'] = user;
    // data['category'] = category;
    return data;
  }
}