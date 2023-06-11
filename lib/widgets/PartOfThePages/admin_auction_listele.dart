import 'package:bidtake/widgets/common/Imageloader.dart';
import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({Key? key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Product> _AdminProducts = [];
  List<Map<String, dynamic>> isFavorites = [];

  @override
  void initState() {
    super.initState();
    _fetchAdminProducts();
  }

  Future<void> _fetchAdminProducts() async {
    User? user = await RememberUserPrefs.readUserInfo();
    try {
    final auctionsResponse = await http.get(Uri.parse(API.auctionlist));
    if (auctionsResponse.statusCode == 200) {
          if (json.decode(auctionsResponse.body)['success'] == true) {
        final auctionsData = json.decode(auctionsResponse.body)['auctions'] as List<dynamic>;

        final productIds = auctionsData.map((auction) => auction['product_id']).toList();
        final productsResponse = await http.get(Uri.parse("${API.productlist}?product_id=${productIds.join(',')}"));

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
                _AdminProducts = adminProducts;
              });
        } else {
          setState(() {
            _AdminProducts = [];
          });
        }
      }
    }
  }
} else {
  setState(() {
    _AdminProducts = [];
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
  child: _AdminProducts.isEmpty
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: notadmintext.text.size(20).make(),
                  ),
                  // 10.heightBox,
                  // TextButton(
                  //   onPressed: () async {
                  //     User? user = await RememberUserPrefs.readUserInfo();
                  //     if (user != null && user.isAdmin == true) {
                  //       // AdminDashboardFragments'e yönlendirme
                  //       await Get.offAll(() => AdminDashboardFragments());
                  //     } else {
                  //       // DashboardFragments'e yönlendirme
                  //       await Get.offAll(() => DashboardFragments());
                  //     }
                  //   },
                  //   child: allexplore.text.color(appcolorred).size(18).makeCentered(),
                  // ),
                ],
              ),
            ),
          ],
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _AdminProducts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
      Get.to(() => ProductDetailPage(
        productId: _AdminProducts[index].productId,
      ));
    },
              child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(_AdminProducts[index].image),
                            ),),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _AdminProducts[index].title.text.size(20).maxLines(1).ellipsis.make(),
                                    10.heightBox,
                                    _AdminProducts[index].description.text.size(15).maxLines(2).ellipsis.make(),
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

    );
  }
}