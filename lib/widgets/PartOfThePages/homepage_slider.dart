import 'package:bidtake/consts/consts.dart';
import 'package:http/http.dart' as http;

class SliderWidget extends StatefulWidget {
  
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  List<SliderImage> _imageList = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  Future<void> getImages() async {
    try {
      var res = await http.get(Uri.parse(API.slider));
      if (this.mounted && res.statusCode == 200) {
        var sliderjson = jsonDecode(res.body);
        if (sliderjson["success"]) {
          setState(() {
            var jsonData = sliderjson["images"];
            _imageList = List<SliderImage>.from(
                jsonData.map((item) => SliderImage.fromJson(item)));
          });
        }
      }
    } catch (e) {
      Get.snackbar(errorTitle, errorSliderHomepage, snackPosition: SnackPosition.BOTTOM, backgroundColor: errorred, colorText: whiteColor);
    }
  }

  @override
  Widget build(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.3,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },),
         

            items: _imageList.map((item) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: item.imageUrl == null ? Noimage() : Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
            ),
            ),
            )).toList(),
            
            ),
        ),
          
      15.heightBox,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageIndicator(),
      ),
    ],
  );
}

List<Widget> _buildPageIndicator() {
  List<Widget> list = [];
  for (int i = 0; i < _imageList.length; i++) {
    list.add(i == _currentIndex ? _indicator(true) : _indicator(false));
  }
  return list;
}

Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    margin: margin8,
    height: height8,
    width: isActive ? width16 : width10,
    decoration: BoxDecoration(
      color: isActive ? appcolorred : appcolor,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}
}