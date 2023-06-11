import 'package:bidtake/widgets/common/Imageloader.dart';
import 'package:bidtake/widgets/common/bids_alert_widget.dart';
import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class AdminAllProductsScreen extends StatefulWidget {
  const AdminAllProductsScreen({Key? key});

  @override
  State<AdminAllProductsScreen> createState() => _AdminallProductsScreenState();
}

class _AdminallProductsScreenState extends State<AdminAllProductsScreen> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Product> _AdminallProducts = [];
  List<Map<String, dynamic>> isFavorites = [];

  @override
  void initState() {
    super.initState();
    _fetchAdminProducts();
  }
Future<void> _fetchAdminProducts() async {
    User? user = await RememberUserPrefs.readUserInfo();
    try {
    final productsResponse = await http.get(Uri.parse(API.productlist));
        if (this.mounted && productsResponse.statusCode == 200) {
      final productsData = json.decode(productsResponse.body);
      if (productsData['success'] == true) {
        final List<dynamic> productList = productsData['products'];
        if (user != null) {
         final adminProducts = productList
            .where((product) => int.parse(product['user_id']) == user.userId)
            .map((product) => Product.fromJson(product))
            .toList();
              
                 setState(() {
                _AdminallProducts = adminProducts;
              });
        } else {
          setState(() {
            _AdminallProducts = [];
          });
        }
      }  
} else {
  setState(() {
    _AdminallProducts = [];
  });
}
    }
    catch (e) {
      Get.snackbar(
        errorTitle,
        erorHostNotFound,      
        backgroundColor: errorred,
        colorText: whiteColor,
        duration: const Duration(seconds: 3),
      );
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
  child: _AdminallProducts.isEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            10.heightBox,
            Center(
              heightFactor: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  notAdminproduct.text.size(20).make(),
                  10.heightBox,
                  TextButton(
                    onPressed: () async {
                      User? user = await RememberUserPrefs.readUserInfo();
                      if (user != null && user.isAdmin == true) {
                        // AdminDashboardFragments'e yönlendirme
                        await Get.offAll(() => AdminDashboardFragments());
                      } else {
                        // DashboardFragments'e yönlendirme
                        await Get.offAll(() => DashboardFragments());
                      }
                    },
                    child: allexplore.text.color(appcolorred).size(18).makeCentered(),
                  ),
                ],
              ),
            ),
          ],
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _AdminallProducts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
      Get.to(() => ProductDetailPage(
        productId: _AdminallProducts[index].productId,
      ));
    },
              child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 100,
                              width: 100,
                              child: _AdminallProducts[index].image.isNotEmpty ? Image.network(_AdminallProducts[index].image) : Image.asset("assets/images/noimage.png"),
                            ),),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _AdminallProducts[index].title.text.size(20).maxLines(1).ellipsis.make(),
                                    10.heightBox,
                                    _AdminallProducts[index].description.text.size(15).maxLines(2).ellipsis.make(),
                                    10.heightBox,
                                    _AdminallProducts[index].visited  ? " ".text.make() : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(onPressed: (){
                                          yayinlashowmodel(context, _AdminallProducts[index].productId.toString());
                                         _fetchAdminProducts();
                                        }, child : "Yayınla".text.color(appcolor).size(16).make()),
                                        TextButton(onPressed: (){
                                          yayindakinisil(context, _AdminallProducts[index].productId.toString());
                                         _fetchAdminProducts();
                                        }, child : "Sil".text.color(appcolorred).make()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                           
                          ],
                        ),
                      ],
                    )
              
            ).box
                    .white
                    .margin(padding8all)
                .rounded
                .padding(padding8all)
                .shadow5xl
                .make();
          },
        ),
      ),
floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
       floatingActionButton: FloatingActionButton(
        backgroundColor: appcolor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageUploader()),
          );
        },
        child: Icon(Icons.add),
        
      ),
    );
  }
}