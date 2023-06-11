import 'package:bidtake/consts/consts.dart';
import 'package:bidtake/model/auctionsmodel.dart';
import 'package:bidtake/widgets/common/bids_alert_widget.dart';
import 'package:bidtake/widgets/common/countdown.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  
  final int productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FavoriteManager favoriteManager = FavoriteManager();
  List<Product> _productDetail = [];
  
  List<User> _user = [];
  List<Bid> _bids = [];
  List<dynamic> _auctions = [];
  bool _isFavorited = false;
  bool _isuser = false;

  

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  void initState() {
    super.initState();
    _productDetailList();
    getProductsAuction();
    getBids();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _productDetailList() async {
    try {
      final productIds = widget.productId;
      final productsResponse = await http
          .get(Uri.parse("${API.productlist}?product_id=${productIds}"));
      if (this.mounted && productsResponse.statusCode == 200) {
        if (json.decode(productsResponse.body)['success'] == true) {
          final productsData =
              json.decode(productsResponse.body)['products'] as List<dynamic>;
          if (productsData.isNotEmpty) {
            setState(() {
              _productDetail = productsData
                  .map((product) => Product.fromJson(product))
                  .toList();
              final userId = _productDetail[0].userId;

              _fetchUserInfo(userId);

              RememberUserPrefs.readUserInfo().then((user) {
                if (user?.userId == userId) {
                  _isuser = true;
                } else {
                  _isuser = false;
                }
              });
            });
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        errorTitle,
        errorproductlist,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorred,
        colorText: whiteColor,
      );
    }
  }

Future<void> getProductsAuction() async {
    final url = '${API.auctionlist}?product_id=${widget.productId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        final auctionsData = json.decode(response.body)['auctions'] as List<dynamic>;
        if (auctionsData.isNotEmpty) {
          setState(() {
            _auctions = auctionsData
            .map((auction) => Auction.fromJson(auction))
            .toList();



          });
        }
      }
    }
  }

  Future<void> getAllBids() async {
    final url = '${API.productdetail}?product_id=${widget.productId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        final bidsData = json.decode(response.body)['bids'] as List<dynamic>;
        if (bidsData.isNotEmpty) {
          setState(() {
            _bids = bidsData.map((bid) => Bid.fromJson(bid)).toList();
          });
        }
      }
    }
  }

  Future<void> getBids() async {
    final url = '${API.productdetail}?product_id=${widget.productId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        final bidsData = json.decode(response.body)['bids'] as List<dynamic>;
        if (bidsData.isNotEmpty) {
          setState(() {
            _bids = bidsData
                .map((bid) => Bid.fromJson(bid))
                .toList()
                .sortedBy((a, b) => b.createDate.compareTo(a.createDate))
                .take(4)
                .toList();
          });
        }
      }
    }
  }

  Future<void> _fetchUserInfo(int userId) async {
    try {
      final response =
          await http.get(Uri.parse("${API.userinfo}?user_id=${userId}"));
      if (this.mounted && response.statusCode == 200) {
        if (json.decode(response.body)['success'] == true) {
          final userData = json.decode(response.body)['user'];
          if (userData != null) {
            setState(() {
              _user.add(User.fromJson(userData));
            });
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        errorTitle,
        errorproductlist,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorred,
        colorText: whiteColor,
      );
    }
  }

Future<bool> _getFavoriteStatus(index) async {
  User? user = await RememberUserPrefs.readUserInfo();
  return favoriteManager.checkFavorite(user!.userId, _productDetail[index].productId);
}
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: _productDetail.isEmpty
                ? "Ürün Detayı".text.make()
                : Text(_productDetail[0].title ),
            actions: [
              // favorite button
              _productDetail.isEmpty
                  ? Container()
                  : FutureBuilder<bool>(
                      future: _getFavoriteStatus(0),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return IconButton(
                            onPressed: () async {
                              User? user = await RememberUserPrefs.readUserInfo();
                              if (user != null) {
                                  favoriteManager.addRemoveFavoriteproduct(
                                      user.userId, _productDetail[0].productId);

                                _toggleFavorite();
                              } else {
                                Get.snackbar(
                                  errorTitle,
                                  errornotfavorites,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: errorred,
                                  colorText: whiteColor,
                                );
                              }
                            },
                            icon: Icon(
                              snapshot.data == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: snapshot.data == true
                                  ? appcolorred
                                  : appcolor,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
            ],
          ),
          // bottomNavigationBar: _bottomNavigationBar(),

          body: _productDetail.isEmpty && _user.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: Hero(
                tag: 1,
                child: _productDetail.isEmpty
                    ? Noimage()
                    : Image.network(
                        _productDetail[0].image,
                        fit: BoxFit.contain,
                      ),
              ),
            ).box.border(color: Colors.black, width: 1).width(MediaQuery.of(context).size.width * 0.7).padding(padding8y).make(),
            HeightBox(8),
            
            _productDetail.isEmpty ?  const CircularProgressIndicator() : _productDetailDescription(),
            
              ],
            ),
        
           DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 1,
              builder: (context, controller) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _bids.isEmpty
                          ? ListView.builder(
                        controller: controller,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return _scroller(index);
                        },
                      )
                          : ListView.builder(
                              controller: controller,
                              itemCount: _bids.length+4,
                              itemBuilder: (context, index) =>
                                  _bidsCard(index-3),
                            ),
                    ),

                    // Teklif verme butonu
                    

                  ],
                ),
              ),
            )
          
          ],
        ),
),
    ),
    ); 
  }

  Widget _scroller(int index) {
    if (index == 0) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 5,
            width: 35,
            color: Colors.black12,
          ),
        ],
      ),
    );
  } else if (index == 1) {

if (_productDetail.isEmpty) {
  return CircularProgressIndicator();
} else if (_isuser == true) {
  return _Buton("Teklif Bulunamadı", () {});
}else {
  return _Buton("İlk Teklifi Ver", () {
    showPriceModal(context, _productDetail[0].productId, 0);
  });
}


  }
  else if (index == 2) {
    return _productDetail.isEmpty
        ? const CircularProgressIndicator()
        : userCard();
  }
  else{
    return _productDetail.isEmpty
        ? const CircularProgressIndicator()
        :  Column(
            children: [
              ListTile(
                title: _productDetail.isEmpty
                    ? " ".text.make()
                    : "Ürün Detayı".text.bold.size(24).make(),
                subtitle: _productDetail.isEmpty
                    ? " ".text.make()
                    : _productDetail[0].description
                        .text
                        .fontWeight(FontWeight.normal)
                        .minFontSize(16)
                        .make(),
              ),
            ],
          );
  }
  }

Widget _bidsCard(int index) {
  final isLastBid = index == 0;
  final bidColor = isLastBid ? Colors.green.shade100 : Colors.black26;

  if (index == -3) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 5,
            width: 35,
            color: Colors.black12,
          ),
        ],
      ),
    );
  } else if (index == -2) {

if (_productDetail.isEmpty) {
  return CircularProgressIndicator();
} else if (_isuser == true) {
  return _Buton("Teklifleri Gör", () {
    showBidsList(context, _productDetail[0].productId);
  });
} else {
  return _Buton("Teklif Ver", () async {
    showPriceModal(context, _productDetail[0].productId, _bids[0].amount);
    // sayfanın dragable scrollable sheet kısmında teklifler yenilenecek
    
});
}

}

 else if (index == -1) {
    return Column(
      children: [
        userCard(),
        "Teklifler".text.bold.size(24).make(),
      ],
    );
  } else if (index == _bids.length) {
    return _productDetail.isEmpty
        ? CircularProgressIndicator()
        : Column(
            children: [
              ListTile(
                title: _productDetail.isEmpty
                    ? " ".text.make()
                    : "Ürün Detayı".text.bold.size(24).make(),
                subtitle: _productDetail.isEmpty
                    ? " ".text.make()
                    : _productDetail[0].description
                        .text
                        .fontWeight(FontWeight.normal)
                        .minFontSize(16)
                        .make(),
              ),
            ],
          );
  } else {
    return Card(
      color: bidColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: appcolor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            '${_bids[index].amount} TL'.text.bold.white.size(18).make(),
            'Tarih: ${DateFormat('dd.MM.yyyy').format(_bids[index].createDate)}'
                .text.bold.black.size(16)
                .make(),
          ],
        ),
      ).box.make(),
    );
  }
}
  

  Widget userCard(){
  return Padding(
    padding: const EdgeInsets.only(bottom: 25.0 , top: 10),
    child: GestureDetector(
      onTap: () {
        // Get.to(() => UserDetailPage(
        //       userId: _productDetail[0].userId,
        //     ));
      },
      child: ListTile(
              leading: _user.isEmpty
              ? Noimage()
              : CircleAvatar(
                  backgroundImage: NetworkImage(_user[0].image.isEmpty ? defaultUrlImage : _user[0].image), // buraya bak sonra
                  radius: 30,
                ),
    
              title: (_user.isEmpty ? '' : _user[0].username).text.bold.size(20).make(),
              subtitle: (_user.isEmpty ? '' : _user[0].email).text.make(),
              trailing: _productDetail[0].isSponsored == true
                  ? Text('Güvenli Alışveriş', style: TextStyle(color: Colors.green),)
                  : Text(''),
            ).box.color(Colors.green.shade50).margin(padding8x).roundedLg.make(),
    ),
  );
  }  

  Widget _productDetailDescription(){
    return Container(
      decoration: BoxDecoration(
    color: Colors.black12, // İstediğiniz arkaplan rengini buraya ekleyin
    borderRadius: BorderRadius.circular(10), // İstediğiniz yuvarlaklık yarıçapını burada belirleyin
  ),
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListTile(
                
                subtitle: _productDetail.isEmpty
                    ? Text('')
                    : _productDetail[0].description.text.fontWeight(FontWeight.normal).color(whiteColor).minFontSize(16).maxLines(4).ellipsis.make(),
              ),
            );
  }
Widget _Buton(String text, VoidCallback onPressed) {
  if(text=="Teklifleri Gör"){
    CountdownTimer countdownTimer = CountdownTimer(
    targetDate: _auctions.isNotEmpty ? _auctions[0]!.endTime : DateTime.now(),
    remainingTime: _auctions.isNotEmpty ? _auctions[0]!.endTime.difference(DateTime.now()) : Duration.zero,
  );
    return Container(
    height: 65,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: appcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _buildCountdownWidget(text, countdownTimer),
    ),
  );
  }
 else {
   bool showCountdown = (text != "Teklifler Bitti" && (text == "Teklif Ver" || text == "İlk Teklifi Ver" || text == "Teklif Bulunamadı"));
  CountdownTimer countdownTimer = CountdownTimer(
    targetDate: _auctions.isNotEmpty ? _auctions[0]!.endTime : DateTime.now(),
    remainingTime: _auctions.isNotEmpty ? _auctions[0]!.endTime.difference(DateTime.now()) : Duration.zero,
  );

  String surebitti = countdownTimer.remainingTime.inSeconds <= 0 ? "Süre Bitti" : "";
  if (surebitti == "Süre Bitti") {
    return Container(
    height: 65,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: appcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _buildTimeExpiredWidget(),
    ),
  );
  } else {
  return Container(
    height: 65,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: appcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: showCountdown ? _buildCountdownWidget(text, countdownTimer) : _buildTimeExpiredWidget(),
    ),
  );
  }
 }
}

Widget _buildCountdownWidget(String text, CountdownTimer countdownTimer) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        countdownTimer,
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appcolorred,
            fontSize: 20,
          ),
        ),
      ],
    );
  }


Widget _buildTimeExpiredWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Süre Bitti",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: appcolorred,
          fontSize: 20,
        ),
      ),
    ],
  );
}


}