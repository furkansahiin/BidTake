import 'package:bidtake/consts/consts.dart';
import 'package:bidtake/widgets/PartOfThePages/favorites_list_screen.dart';
import 'package:http/http.dart' as http;

class FavoriteFragmentsScreen extends StatelessWidget {
  const FavoriteFragmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                  title: favorilertext.text.size(20).make(),
                  centerTitle: true,
                ),
              20.heightBox,
                  const FavoritesListScreen(),
                  20.heightBox,
            ],
          ),
        )
      ),
    );
  }
}
