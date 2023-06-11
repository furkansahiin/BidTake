class Favorite {
  int favoriteId;
  int userId;
  int productId;
  DateTime createDate;

  Favorite({
    required this.favoriteId,
    required this.userId,
    required this.productId,
    required this.createDate,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favoriteId: int.tryParse(json['favorite_id']) ?? 0,
        userId: int.tryParse(json['user_id']) ?? 0,
        productId: int.tryParse(json['product_id']) ?? 0,
        createDate: DateTime.parse(json['create_date']),
      );

  Map<String, dynamic> toJson() => {
        'favorite_id': favoriteId,
        'user_id': userId,
        'product_id': productId,
        'create_date': createDate.toIso8601String(),
      };
}
