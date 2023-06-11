class User {
  int userId;
  String username;
  String email;
  String password;
  String image;
  bool isAdmin;
  String created_at;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.isAdmin,
    required this.created_at,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    userId: int.tryParse(json['user_id']) ?? 0,// userId null ise 0 olarak ayarlanır
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    image: json['image'] ?? '',
    isAdmin: json["is_admin"] == true || json["is_admin"] == "1" || json["is_admin"] == "true", // string'i bool'a dönüştürüyoruz
    created_at: json['created_at'] ?? DateTime.now().toString(),
    );
}

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString() ?? '',
      'username': username ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'image': image ?? '',
      'is_admin': isAdmin.toString() ?? false,
      'created_at': created_at ?? DateTime.now().toString(),
    };
  }
}