import 'package:bidtake/consts/consts.dart';

Widget ourButton({String? title, onPressed, textColor, color}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color, // tıklandığındaki renk
        padding: padding16all),
    onPressed: onPressed,
    child: title!.text.color(textColor).fontFamily(bold).size(size16).make(),
  );
}
