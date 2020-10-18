import 'package:flutter/material.dart';

class MyConfig {

  static Color themeColor1 = Color(0xff262626);
  static Color themeColor2 = Color(0xffF5C15B);
  static Color themeColor3 = Color(0xffA5A5A5);
  static Color themeColor4 = Color(0xffF53232);
  static Color themeColor5 = Color(0xff383838);
  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;

  static String fontFamily1 = 'Roboto';
  // EkkamaiNew
  static String fontFamily2 = 'Srisakdi';

  static FontWeight bold = FontWeight.bold;

  static TextStyle normalText1 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: whiteColor);
  static TextStyle normalText2 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: blackColor);
  static TextStyle normalText3 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: themeColor4);
  static TextStyle headerText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: whiteColor, fontWeight: bold);
  static TextStyle linkText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: themeColor2);
  static TextStyle buttonText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: blackColor, fontWeight: bold);
  static TextStyle largeTitleText = TextStyle(fontFamily: fontFamily2, fontSize: 86, color: themeColor2, fontWeight: bold);
  static TextStyle mediumTitleText = TextStyle(fontFamily: fontFamily2, fontSize: 48, color: themeColor2, fontWeight: bold);
  static TextStyle smallTitleText = TextStyle(fontFamily: fontFamily2, fontSize: 40, color: themeColor2, fontWeight: bold);
  static TextStyle amuletTitleText = TextStyle(fontFamily: fontFamily1, fontSize: 24, color: whiteColor, fontWeight: bold);

}