import 'package:bidtake/consts/consts.dart';
import 'package:bidtake/widgets/PartOfThePages/admin_all_products_listele.dart';
import 'package:bidtake/widgets/PartOfThePages/admin_auction_listele.dart';
import 'package:bidtake/widgets/common/Imageloader.dart';


class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    toolbarHeight: 10 , // Adjust the toolbar height
    bottom: TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Yayındakiler'),
        Tab(text: 'Tüm Ürünlerim'),
      ],
    ),
  ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AdminProductsScreen(), // "Ürünlerim" sayfası
          AdminAllProductsScreen(), // "Önceki Ürünlerim" sayfası
        ],
      ),
    );
  }
}

