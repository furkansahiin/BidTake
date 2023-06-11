import 'dart:io';

import 'package:bidtake/consts/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kategoryController = TextEditingController();



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
    _fetchCategories();
  }
    Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(API.categorylist));
    if (this.mounted && response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      setState(() {
        _categoryList =
            jsonData.map((category) => Category.fromJson(category)).toList();
      });
    } 
    }
    catch (e) {
      Get.snackbar(errorTitle, erorHostNotFound , snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
    }
  }
Future<void> _uploadImage(String imagePath, String title, String description, id) async {
  User? user = await RememberUserPrefs.readUserInfo();
  String userid = user!.userId.toString();
  String idstring = id.toString();

  try {
    final url = Uri.parse(API.productsadd);

    // Dosya yüklemesi için bir multipart form oluşturun
    var request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userid;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category_id'] = id.toString();

    // Dosya yolunu kullanarak bir dosya nesnesi oluşturun
    var file = await http.MultipartFile.fromPath('image', imagePath);

    // Oluşturulan dosyayı form verilerine ekleyin
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final addData = json.decode(responseBody);
      if (addData['success'] == true) {
        Get.snackbar(successTitle, successproductadd, snackPosition: SnackPosition.BOTTOM, backgroundColor: greenColor, colorText: whiteColor);
      } else {
        Get.snackbar(errorTitle, errorfotoyuklenemedi, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
      }
    } else {
      
    }
  } catch (e) {
  }
}



  @override
  Widget build(BuildContext context) {
     String name = '';
     String description = '';
    
    return bgWidget(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Ürün Yükleme'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                20.heightBox,
                
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      Image.file(
                        File(_selectedImage!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 16),
                    ourButton(
                      title: _selectedImage==null ? 'Resim Yükle' : "Resmi Değiştir" ,
                      onPressed: _pickImage,
                      textColor: Colors.white,
                      color: appcolor,
                    ).box
                          .width(context.screenWidth * 0.5)
                          .make(),
                    SizedBox(height: 16),
                    custumTextFieldWidget(
                      title: 'Ürün Adı',
                      hint: 'Ürün Adı',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                    ),
                    custumTextFieldWidget(
                      title: 'Ürün Açıklaması',
                      hint: 'Ürün Açıklaması',
                      controller: descriptionController,
                      keyboardType: TextInputType.text,                      
                    ),
                    ourButton(
                      title: selectedCategory != null ? selectedCategory!.name : 'Kategori Seçiniz',
                      
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ListView.builder(
                              itemCount: _categoryList.length-1,
                              itemBuilder: (BuildContext context, int index) {
                                Category category = _categoryList[index+1];
                                return ListTile(
                                  leading: Image.network(category.image, width: 50, height: 50,),
                                  title: Text(category.name),
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                    Navigator.pop(context); // Close the modal
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      textColor: Colors.white,
                      color: appcolor,
                    ),
                    25.heightBox,
                    ourButton(
                      
                      title: 'Ürünü Ekleyiniz',
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          if (_selectedImage == null) {
                            Get.snackbar(errorTitle, errornotphoto, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
                          } else if (selectedCategory == null) {
                            Get.snackbar(errorTitle, errornotselectcategory, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
                          } else {
                            User? user = await RememberUserPrefs.readUserInfo();
                            name = nameController.text;
                            description = descriptionController.text;
                            _uploadImage(_selectedImage!.path, name, description, selectedCategory!.categoryId);
                            if (user!.isAdmin){
                              Get.offAllNamed('/admin');
                            } else {
                              Get.offAllNamed('/home');
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
              )
              ],
            ),
          ),
        ),
      ),
    );
  }


}

