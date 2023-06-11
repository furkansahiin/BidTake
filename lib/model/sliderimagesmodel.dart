class SliderImage {
  final int id;
  final String imageUrl;
  final bool isActive;
  final DateTime createDate;

  SliderImage({
    required this.id,
    required this.imageUrl,
    required this.isActive,
    required this.createDate,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) {
    return SliderImage(
      id: int.tryParse(json['sliderimge_id'].toString()) ?? 0,
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] == true,
      createDate: DateTime.tryParse(json['create_date'] ?? '') ?? DateTime.now(),
    );
  }
}

// class AdsImage {
//   final int id;
//   final String imageUrl;
//   final String redirectUrl;
//   final bool isActive;
//   final DateTime createDate;

//   AdsImage({
//     required this.id,
//     required this.imageUrl,
//     required this.redirectUrl,
//     required this.isActive,
//     required this.createDate,
//   });

//   factory AdsImage.fromJson(Map<String, dynamic> json) {
//     return AdsImage(
//       id: int.tryParse(json['ads_id']) ?? 0,
//       imageUrl: json['image_url'],
//       redirectUrl: json['redirect_url'],
//       isActive: json['is_active'] == true,
//       createDate: DateTime.parse(json['create_date']),
//     );
//   }
// }