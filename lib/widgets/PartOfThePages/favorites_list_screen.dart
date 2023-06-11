import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({Key? key});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Product> _FavoritesList = [];
  List<Map<String, dynamic>> isFavorites = [];

  @override
  void initState() {
    super.initState();
    _fetch_FavoritesList();
  }

  Future<void> _fetch_FavoritesList() async {
    try {
    final favoritesResponse = await http.get(Uri.parse(API.favoritesList + '?user_id=' + (await RememberUserPrefs.readUserInfo())!.userId.toString()));
    if (favoritesResponse.statusCode == 200) {
   Map<String, dynamic> favoritesData = json.decode(favoritesResponse.body);
  
    if (favoritesData['success'] == true) {
      List<dynamic> productIds = favoritesData['product_ids'];
      String productIdsString = productIds.join(',');

      final productsResponse = await http.get(Uri.parse("${API.productlist}?product_id=$productIdsString"));

      if (this.mounted && productsResponse.statusCode == 200) {
        Map<String, dynamic> productsData = json.decode(productsResponse.body);
        
        if (productsData['success'] == true) {
          List<dynamic> productsList = productsData['products'];

          // Filter the first 5 products and update the state with setState
          setState(() {
            _FavoritesList = productsList
                .map((product) => Product.fromJson(product))
                .toList();
          });

          for (var product in _FavoritesList) {
            final user = await RememberUserPrefs.readUserInfo();
            bool isProductFavorite =
                await favoriteManager.checkFavorite(user!.userId, product.productId);

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
        _FavoritesList = [];
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
          10.heightBox,
          _FavoritesList.isEmpty
              ? Center(
                heightFactor: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      notfavorites.text.size(20).make(),
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
            
            itemCount: _FavoritesList.length,
            
            itemBuilder: (context, index, realIndex) {
              return _favoritesStackList(index);
      });
  }

  Widget _favoritesStackList(int index){
    return Stack(
                children: [
                  GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailPage(productId: _FavoritesList[index].productId));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       Container(
                width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,              
              child: Hero(
                tag: '${_FavoritesList[index].productId}',
                child: _FavoritesList.isEmpty
                    ? Noimage()
                    : Image.network(
                        _FavoritesList[index].image,
                        fit: BoxFit.contain,
                      ),
              ),
            ).box.border(color: Colors.black, width: 1).width(MediaQuery.of(context).size.width * 0.5).padding(padding8y).make(),
                      10.heightBox,
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                            
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListTile(
                              title: _FavoritesList[index].title.text.size(20).maxLines(1).ellipsis.make(),
                              subtitle: _FavoritesList[index].description.text.size(14).maxLines(2).ellipsis.make(),
                                                      ),
                            ),
                            )
              
                          ],
                        ),
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
              isFavorites[index]['id'] = _FavoritesList[index].productId;
              await favoriteManager.addRemoveFavorite(user!.userId, _FavoritesList[index].productId, index, isFavorites);
              bool updatedFavorite = await favoriteManager.checkFavorite(user.userId, _FavoritesList[index].productId);
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
  return favoriteManager.checkFavorite(user!.userId, _FavoritesList[index].productId);
}
}