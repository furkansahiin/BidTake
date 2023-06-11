import 'package:bidtake/consts/consts.dart';

class DashboardFragments extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  List<Widget> _fragmentScreens = [
    HomeFragmentsScreen(),
    ExploreFragmentsScreen(),
    FavoriteFragmentsScreen(),
    ProfileFragmentsScreen(),
  ];

  List _navigationButton = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Ana Sayfa",
    },
    {
      "active_icon": Icons.timer,
      "non_active_icon": Icons.timer_outlined,
      "label": "Keşfet",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_outline,
      "label": "Favoriler",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profil",
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            body: bgWidget(
              child: Obx(
                () => _fragmentScreens[_indexNumber.value],
              ),
            ),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  items: List.generate(_navigationButton.length, (index) {
                    return BottomNavigationBarItem(
                        backgroundColor: bottomNavBarBackGround,
                        icon: Icon(_navigationButton[index]["non_active_icon"]),
                        activeIcon:
                            Icon(_navigationButton[index]["active_icon"]),
                        label: _navigationButton[index]["label"]);
                  }),
                  currentIndex: _indexNumber.value,
                  onTap: (index) {
                    _indexNumber.value = index;
                  },
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: appcolorred,
                  unselectedItemColor: appcolor,
                )),
            
          );
        });
  }
}
