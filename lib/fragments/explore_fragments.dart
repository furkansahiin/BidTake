import 'package:bidtake/consts/consts.dart';

class ExploreFragmentsScreen extends StatelessWidget {
  const ExploreFragmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: exploreHeader.text.size(20).make(),
                  centerTitle: true,
                  // actions: [
                  //   IconButton(
                  //     icon: Icon(Icons.sort,
                  //     color: appcolorred,
                  //     size: 25,
                  //     ),
                  //     onPressed: () {
                  //       // Get.to(() => SearchScreen());
                  //     },
                  //   ),
                  // ],
                ),
                20.heightBox,
                const ExploreListScreen(),
                20.heightBox,
              ],
            ),
          ),
        ),
    );
  }
}
