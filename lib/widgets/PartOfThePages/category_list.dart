import 'package:bidtake/consts/consts.dart';
import 'package:http/http.dart' as http;

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Category> _categoryList = [];
  List<Product> _productsList = [];
  int selectedCategoryIndex = 0;
  List<Map<String, dynamic>> isFavorites = [];


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
      Get.snackbar(errorTitle, erorHostNotFound, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
    }
  }
  Future<void> _fetchProductsByCategory(int categoryId) async {
  try {
    final auctionsResponse = await http.get(Uri.parse(API.auctionlist));
    if (auctionsResponse.statusCode == 200) {
      if (json.decode(auctionsResponse.body)['success'] == true) {
        final auctionsData =
            json.decode(auctionsResponse.body)['auctions'] as List<dynamic>;

        // auctionsData'dan çekilen product_id'leri içeren ürünleri getirin
        final productIds =
            auctionsData.map((auction) => auction['product_id']).toList();
        final productsResponse = await http.get(Uri.parse(
            "${API.productlist}?product_id=${productIds.join(',')}"));

        if (productsResponse.statusCode == 200) {
          if (json.decode(productsResponse.body)['success'] == true) {
            final productsData =
                json.decode(productsResponse.body)['products'] as List<dynamic>;

            // category_id'yi içeren ürünleri ayıklayın ve setState ile güncelleyin
            final filteredProductsData = categoryId == 1
                ? productsData
                : productsData
                    .where((product) =>
                        product['category_id'].toString() == categoryId.toString())
                    .toList();

            if (mounted) {
              setState(() {
                _productsList = filteredProductsData
                    .map((product) => Product.fromJson(product))
                    .toList();
              });
            }

            for (var product in _productsList) {
              final user = await RememberUserPrefs.readUserInfo();
              bool isProductFavorite = await favoriteManager.checkFavorite(
                  user!.userId, product.productId);

              Map<String, dynamic> productData = {
                'id': product.productId,
                'is_favorite': isProductFavorite,
              };

              isFavorites.add(productData);
            }
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _productsList = [];
          });
        }
      }
    }
  } catch (e) {
    Get.snackbar(errorTitle, erorHostNotFound,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorred,
        colorText: whiteColor);
    if (mounted) {
      setState(() {
        _productsList = [];
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    if (_productsList.length == 0) {
      _fetchProductsByCategory(1);
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: _categoryList.isNotEmpty ? categoryListView() : CircularProgressIndicator(color: appcolor,).centered()
          ),
          5.heightBox,
        _productsList.isNotEmpty ? CategoryCarouselSlider(context) : CircularProgressIndicator(color: appcolor,).centered(),
          ],
      ),
    );
  }

  ListView categoryListView() {
    return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                  _fetchProductsByCategory(_categoryList[index].categoryId);
                },
                child: Center(
                  child: Padding(
                    padding: padding16x,
                    child: _categoryList[index].name.text.fontWeight(selectedCategoryIndex == index ? FontWeight.w700 : FontWeight.normal).fontFamily(regular).color(selectedCategoryIndex == index ? appcolorred : null).italic.size(18).make(),
                  ),
                ),
              );
            },
          );
  }

  CarouselSlider CategoryCarouselSlider(BuildContext context) {
    return CarouselSlider.builder(
  
  options: CarouselOptions(
    height: MediaQuery.of(context).size.height * 0.5,
    aspectRatio: 16/9,
    viewportFraction: 0.8,
    initialPage: 0,
    enableInfiniteScroll: true,
    reverse: false,
    autoPlayInterval: const Duration(seconds: 3),
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    onPageChanged: (index, reason) {
      // setState(() {
      //   _current = index;
      // });
    },
    scrollDirection: Axis.horizontal,

  ),
  itemCount: _productsList.length,
  
  itemBuilder: (context, index, realIndex) {
    return Stack(
      children: [
        CategoryGesture(index, context),
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
              isFavorites[index]['id'] = _productsList[index].productId;
              await favoriteManager.addRemoveFavorite(user!.userId, _productsList[index].productId, index, isFavorites);
              bool updatedFavorite = await favoriteManager.checkFavorite(user.userId, _productsList[index].productId);
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
  });
  }

  GestureDetector CategoryGesture(int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => ProductDetailPage(productId: _productsList[index].productId));
        },
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,              
            child: Hero(
              tag: '${_productsList[index].productId}',
              child: _productsList.isEmpty
                  ? Noimage()
                  : Image.network(
                      _productsList[index].image,
                      fit: BoxFit.contain,
                    ),
            ),
          ).box.border(color: Colors.black, width: 1).width(MediaQuery.of(context).size.width * 0.5).padding(padding8y).make(),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                     child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListTile(
                              title: _productsList[index].title.text.size(20).maxLines(1).ellipsis.make(),
                              subtitle: _productsList[index].description.text.size(14).maxLines(2).ellipsis.make(),
                                                      ),
                  )),
    
                ],
              ),
            )
          ],
        )
            .box
            .color(cardBackGroundColor)
            .margin(marginhorizontal)
            .rounded
            .padding(padding8all)
            .shadow2xl
            .make(),
      );
  }

   Future<bool> _getFavoriteStatus(index) async {
  User? user = await RememberUserPrefs.readUserInfo();
  return favoriteManager.checkFavorite(user!.userId, _productsList[index].productId);
}
}
