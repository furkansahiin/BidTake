class Category {
  final int categoryId;
  final String name;
  final String image;

  Category({required this.categoryId, required this.name , required this.image});

  
   factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      image: json['category_image'].toString(),
    );
  }
 
}