import 'dart:io';

import 'package:bidtake/consts/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
      


  XFile? _selectedImage;
  Category? selectedCategory;
  List<Category> _categoryList = [];
final _formKey = GlobalKey<FormState>(); // Form key for validation
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
      
    });
  }
  
   @override
  void initState() {
    super.initState();
    getUserInfo();
  }
Future<void> _uploadProfile(String imagePath, String name, String email) async {
  User? user = await RememberUserPrefs.readUserInfo();
  String userid = user!.userId.toString();

  try {
    final url = Uri.parse(API.profileedit);

    // Dosya yüklemesi için bir multipart form oluşturun
    var request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userid;
    request.fields['username'] = name;
    request.fields['email'] = email;

    // imagePath boş değilse, dosya yüklemesi yapın
    if (imagePath.isNotEmpty) {
      // Dosya yolunu kullanarak bir dosya nesnesi oluşturun
      var file = await http.MultipartFile.fromPath('image', imagePath);

      // Oluşturulan dosyayı form verilerine ekleyin
      request.files.add(file);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final addData = json.decode(responseBody);
       if (addData['success'] == true) {
        Get.snackbar(successTitle, successeditprofile, snackPosition: SnackPosition.BOTTOM, backgroundColor: greenColor, colorText: whiteColor , duration: const Duration(seconds: 1));
      } else {
        Get.snackbar(errorTitle, errorfotoyuklenemedi, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor, duration: const Duration(seconds: 1));
      }
    } else {
    }
  } catch (e) {
    Get.snackbar(errorTitle, erorHostNotFound, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
  }
}
  void getUserInfo() async {
    User? user = await RememberUserPrefs.readUserInfo();
    if (user != null) {
      setState(() {
        nameController.text = user.username;
        emailController.text = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profil Düzenle'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileImage(),
                        10.heightBox,
                        ourButton(
                          title: _selectedImage == null ? 'Resim Yükle' : 'Resmi Değiştir',
                          onPressed: _pickImage,
                          textColor: Colors.white,
                          color: appcolor,
                        ).box.width(context.screenWidth * 0.5).make(),
                        10.heightBox,
                        "Kullanıcı Adı".text.start.xl.make(),
                        custumTextFieldWidget(
                          title: 'Kullanıcı Adı',
                          hint: 'Kullanıcı Adı',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                        ),
                        
                        "Kullanıcı E-Maili".text.xl.make().p8(),
                        custumTextFieldWidget(
                          title: 'Kullanıcı Maili',
                          hint: 'Kullanıcı Maili',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        15.heightBox,
                        ourButton(
                      
                      title: 'Profili Güncelle',
                      onPressed: () async {
                        bool isValid = await validateUserEmail();
                        User? user = await RememberUserPrefs.readUserInfo();

                        if (_formKey.currentState!.validate()) {
                          if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                            Get.snackbar(
                              errorTitle,
                              errorFormNotValid,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: errorred,
                              colorText: whiteColor,
                            );
                          } else if (!isEmailValid(emailController.text.trim())) {
                            Get.snackbar(
                              errorTitle,
                              errorEmailNotValid,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: errorred,
                              colorText: whiteColor,
                            );
                          } else if (user?.email != emailController.text.trim()) {
                            if (!isValid) {
                              Get.snackbar(
                                errorTitle,
                                errorEmailFound,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: errorred,
                                colorText: whiteColor,
                              );
                            } else {
                              if (_selectedImage != null) {
                                _uploadProfile(_selectedImage!.path, nameController.text.trim(), emailController.text.trim());
                              } else {
                                _uploadProfile("", nameController.text.trim(), emailController.text.trim());
                              }
                            }
                          } else {
                            if (_selectedImage != null) {
                              _uploadProfile(_selectedImage!.path, nameController.text.trim(), emailController.text.trim());
                            } else {
                              _uploadProfile("", nameController.text.trim(), emailController.text.trim());
                            }
                          }
                        }
                      },
                      textColor: Colors.white,
                      color: appcolorred,
                    ).box
                          .width(context.screenWidth - 50)
                          .make(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> validateUserEmail() async {
  try {
    var res = await http.post(
      Uri.parse(API.validateEmail),
      body: {
        "email": emailController.text.trim(),
      },
    );

    if (res.statusCode == 200) {
      var resBodyOfValidateUserEmail = jsonDecode(res.body);

      if (resBodyOfValidateUserEmail["emailfound"] == true) {
        return false;
      } else {
        return true;
      }
    }
  } catch (e) {
    Get.snackbar(
      errorTitle,
      erorHostNotFound,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: errorred,
      colorText: whiteColor,
    );
  }
  return false;
}

bool isEmailValid(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return FutureBuilder<User?>(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return applogoWidget();
          } else if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null && user.image != "") {
              return Image(
                image: NetworkImage(user.image),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              );
            }
            else {
              return applogoWidget();
            }
          }
          return applogoWidget();
        },
      );
    }
  }
}
