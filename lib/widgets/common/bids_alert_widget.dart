

import 'package:bidtake/model/auctionsmodel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../consts/consts.dart';

  List<Auction> _auctions = [];
Future<void> addBidForAuctions(int userId, List<Auction> auctions, double amount) async {
  for (var auction in auctions) {
    final url = '${API.bidsAdd}';

    final response = await http.post(Uri.parse(url), body: {
      'user_id': userId.toString(),
      'auction_id': auction.id.toString(),
      'amount': amount.toString(),
      'create_date': DateTime.now().toString(),
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        Get.snackbar(successTitle, successaddteklif);
        Get.off(() => ProductDetailPage(productId: auction.productId));

      } else {
        Get.snackbar(errorTitle, erroraddteklif);        
      }
    } else {
      Get.snackbar(errorTitle, erorHostNotFound);
    }
  }
}


Future<void> getProductsAuction(productId, userId, amount) async {
  final url = '${API.auctionlist}?product_id=$productId';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['success'] == true) {
      final auctionsData = responseData['auctions'] as List<dynamic>;
      if (auctionsData.isNotEmpty) {
        final auctions = auctionsData.map((auction) => Auction.fromJson(auction)).toList();
        await addBidForAuctions(userId, auctions, amount);
      } else {
        Get.snackbar(errorTitle, 'Mevcut açık artırma bulunamadı');
      }
    } else {
    }
  } else {
    Get.snackbar(errorTitle, erorHostNotFound);
  }
}



  void yayinlashowmodel(BuildContext context , String productid) {
    TextEditingController priceController = TextEditingController();
    DateTime? _fromendDate;

    DateTime newValue = DateTime.now();
    final format = DateFormat("dd-MM-yyyy HH:mm");

    Future<void> _saveAuction( String productid, String startdate, String enddate) {
      final url = Uri.parse(API.auctionadd);
      if (productid != null) {
        return http.post(
          url,
          body: {
            'product_id': productid,
            'start_time': startdate,
            'end_time': enddate,
          },
        ).then((response) {
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);
            if (jsonData['success'] == true) {
              Get.snackbar(
                successTitle,
                successauctionadd,
                backgroundColor: greenColor,
                colorText: whiteColor,
                duration: const Duration(seconds: 3),
              );
            } else {
            }
          }
        });
        
      } else {
        Get.snackbar(
          errorTitle,
          erorHostNotFound,
          backgroundColor: errorred,
          colorText: whiteColor,
          duration: const Duration(seconds: 3),
        );
      }
      return Future.value();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Fiyat Teklifi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 DateTimeField(
                  initialValue: DateTime.now(),
                  format: format,
                  onChanged: (DateTime? newValue) {
                    setState(() {
                      _fromendDate = newValue;
                    });
                  },
                  onShowPicker: (context, currentValue) async {
                    final _enddate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (_enddate != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(_enddate, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Teklif Açılış Fiyatı',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appcolor,
                    ),
                    onPressed: () async {
                      String price = priceController.text;
                      if (price.isEmpty) {
                        Get.snackbar(
                          errorTitle,errorFormNotValid,
                          // errorauctionadd,
                          backgroundColor: errorred,
                          colorText: whiteColor,
                          duration: const Duration(seconds: 3)
                        );
                        return;
                      } else {
                        _saveAuction(
                        productid,
                        DateTime.now().toString(),
                         _fromendDate == null ? DateTime.now().add(Duration(days: 2)).toString() : _fromendDate.toString(),
                      );
                      User? user = await RememberUserPrefs.readUserInfo();
                      getProductsAuction(productid, user!.userId, double.parse(priceController.text));
                      
                      Navigator.of(context).pop(); // Modalı kapat
                      }
                    },
                    child: Text(yayinlatext , style: TextStyle(color: appcolorred),),
                  ),

                     
                ],
              ),
            );
          },
        );
      },
    );
  }


  void yayindakinisil(BuildContext context , String productid) {
    
    DateTime newValue = DateTime.now();
    final format = DateFormat("dd-MM-yyyy HH:mm");

    Future<void> _deleteproducts( String productid) {
      final url = Uri.parse(API.auctiondelete);
      // ignore: unnecessary_null_comparison
      if (productid != null) {
        return http.post(
          url,
          body: {
            'product_id': productid,
          },
        ).then((response) {
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);
            if (jsonData['success'] == true) {
              Get.snackbar(
                successTitle,
                productdelete,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
            } else {
            }
          }
        });
        
      } else {
        Get.snackbar(
          errorTitle,
          erorHostNotFound,
          backgroundColor: errorred,
          colorText: whiteColor,
          duration: const Duration(seconds: 3),
        );
      }
      return Future.value();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ürünü Yayından Kaldır'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ürünü yayından kaldırmak istediğinize emin misiniz?'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appcolor,
                    ),
                    onPressed: () async {
                      // String price = priceController.text;
                      _deleteproducts(productid);
                      Navigator.of(context).pop(); // Modalı kapat
                    },
                    child: Text('Evet' , style: TextStyle(color: appcolorred),),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


void showPriceModal(BuildContext context, int productId, double price) {
  TextEditingController priceController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Fiyat Teklifi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Teklif Fiyatı',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: appcolor,
              ),
              onPressed: () async {
                var limitprice = 99999999.9;
                if(priceController.text.isEmpty) {
                  Get.snackbar(
                    errorTitle,
                    errorFormNotValid,
                    backgroundColor: errorred,
                    colorText: whiteColor,
                    duration: const Duration(seconds: 3)
                  );
                  return;
                }
                else {
                  User? user = await RememberUserPrefs.readUserInfo();
                double newPrice = double.parse(priceController.text);
                if (limitprice > newPrice && newPrice > price) {
                  getProductsAuction(productId, user!.userId, newPrice);
                } else {
                  // Hata durumu için geri bildirim
                  Get.snackbar(errorTitle, 'Yeni teklif fiyatı mevcut fiyattan büyük olmalıdır.');
                }
                Navigator.of(context).pop(); // Modalı kapat
                }
                
              },
              child: Text(
                'Teklif Ver',
                style: TextStyle(color: appcolorred),
              ),
            ),
          ],
        ),
      );
    },
  );
}



  void showAllpriceList (BuildContext context , String productid) {
    TextEditingController priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Teklifler'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Teklif Fiyatı',
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: appcolor,
                ),
                onPressed: () {
                  // String price = priceController.text;

                  Navigator.of(context).pop(); // Modalı kapat
                },
                child: Text('Teklif Ver' , style: TextStyle(color: appcolorred),),
              ),
            ],
          ),
        );
      },
    );
  }

  List <Bid> _bids = [];
  Future<void> getAllBids(productId) async {

    final url = '${API.productdetail}?product_id=${productId}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        final bidsData = json.decode(response.body)['bids'] as List<dynamic>;
        if (bidsData.isNotEmpty) {
            _bids = bidsData.map((bid) => Bid.fromJson(bid)).toList();
        }
      }
    }
  }
  void showBidsList( BuildContext context , int productid) {
    getAllBids(productid);
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Fiyat Teklifi'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _bids.length,
            itemBuilder: (context, index) {
              final bid = _bids[index];
              return ListTile(
                title: Text('Teklif Fiyatı: ${bid.amount}'),
                subtitle: Text('Teklif Tarihi: ${bid.createDate}'),
              );
            },
          ),
        ),
      );
    
      },
    );
  }

  void showAdminOl (BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Ol'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Eğer Şifre Geçerli olursa Giriş Sayfasına Yönlendirileceksiniz'),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Hesap Şifresi ',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: appcolor,
              ),
              onPressed: () async {
                User? user = await RememberUserPrefs.readUserInfo();
                addAdmin(user!.userId, passwordController.text);
                Navigator.of(context).pop(); // Modalı kapat
              },
              child: Text(
                'Admin Ol',
                style: TextStyle(color: appcolorred),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> addAdmin(int userId, String text) async {
    final url = Uri.parse(API.adminadd);
    if (userId != null) {
      return http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'password': text,
        },
      ).then((response) {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['success'] == true) {
            Get.snackbar(
              successTitle,
              successadminadd,
              backgroundColor: greenColor,
              colorText: whiteColor,
              duration: const Duration(seconds: 3),
            );
            Get.offAllNamed('/login');
          } else {
           
          }
        }
      });
      
    } else {
      Get.snackbar(
        errorTitle,
        erorHostNotFound,
        backgroundColor: errorred,
        colorText: whiteColor,
        duration: const Duration(seconds: 3),
      );
    }
  }

