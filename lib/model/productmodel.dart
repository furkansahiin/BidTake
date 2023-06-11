class Product {
  int productId;
  int userId;
  bool isSponsored;
  String image;
  String title;
  String description;
  int categoryId;
  int viewCount;
  DateTime createDate;
  bool visited;

  Product({
    required this.productId,
    required this.userId,
    required this.isSponsored,
    required this.image,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.viewCount,
    required this.createDate,
    required this.visited,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
    productId: int.tryParse(json['product_id'].toString()) ?? 0,
    userId: int.tryParse(json['user_id'].toString()) ?? 0,
    isSponsored: int.tryParse(json['is_sponsored']) == 1 ? true : false,
    image: json['image'],
    title: json['title'],
    description: json['description'],
    categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
    viewCount: int.tryParse(json['view_count'].toString()) ?? 0,
    createDate: DateTime.parse(json['create_date']),
    visited: int.tryParse(json['visited']) == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
      'is_sponsored': isSponsored,
      'image': image,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'view_count': viewCount,
      'create_date': createDate.toIso8601String(),
      'visited': visited,
    };
  }
}