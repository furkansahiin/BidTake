class API {
  // static const String HOSTCONNECT = "http://192.168.56.1/bidspace";
  static const String HOSTCONNECT = "http://212.68.47.244";

  static const String HOSTCONNECTUSER = "$HOSTCONNECT/user";
  static const String HOSTCONNECTHOMEPAGE = "$HOSTCONNECT/homepage";
  static const String HOSTCONNECTAUCTIONS = "$HOSTCONNECT/auctions";
  static const String HOSTCONNECTFAVORITES = "$HOSTCONNECT/favorite";

  // USER SİGNUP
  static const String validateEmail = "$HOSTCONNECTUSER/validate_email.php";
  static const String signUp = "$HOSTCONNECTUSER/signup.php";

  // USER LOGIN
  static const String login = "$HOSTCONNECTUSER/login.php";

  static const String favoritesaddRemove = "$HOSTCONNECTFAVORITES/favorites.php";
  static const String favoritesList = "$HOSTCONNECTFAVORITES/favoritesList.php";

  // HOMEPAGE SLIDER
  static const String slider = "$HOSTCONNECTHOMEPAGE/sliderimages.php";
  static const String categorylist = "$HOSTCONNECTHOMEPAGE/categorylist.php";
  static const String productlist = "$HOSTCONNECTHOMEPAGE/productlist.php";
  static const String searchbar = "$HOSTCONNECTHOMEPAGE/searchbar.php";
  static const String productsadd = "$HOSTCONNECTUSER/productsAdd.php";
  static const String profileedit = "$HOSTCONNECTUSER/profileedit.php";

  static const String adminadd = "$HOSTCONNECTUSER/adminadd.php";
  // AUCTION ADD
  static const String auctionadd = "$HOSTCONNECTAUCTIONS/auctionAdd.php";
  static const String auctiondelete = "$HOSTCONNECTAUCTIONS/auctionDelete.php";

  static const String bidsAdd = "$HOSTCONNECTAUCTIONS/bidsAdd.php";

  // product detail
  static const String userinfo = "$HOSTCONNECTUSER/userinfo.php";

  // AUCTION
  static const String auctionlist = "$HOSTCONNECTAUCTIONS/auctionlist.php";
  static const String productdetail = "$HOSTCONNECTAUCTIONS/product_detail.php";
}
