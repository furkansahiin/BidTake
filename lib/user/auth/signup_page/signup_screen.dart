import 'package:bidtake/consts/consts.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var isObsecure = true.obs;
  var isObsecureconfirm = true.obs;
  bool? isCheck = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  bool isEmailValid(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
  validateUserEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validateEmail),
        body: {
          "email": _emailController.text.trim(),
        }
      );

      if(res.statusCode == 200) {
        var resBodyOfValidateUserEmail = jsonDecode(res.body);

        if(resBodyOfValidateUserEmail["emailfound"] == true) {
          Get.snackbar(errorTitle, errorEmailAlreadyExist , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor,);
        } else {
          saveNewUser();
        }
      }

    } catch (e) {
      Get.snackbar(errorTitle, erorHostNotFound , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor,);
    }
  }
    Future<void> saveNewUser() async {
    User userModel = User(
      userId: 1,
      username: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      image: '',
      isAdmin: false,   
      created_at: '', 
    );

    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if (res.statusCode == 200) {
        var resBodyOfSaveNewUser = jsonDecode(res.body);

        if(resBodyOfSaveNewUser["status"] == true) {
         Get.snackbar(successTitle, errorSignupSuccess , snackPosition: SnackPosition.BOTTOM, backgroundColor: greenColor, colorText: whiteColor);
          Get.offNamed('/login');
        } else {
          Get.snackbar(errorTitle, errorSignupFail , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
        }
      } else {
        Get.snackbar(errorTitle, erorHostNotFound , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
      }
    } catch (e) {
      Get.snackbar(errorTitle, erorHostNotFound , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
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
                  (context.screenHeight * 0.05).heightBox,
                  applogoWidget(),
                  10.heightBox,

                  20.heightBox,
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        custumTextFieldWidget(
                          hint: nameHint,
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                        ),
                        custumTextFieldWidget(
                          hint: emailHint,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Obx(
                          () => passwordtextfield(
                            hint: passwordHint,
                            isObsecure: isObsecure,
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Obx(
                          () => passwordtextfield(
                            hint: confirmPassHint,
                            isObsecure: isObsecureconfirm,
                            controller: _confirmpasswordController,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: appcolor,
                                checkColor: whiteColor,
                                value: isCheck,
                                onChanged: (newValue) {
                                  setState(() {
                                    isCheck = newValue;
                                  });
                                }),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                    color: appcolorred,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,

                                  ),
                                  recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showModalBottomSheetWithText(context, termAndCond, termAndCondtext);
                                        },
                                  children: [
                                    
                                    TextSpan(
                                      text: and,
                                      style: TextStyle(
                                        color: blackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: privacyPolicyt,
                                      style: TextStyle(
                                        color: appcolorred,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showModalBottomSheetWithText(context, privacyPolicyt, privacyPolicyttext);
                                        },
                                    ),
                                    TextSpan(
                                      text: readAndAgree,
                                      style: TextStyle(
                                        color: blackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            ),
                          ],
                        ),
                        10.heightBox,
                        // signup button
                        ourButton(
                            color: isCheck == true ? appcolor : lightGrey,
                            title: signupButton,
                            textColor: blackColor,
                            onPressed: () {
                              if (formKey.currentState!.validate() || _emailController.text.contains("@") == false || _emailController.text.contains(".") == false) {
                                if (_nameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    _confirmpasswordController.text.isEmpty) {
                                  Get.snackbar(errorTitle,textFieldEmpty , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
                                } else if (isCheck == false) {
                                  Get.snackbar(
                                    errorTitle,
                                    errorAgreePrivacyandTerm,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: errorred, colorText: whiteColor
                                  );
                                } else {
                                  if (_nameController.text.trim().length < 3) {
                                    Get.snackbar(
                                      errorTitle,
                                      nameError,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: errorred, colorText: whiteColor
                                    );
                                  } else if (!isEmailValid(_emailController.text.trim())) {
                                    Get.snackbar(
                                      errorTitle,
                                      errorEmailNotValid,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: errorred,
                                      colorText: whiteColor,
                                    );
                                  } else if (_passwordController.text
                                          .trim()
                                          .length <
                                      6) {
                                    Get.snackbar(
                                      errorTitle,
                                      passwordError,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: errorred, colorText: whiteColor
                                    );
                                  } else if (_passwordController.text !=
                                      _confirmpasswordController.text) {
                                    Get.snackbar(
                                      errorTitle,
                                      passwordNotMatch,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: errorred, colorText: whiteColor,
                                    );
                                  } else {
                                    validateUserEmail();
                                  }
                                }
                              } else {
                                Get.snackbar(errorTitle, errorFormNotValid,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: errorred, colorText: whiteColor);
                              }
                            }).box.width(context.screenWidth - 50).make(),
                        15.heightBox,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: haveAAccount,
                                  style: TextStyle(
                                      color: darkfontGrey, fontFamily: regular)),
                              TextSpan(
                                  text: loginButton,
                                  style: TextStyle(
                                      color: appcolorred, fontFamily: regular)),
                            ],
                          ),
                        ).onTap(() {
                          Get.offAllNamed("/login");
                        }),
                      ],
                    )
                        .box
                        .color(whiteColor)
                        .rounded
                        .padding(EdgeInsets.all(16.0))
                        .margin(EdgeInsets.all(16.0))
                        .width(context.screenWidth - 60)
                        .make(),
                  ),
                ],
              )),
            )),
      ),
    );
  }
}
