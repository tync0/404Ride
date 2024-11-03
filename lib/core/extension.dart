import 'package:flutter/material.dart';

const String apiKey = 'AIzaSyAbwhoAZEWMdG-x8_sZBaH0Lq13-gNAboY';

extension AppExtension on BuildContext {
  //size
  double get mediaQueryHeight => MediaQuery.sizeOf(this).height;
  double get mediaQueryWidth => MediaQuery.sizeOf(this).width;
  double dynamicHeight(double value) => mediaQueryHeight * value;
  double dynamicWidth(double value) => mediaQueryWidth * value;

  //color
  Color get mainColor => const Color(0xFF8450EC);
  Color get borderColor => const Color(0xFFEDEDED);
  Color get greyColor => const Color(0xFFA7A7A7);
  Color get redColor => const Color(0xFFFF0808);
  Color get insideGrey => const Color(0xFFFBFBFB);

  //
  TextStyle get textStyle => const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );
}
