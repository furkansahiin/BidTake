import 'package:bidtake/model/auctionsmodel.dart';
import 'package:bidtake/widgets/common/countdown.dart';
import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class TrendingListScreen extends StatefulWidget {
  const TrendingListScreen({Key? key});

  @override
  State<TrendingListScreen> createState() => _TrendingListScreenState();
}

class _TrendingListScreenState extends State<TrendingListScreen> {
    FavoriteManager favoriteManager = FavoriteManager();

  List<Product> _trendlist = [];
  List<Map<String, dynamic>> isFavorites = [];

  @override
  void initState() {
    super.initState();
    

    _fetchTrendsList();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchTrendsList() async {
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

            // ilk 5 ürünü ayıklayın ve setState ile güncelleyin
            final filteredTrendsData = productsData
                .where((element) => element['view_count'].isNotEmpty)
                .toList()
                .sortedBy((a, b) => int.parse(b['view_count'])
                    .compareTo(int.parse(a['view_count'])))
                .take(5)
                .toList();
            if (this.mounted) {
              setState(() {
                _trendlist = filteredTrendsData
                    .map((product) => Product.fromJson(product))
                    .toList();
              });
            }

            for (var product in _trendlist) {
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
  } catch (e) {
    if (this.mounted) {
      Get.snackbar(
        errorTitle,
        errortrending,
        backgroundColor: errorred,
        colorText: whiteColor,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         trendingtitle.text.xl.bold.color(appcolorred).make().marginOnly(left: 10),
        10.heightBox,
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: _trendlist.isEmpty
              ? CircularProgressIndicator(
                          color: appcolor,
                        ).box.makeCentered()
              : CarouselSlider.builder(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.2,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
                  itemCount: _trendlist.length,
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                    return Stack(
        children: [
          GestureDece(_trendlist, index),
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
              isFavorites[index]['id'] = _trendlist[index].productId;
              await favoriteManager.addRemoveFavorite(user!.userId, _trendlist[index].productId, index, isFavorites);
              bool updatedFavorite = await favoriteManager.checkFavorite(user.userId, _trendlist[index].productId);
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
                  },
                ),
        ),
      ],
    );
  }
   Future<bool> _getFavoriteStatus(index) async {
  User? user = await RememberUserPrefs.readUserInfo();
  return favoriteManager.checkFavorite(user!.userId, _trendlist[index].productId);
}
}

Widget GestureDece(List<Product> _trendlist, int index) {
  return GestureDetector(
          onTap: () {
            Get.to(() => ProductDetailPage(
                  productId: _trendlist[index].productId,
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _trendlist[index].image == null
                  ? Noimage()
                  :
              Image.network(
                _trendlist[index].image,
                width: 100,
                fit: BoxFit.fill,
              ),
              10.widthBox,
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: _trendlist[index].title.text
                            .bold
                            .size(18)
                            .make()),
                    Expanded(
                        child: _trendlist[index].description.text
                        .maxLines(2).ellipsis
                            .make()),
                    Expanded(
                        child: _trendlist[index].isSponsored == true
                            ? Text('Güvenli Alışveriş', style: TextStyle(color: Colors.green),)
                  : Text(''))
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