import 'package:bidtake/consts/consts.dart';

void showModalBottomSheetWithText(BuildContext context, String title, String text) {
   showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: title.text.color(appcolorred).xl2.make(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: text.text.make(),
              ),
            ),
          ),
        ],
      ).box.gray400.topRounded().make();
    },
  );
}