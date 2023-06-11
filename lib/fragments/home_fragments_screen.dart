import 'package:bidtake/consts/consts.dart';


class HomeFragmentsScreen extends StatelessWidget {
  
  const HomeFragmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          User? user = await RememberUserPrefs.readUserInfo();
          
            if (user?.isAdmin == true) {
              Get.offAllNamed('/admin');
            } else {
              Get.offAllNamed('/home');
            }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchBarScreen(),
                5.heightBox,
                TrendingListScreen(),
                5.heightBox,
                CategoryListScreen(),
                35.heightBox,
              ]
              ),
            ),
        ),
      ),
      
    );
  }
}
