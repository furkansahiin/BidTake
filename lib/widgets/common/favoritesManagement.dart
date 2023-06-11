import 'package:bidtake/consts/consts.dart';
import 'package:http/http.dart' as http;


class FavoriteManager {
  Function(bool isFavorite)? onFavoriteChanged;

  Future<void> addRemoveFavorite(int userId, int productId, int index, List<Map<String, dynamic>> isFavorites) async {
    try {
      var response = await http.get(Uri.parse('${API.favoritesaddRemove}?user_id=$userId&product_id=$productId'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['success']) {
          if (data.containsKey('removed') && data['removed']) {
            isFavorites[index]['is_favorite'] = false;
            onFavoriteChanged?.call(false);
            Get.snackbar(successTitle, favorikaldir, backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 1));
          } else if (data.containsKey('added') && data['added']) {
            isFavorites[index]['is_favorite'] = true;
            onFavoriteChanged?.call(true);
            Get.snackbar(successTitle, favories, backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 1));
          }
        } else {
          
        }
      } else {
        
      }
    } catch (e) {
      Get.snackbar(errorTitle, erorHostNotFound, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<bool> checkFavorite(int userId, int productId) async {
    try {
      final response = await http.get(Uri.parse(API.favoritesList + '?user_id=$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<String> productIds = List<String>.from(data['product_ids']);
          bool isFavorite = productIds.contains(productId.toString());
          return isFavorite;
        } else {
          return false;
        }
      } else {
                  return false;

      }
    } catch (e) {
      Get.snackbar(errorTitle, erorHostNotFound, backgroundColor: Colors.red, colorText: Colors.white);
    }
    return false;
  }

  void addRemoveFavoriteproduct(int userId, int productId) {
    try {
      http.get(Uri.parse('${API.favoritesaddRemove}?user_id=$userId&product_id=$productId')).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success']) {
            if (data.containsKey('removed') && data['removed']) {
              Get.snackbar(successTitle, favorikaldir, backgroundColor: Colors.red, colorText: Colors.white);
            } else if (data.containsKey('added') && data['added']) {
              Get.snackbar(successTitle, favories, backgroundColor: Colors.green, colorText: Colors.white);
            }
          } else {
          }
        } else {
        }
      });
    } catch (e) {
      Get.snackbar(errorTitle, errorinfo, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
