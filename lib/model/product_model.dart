class Product {
  final int? id;
  final String name;
  final String description;
  final String imageUrl;
  final int stockQuantity;
  final double rating;
  final int categoryId;
  final String categoryName;
  final int subCategoryId;
  final String brand;
  final String sku;
  final double mrp;
  final double discountPercentage;
  final bool isBestSeller;
  final int reviewCount;
  final List<String> imageUrls;
  final Map<String, String> specifications;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.stockQuantity,
    required this.rating,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.brand,
    required this.sku,
    required this.mrp,
    required this.discountPercentage,
    required this.isBestSeller,
    required this.reviewCount,
    required this.imageUrls,
    required this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      stockQuantity: json['stockQuantity'],
      rating: (json['rating'] as num).toDouble(),
      categoryId: json['category'] != null ? json['category']['id'] : 0,
      categoryName:
          json['category'] != null ? json['category']['name'] ?? '' : '',
      subCategoryId:
          json['subCategory'] != null ? json['subCategory']['id'] : 0,
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      isBestSeller: json['isBestSeller'] ?? false,
      reviewCount: json['reviewCount'] ?? 0,
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      specifications: json['specifications'] != null
          ? Map<String, String>.from(json['specifications'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "stockQuantity": stockQuantity,
      "rating": rating,
      "category": {
        "id": categoryId,
        "name": categoryName,
      },
      "subCategory": {
        "id": subCategoryId,
      },
      "brand": brand,
      "sku": sku,
      "mrp": mrp,
      "discountPercentage": discountPercentage,
      "isBestSeller": isBestSeller,
      "reviewCount": reviewCount,
      "imageUrls": imageUrls,
      "specifications": specifications,
    };
  }
}
