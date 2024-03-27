
class BannerModel{
  final int bannerId;
  final String imageUrl;
  final String title;
  final String description;

  BannerModel({
    required this.bannerId,
    required this.imageUrl,
    required this.title,
    required this.description});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['banner_id'],
      imageUrl: json['image'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
    };
  }
}