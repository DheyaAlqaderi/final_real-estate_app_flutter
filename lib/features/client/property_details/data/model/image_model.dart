class ImageModel2 {
  final String? image;
  final int? id;

  ImageModel2({
    this.image,
    this.id,
  });

  factory ImageModel2.fromJson(Map<String, dynamic> json) {
    return ImageModel2(
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