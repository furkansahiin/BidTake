import 'package:bidtake/consts/consts.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   // İnternet bağlantısını kontrol eden fonksiyon
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: appcolorred),
        ),
        // fontFamily: regular,
      ),
      
      
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(name: '/home', page: () => DashboardFragments()),
        GetPage(name: '/admin', page: () => AdminDashboardFragments()),
        GetPage(name: '/login', page: () =>  const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/editprofile', page: () => const ProfileEditScreen()),
        // GetPage(name: '/ayarlar', page: () => const SettingsScreen()),
        // GetPage(name: '/search', page: () => const SearchFragments()),
        GetPage(name: '/profile', page: () => ProfileFragmentsScreen()),
        // GetPage(name: '/notification', page: () => const NotificationFragments()),
        // GetPage(name: '/favorite', page: () => const FavoriteFragments()),
      ],
      home: FutureBuilder<bool>(
        future: checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isConnected = snapshot.data!;
            if (isConnected) {
              return FutureBuilder<User?>(
                future: RememberUserPrefs.readUserInfo(),
                builder: (context, dataSnapShot) {
                  if (dataSnapShot.hasData) {
                    User? user = dataSnapShot.data;
                    if (user!.isAdmin == true) {
                      return AdminDashboardFragments();
                    } else {
                      return DashboardFragments();
                    }
                  } else {
                    return const splashScreen();
                  }
                },
              );
            } else {
              return AlertDialog(
                title: const Text("İnternet Bağlantısı Yok"),
                content: const Text("İnternet bağlantınızı kontrol edin"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tamam"),
                  ),
                ],
              );
            }
          } else {
            return const splashScreen();
          }
        },
      ),
    );
  }
}
