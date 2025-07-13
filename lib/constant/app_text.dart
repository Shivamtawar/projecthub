import 'package:flutter/material.dart';
import 'package:projecthub/constant/app_color.dart';

class AppText {
  static double font12Px = 12;
  static double font18Px = 18;
  static double font15Px = 15;

  static String fontFamily = "SFProText";
  static TextStyle bigHeddingStyle1a = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle bigHeddingStyle1b = const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle subHeddingStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 76, 76, 76),
  );
  static TextStyle heddingStyle2bBlack = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 76, 76, 76),
  );
  static TextStyle heddingStyle2bWhite = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 244, 244, 244),
  );

  static TextStyle textFieldHintTextStyle = const TextStyle(
    fontSize: 15,
    fontFamily: 'Gilroy',
    color: Color(0XFF9B9B9B),
    fontWeight: FontWeight.bold,
  );

  static TextStyle errorMassageTextStyle = const TextStyle(
    fontSize: 12,
    fontFamily: 'Gilroy',
    color: Color.fromARGB(255, 177, 22, 22),
    fontWeight: FontWeight.w400,
  );
  static TextStyle appPrimaryText = TextStyle(
    fontSize: 17,
    fontFamily: 'Gilroy',
    color: AppColor.primaryColor,
    fontWeight: FontWeight.w600,
  );
}
