import 'package:bidtake/consts/consts.dart';

Widget custumTextFieldWidget(
    {String title = "", String hint = "", controller, onTap, keyboardType}) {
  return Column(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      5.heightBox,
      TextField(
        cursorHeight: 20,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: TextInputAction.next, // klavyede enter tuşu
        decoration: InputDecoration(
          contentPadding: padding16all,
          hintText: hint,
          hintStyle: TextStyle(
            color: textfieldtextGrey,
            fontFamily: regular,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: lightGrey,
          isDense: true,
        ),
      ),
      10.heightBox,
    ],
  );
}

Widget passwordtextfield({
  String hint = "",
  textInputAction,
  controller,
  onTap,
  isObsecure,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      5.heightBox,
      TextField(
        cursorHeight: 20,
        controller: controller,
        textInputAction: textInputAction,
        obscureText: isObsecure.value,
        decoration: InputDecoration(
          contentPadding: padding16all,
          hintText: hint,
          hintStyle: TextStyle(
            color: textfieldtextGrey,
            fontFamily: regular,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: lightGrey,
          isDense: true,
          suffixIcon: Obx(
            () => GestureDetector(
              onTap: () {
                isObsecure.value = !isObsecure.value;
              },
              child: Icon(
                isObsecure.value ? Icons.visibility : Icons.visibility_off,
                color: blackColor,
              ),
            ),
          ),
        ),
      ),
      10.heightBox,
    ],
  );
}
