class SubCategory {
  final int id;
  final String name;
  final String? imageUrl;

  SubCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, imageUrl: $imageUrl)';
  }
}