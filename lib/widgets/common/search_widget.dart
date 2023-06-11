import 'package:http/http.dart' as http;
import 'package:bidtake/consts/consts.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchText;
  List<User> _userQList = [];
  List<Product> _productQList = [];
  List<Category> _categoryQList = [];
  bool _isModalVisible = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

Future<void> _performSearch(_searchText) async {
  if (_searchText!.isEmpty || _searchText!.length < 3) {
    setState(() {
      _userQList = [];
      _productQList = [];
      _categoryQList = [];
    });
  } else {
    final response = await http.get(Uri.parse("${API.searchbar}?q=$_searchText"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<User> userList = (data['users'] as List<dynamic>)
          .map((user) => User.fromJson(user))
          .toList();
      List<Product> productList = (data['products'] as List<dynamic>)
          .map((product) => Product.fromJson(product))
          .toList();
      List<Category> categoryList = (data['categories'] as List<dynamic>)
          .map((category) => Category.fromJson(category))
          .toList();

      if (userList.isNotEmpty) {
        setState(() {
          _userQList = userList;
          _isModalVisible = true;

        });
      } else if (productList.isNotEmpty) {
        setState(() {
          _productQList = productList;
          _isModalVisible = true;

        });
      } else if (categoryList.isNotEmpty) {
        setState(() {
          _categoryQList = categoryList;
          _isModalVisible = true;
        });
      }
    }
    }
  }


  @override
  Widget build(BuildContext context) {
   
  User? user;

  return FutureBuilder<User?>(
    future: RememberUserPrefs.readUserInfo(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        user = snapshot.data!;
        final usernameWidget = user!.username.text.uppercase.size(24).make();
        
        return Container(
          alignment: Alignment.center,
          height: containerheight150, // çünkü sonraki gelen widget alta gelsin
          child: Padding(
            padding: padding8all,
            child: Column(
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Padding(
        padding: padding16x,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcometext.text.size(24).make(),
                  5.heightBox,
                  user != null ? usernameWidget : " ".text.make(),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    GestureDetector(
      // onTap: () {
      //   Navigator.pushNamed(context, "/Bildirimler");
      // },
      child: Icon(
        Icons.notifications,
        color: appcolorred,
        size: 30,
      ),
    ),
  ],
),


    20.heightBox,
            TextFormField(
              controller: _searchController,
              onChanged: (_searchText) {
                _performSearch(_searchText);
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search, color: appcolor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: appcolorred),
                ),
                focusColor: appcolor,
                hintText: searchHint,
                filled: true,
                fillColor: whiteColor,
                hintStyle: TextStyle(color: textfieldGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: appcolor),
                ),
              ),
            ),
           ],
            ),
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
  }
}

