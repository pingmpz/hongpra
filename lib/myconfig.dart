import 'package:flutter/material.dart';

class MyConfig {

  static Color themeColor1 = Color(0xff905a28);

  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color greyColor = Colors.grey;
  static Color redColor = Color(0xffF53232);
  static Color greenColor = Colors.green;

  static String fontFamily1 = 'Roboto';
  // EkkamaiNew
  static String fontFamily2 = 'Srisakdi';

  static FontWeight bold = FontWeight.bold;

  static TextStyle normalText1 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: blackColor);
  static TextStyle normalText2 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: whiteColor);
  static TextStyle normalText3 = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: redColor);

  static TextStyle smallText1 = TextStyle(fontFamily: fontFamily1, fontSize: 12, color: blackColor);
  static TextStyle smallText2 = TextStyle(fontFamily: fontFamily1, fontSize: 12, color: greyColor);

  static TextStyle largeText1 = TextStyle(fontFamily: fontFamily1, fontSize: 20, color: blackColor, fontWeight: bold);

  static TextStyle linkText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: blackColor, fontWeight: bold);

  static TextStyle largeHeaderText = TextStyle(fontFamily: fontFamily2, fontSize: 86, color: whiteColor, fontWeight: bold);
  static TextStyle appBarTitleText = TextStyle(fontFamily: fontFamily2, fontSize: 24, color: whiteColor, fontWeight: bold);

  static TextStyle titleText = TextStyle(fontFamily: fontFamily1, fontSize: 24, color: blackColor, fontWeight: bold);


  static TextStyle headerText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: blackColor, fontWeight: bold);
  static TextStyle headerText2 = TextStyle(fontFamily: fontFamily1, fontSize: 24, color: blackColor, fontWeight: bold);
  static TextStyle buttonText = TextStyle(fontFamily: fontFamily1, fontSize: 16, color: whiteColor, fontWeight: bold);
  static TextStyle amuletTitleText = TextStyle(fontFamily: fontFamily1, fontSize: 24, color: whiteColor, fontWeight: bold);

}