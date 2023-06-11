import 'package:bidtake/consts/consts.dart';


class ProfileFragmentsScreen extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  signOutUser() async {
    var _result = await Get.dialog(
      AlertDialog(
        title: Text("Emin misiniz?"),
        content: Text("Çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text("Evet"),
          ),
        ],
      ),
    );

    if (_result == true) {
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.offAllNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: bgWidget(
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: padding8all,
                child: Column(
                  children: [
                    // edit profile button
                    // profile image
                    Column(
                      children: [
                        _rememberCurrentUser.user.image != "" ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(_rememberCurrentUser.user.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ) : applogoWidget(),
                      // profile name
                      16.heightBox,
                      _rememberCurrentUser.user.username.text.xl2.make(),
                      8.heightBox,
                      // profile email
                      _rememberCurrentUser.user.email.text.make(),
            
                      ]
                    ),
                    // Buttons section
                    40.heightBox,
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final profileButtonscheck = _rememberCurrentUser.user.isAdmin ? profileButtonsAdmin : profileButtons;

                        return ListTile(
                          leading: Icon(
                            _rememberCurrentUser.user.isAdmin ? profileButtonsIconAdmin[index] : profileButtonsIcon[index],
                            color: appcolor,
                          ),
                          title: profileButtonscheck[index].text.make(),
                          onTap: () {
                            if (index == 0) {
                              Get.toNamed('/editprofile');
                            } else if (index == 1) {
                              showModalBottomSheetWithText(context, privacyPolicyt, privacyPolicyttext);
                            } else if (index == 2) {
                              showModalBottomSheetWithText(context, termAndCond, termAndCondtext);
                            } else if (index == 3) {
                              _rememberCurrentUser.user.isAdmin ? showModalBottomSheetWithText(context, thanks, thankstext): showAdminOl(context);
                            } else if (index == 4) {
                              signOutUser();
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: appcolor,
                        );
                      },
                      itemCount: _rememberCurrentUser.user.isAdmin ? profileButtonsAdmin.length : profileButtons.length,
                    )
                      .box
                      .rounded
                      .padding(EdgeInsets.symmetric(horizontal: 16))
                      .make(),

                    // Developer info
                    20.heightBox,
                    appname.text.fontFamily(bold).size(22).color(appcolorred).make(),
                    10.heightBox,
                    appversiyoncredits.text.color(appcolorred).make(),
                    20.heightBox,
                  ]

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
