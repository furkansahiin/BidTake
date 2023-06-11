import 'package:bidtake/consts/consts.dart';

Widget bgWidget({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color.fromRGBO(77, 160, 176,1),
              Color.fromRGBO(211, 157, 56,1),
            ],
            tileMode: TileMode.clamp,
          ),
    ),
    child: child,
  );
}
