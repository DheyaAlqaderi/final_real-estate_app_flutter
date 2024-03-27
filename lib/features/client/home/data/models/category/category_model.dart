class CategoryModel {
  final int count;
  final String next;
  final String previous;
  final List<Category> results;

  CategoryModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List<dynamic>;
    List<Category> categories =
    resultsList.map((e) => Category.fromJson(e)).toList();

    return CategoryModel(
      count: json['count'] as int,
      next: json['next'] as String,
      previous: json['previous'] as String,
      results: categories,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'next': next,
    'previous': previous,
    'results': results.map((category) => category.toJson()).toList(),
  };
}

class Category {
  final int id;
  final List<CategoryImage> image;
  final bool have_children;
  final String name;
  final int lft;
  final int rght;
  final int tree_id;
  final int level;
  final dynamic parent;

  Category({
    required this.id,
    required this.image,
    required this.have_children,
    required this.name,
    required this.lft,
    required this.rght,
    required this.tree_id,
    required this.level,
    required this.parent,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var imagesList = json['image'] as List<dynamic>;
    List<CategoryImage> images =
    imagesList.map((e) => CategoryImage.fromJson(e)).toList();

    return Category(
      id: json['id'] as int,
      image: images,
      have_children: json['have_children'] as bool,
      name: json['name'] as String,
      lft: json['lft'] as int,
      rght: json['rght'] as int,
      tree_id: json['tree_id'] as int,
      level: json['level'] as int,
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image.map((image) => image.toJson()).toList(),
    'have_children': have_children,
    'name': name,
    'lft': lft,
    'rght': rght,
    'tree_id': tree_id,
    'level': level,
    'parent': parent,
  };
}

class CategoryImage {
  final String image;
  final int id;

  CategoryImage({
    required this.image,
    required this.id,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      image: json['image'] as String,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'id': id,
  };
}
