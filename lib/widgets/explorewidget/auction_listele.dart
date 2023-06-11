import 'package:bidtake/widgets/common/countdown.dart';
import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class ExploreListScreen extends StatefulWidget {
  const ExploreListScreen({Key? key});

  @override
  State<ExploreListScreen> createState() => _ExploreListScreenState();
}

class _ExploreListScreenState extends State<ExploreListScreen> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Product> _exploreList = [];
  List<Map<String, dynamic>> isFavorites = [];

  @override
  void initState() {
    super.initState();
    _fetchTrendsList();
  }

  Future<void> _fetchTrendsList() async {
    try {
    final auctionsResponse = await http.get(Uri.parse(API.auctionlist));
    if (auctionsResponse.statusCode == 200) {
          if (json.decode(auctionsResponse.body)['success'] == true) {
        final auctionsData = json.decode(auctionsResponse.body)['auctions'] as List<dynamic>;

        // Get products containing product_ids extracted from auctionsData
        final expiringAuctions = auctionsData.where((auction) {
          final endTime = DateTime.parse(auction['end_time']);
          final difference = endTime.difference(DateTime.now());
          return difference.inDays < 2 && difference.inMilliseconds > 0;
        }).toList();

        final productIds = expiringAuctions.map((auction) => auction['product_id']).toList();
        final productsResponse = await http.get(Uri.parse("${API.productlist}?product_id=${productIds.join(',')}"));

        if (this.mounted && productsResponse.statusCode == 200) {
          if (json.decode(productsResponse.body)['success'] == true) {
            final productsData = json.decode(productsResponse.body)['products'] as List<dynamic>;

            // Filter the first 5 products and update the state with setState
            setState(() {
              _exploreList = productsData.map((product) => Product.fromJson(product)).take(5).toList();
            });

            for (var product in _exploreList) {
              final user = await RememberUserPrefs.readUserInfo();
              bool isProductFavorite = await  favoriteManager.checkFavorite(user!.userId, product.productId);
          
              Map<String, dynamic> productData = {
                'id': product.productId,
                'is_favorite': isProductFavorite,
              };

              isFavorites.add(productData);
            }
          }
        }
      }
    }
      else {
      setState(() {
        _exploreList = [];
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          //  "Keşfet".text.xl.bold.color(appcolorred).make().marginOnly(left: 10),
          10.heightBox,
          _exploreList.isEmpty
              ? Center(
                heightFactor: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      notexplore.text.size(20).make(),
                      10.heightBox,
                      TextButton(onPressed: () async {
                        User? user = await RememberUserPrefs.readUserInfo();
                        if (user != null && user.isAdmin == true) {
                          // AdminDashboardFragments'e yönlendirme
                          await Get.offAll(() => AdminDashboardFragments());
                        } else {
                          // DashboardFragments'e yönlendirme
                          await Get.offAll(() => DashboardFragments());
                        }
                      }, child: allexplore.text.color(appcolorred).size(18).makeCentered()),
                    ],
                  ),
              ) :
              _listCorusel(),
        ],
      ),
    );
  }

  Widget _listCorusel(){
    return CarouselSlider.builder(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.6,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    
                  },
                ),
            
            itemCount: _exploreList.length,
            
            itemBuilder: (context, index, realIndex) {
              return _auctionStackList(index);
      });
  }

  Widget _auctionStackList(int index){
    return Stack(
                children: [
                  GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailPage(productId: _exploreList[index].productId));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: Hero(
                tag: 1,
                child: _exploreList.isEmpty
                    ? Noimage()
                    : Image.network(
                        _exploreList[0].image,
                        fit: BoxFit.contain,
                      ),
              ),
            ).box.border(color: Colors.black, width: 1).width(MediaQuery.of(context).size.width * 0.5).padding(padding8y).make(),
                      10.heightBox,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: _exploreList[index].title.text.size(20).maxLines(1).ellipsis.make(),
                            subtitle: _exploreList[index].description.text.size(14).maxLines(2).ellipsis.make(),
                          ),
                        )
                      )
            ],
          )
              .box
              .color(cardBackGroundColor)
              .margin(margin16)
              .rounded
              .padding(padding8all)
              .shadow2xl
              .make(),
          ),
         Positioned(
  top: 0,
  right: 10,
  child: FutureBuilder<bool>(
    future: _getFavoriteStatus( index),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else {
        if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else {
          bool isFavorite = snapshot.data ?? false;
          return IconButton(
            icon: isFavorite
                ? Icon(
                    Icons.favorite,
                    color: appcolorred,
                  )
                : Icon(
                    Icons.favorite_border_outlined,
                    color: appcolor,
                  ),
            onPressed: () async {
              User? user = await RememberUserPrefs.readUserInfo();
              isFavorites[index]['id'] = _exploreList[index].productId;
              await favoriteManager.addRemoveFavorite(user!.userId, _exploreList[index].productId, index, isFavorites);
              bool updatedFavorite = await favoriteManager.checkFavorite(user.userId, _exploreList[index].productId);
              setState(() {
                isFavorites[index]['is_favorite'] = updatedFavorite;
              });
            },
          );
        }
      }
    },
  ),
),

          ],
        );
  }

  Future<bool> _getFavoriteStatus(index) async {
  User? user = await RememberUserPrefs.readUserInfo();
  return favoriteManager.checkFavorite(user!.userId, _exploreList[index].productId);
}

}

