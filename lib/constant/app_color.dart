import 'package:flutter/material.dart';

class AppColor {
  static Color primaryColor = Color.fromARGB(255, 35, 64, 143);
  static Color secYello = const Color(0XFFFFC403);
  static Color bgColor = "#FBFBFB".toColor();
  static Color iconBlack = Color.fromARGB(255, 80, 80, 80);
  static Color iconPrimary = const Color(0XFF23408F);
  static Color textColor = const Color.fromARGB(187, 0, 0, 0);
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
