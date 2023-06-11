import 'package:bidtake/consts/consts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;

  bool _isLoading = false;

  Future<void> loginUserNow() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse(API.login),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        },
      );
      setState(() {
        _isLoading = false;
      });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data['success'] == true){
          User user = User.fromJson(data['userData']);
          RememberUserPrefs.storeUserInfo(user);
         Get.snackbar(successTitle, errorLoginSuccess , snackPosition: SnackPosition.BOTTOM, backgroundColor: greenColor, colorText: whiteColor,);
          if(user.isAdmin){
            Get.offAllNamed('/admin');
          }
          else{
            Get.offAllNamed('/home');
          }
        }else{
          Get.snackbar(errorTitle, errorUsernameOrPassword , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
        }
     }
    } catch (errorMsg) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(errorTitle, erorHostNotFound, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                  child: Center(
                child: Column(
                  children: [
                  (context.screenHeight * 0.1).heightBox,
                  appNoTextlogoWidget(),
                  10.heightBox,
                  appname.text.fontFamily(bold).size(22).white.make(),
                  20.heightBox,
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            custumTextFieldWidget(
                              controller: emailController,
                              hint: emailHint,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Obx(
                              () => passwordtextfield(
                                controller: passwordController,
                                hint: passwordHint,
                                isObsecure: isObsecure,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Align(
                          alignment: Alignment.centerRight,
                          child: Transform.translate(
                          offset: Offset(0, -10), // Use a negative value to move it up
                          child: TextButton(
                            onPressed: () {},
                            child: forgetPass.text.color(appcolorred).size(size13).make(),
                          ),
                        ),),
                      // login button
                      _isLoading
                        ? CircularProgressIndicator(
                          color: appcolor,
                        ).centered()
                        : ourButton(
                              title: loginButton,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                                    loginUserNow();
                                  }else{
                                    Get.snackbar(errorTitle, textFieldEmpty, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
                                  }
                                } else {
                                  Get.snackbar(errorTitle, textFieldEmpty, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
                                }
                              },
                              textColor: blackColor,
                              color: appcolor)
                          .box
                          .width(context.screenWidth - 50)
                          .make(),
                      10.heightBox,
                      createNewAccount.text.gray600.size(size13).make(),
                      10.heightBox,
                      ourButton(
                              title: signupButton,
                              onPressed: () {
                              Get.offAllNamed('/signup');
                              },
                              textColor: blackColor,
                              color: appcolor)
                          .box
                          .width(context.screenWidth - 50)
                          .make(),
                      5.heightBox,
                      
                    ],
                  )
                      .box
                      .color(whiteColor)
                      .rounded
                      .padding(const EdgeInsets.all(16.0))
                      .width(context.screenWidth - 60)
                      .make(),
                              ],
                            ),
                ))),
      ),
    );
  }
}
