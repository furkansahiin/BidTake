import 'package:bidtake/consts/consts.dart';

class RememberUserPrefs {
  // save user data user info
  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static Future<void> storeUserInfo(User userInfo) async {
    final SharedPreferences prefs = await _prefs;
    String userJsonData = jsonEncode(userInfo.toJson());
    await prefs.setString("currentUser", userJsonData);
  }

  static Future<User?> readUserInfo() async {
    final SharedPreferences prefs = await _prefs;
    String? userInfo = prefs.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userMap = jsonDecode(userInfo);
      return User.fromJson(userMap);
    }

    return null;
  }

  static Future<void> removeUserInfo() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove("currentUser");
  }
}