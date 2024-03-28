
class BannerModel {
  final int? id;
  final String? time_created;
  final String? end_time;
  final String? start_time;
  final String? title;
  final String? description;
  final String? image;
  final bool? is_active;
  final int? category;

  BannerModel({
    required this.id,
    required this.time_created,
    required this.end_time,
    required this.start_time,
    required this.title,
    required this.description,
    required this.image,
    required this.is_active,
    required this.category,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      time_created: json['time_created'] ?? '',
      end_time: json['end_time'] ?? '',
      start_time: json['start_time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      is_active: json['is_active'] ?? false,
      category: json['category'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time_created': time_created,
      'end_time': end_time,
      'start_time': start_time,
      'title': title,
      'description': description,
      'image': image,
      'is_active': is_active,
      'category': category,
    };
  }
}
