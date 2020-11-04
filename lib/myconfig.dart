import 'package:flutter/material.dart';

class MyConfig {
  static String colorTheme1 = 'B22222';
  static Color themeColor1 = Color(int.parse('0xff' + colorTheme1));
  static String colorTheme2 = 'f9f9f9';
  static Color themeColor2 = Color(int.parse('0xff' + colorTheme2));

  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color greyColor = Colors.grey;
  static Color redColor = Color(0xffF53232);
  static Color greenColor = Colors.green;
  static Color transparentColor = Colors.transparent;

  static String fontFamily1 = 'Prompt';
  // EkkamaiNew , Prompt
  static String fontFamily2 = 'Srisakdi';

  static FontWeight bold = FontWeight.bold;

  static double normalSize = 14;
  static double smallSize = 12;
  static double largeSize = 24;

  static TextStyle normalTextBlack = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: blackColor);
  static TextStyle normalTextWhite = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: whiteColor);
  static TextStyle normalTextRed =
      TextStyle(fontFamily: fontFamily1, fontSize: normalSize, color: redColor);
  static TextStyle normalTextTheme1 = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: themeColor1);

  static TextStyle normalBoldTextBlack = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: blackColor,
      fontWeight: bold);
  static TextStyle normalBoldTextWhite = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: whiteColor,
      fontWeight: bold);
  static TextStyle normalBoldTextRed = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: redColor,
      fontWeight: bold);
  static TextStyle normalBoldTextTheme1 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: themeColor1,
      fontWeight: bold);

  static TextStyle normalBoldTextGreen = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: greenColor,
      fontWeight: bold);

  static TextStyle smallTextBlack = TextStyle(
      fontFamily: fontFamily1, fontSize: smallSize, color: blackColor);
  static TextStyle smallTextGrey =
      TextStyle(fontFamily: fontFamily1, fontSize: smallSize, color: greyColor);

  static TextStyle smallBoldTextBlack = TextStyle(
      fontFamily: fontFamily1,
      fontSize: smallSize,
      color: blackColor,
      fontWeight: bold);

  static TextStyle largeBoldTextBlack = TextStyle(
      fontFamily: fontFamily1,
      fontSize: largeSize,
      color: blackColor,
      fontWeight: bold);
  static TextStyle largeBoldTextRed = TextStyle(
      fontFamily: fontFamily1,
      fontSize: largeSize,
      color: redColor,
      fontWeight: bold
  );
  static TextStyle largeBoldTextTheme1 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: largeSize,
      color: themeColor1,
      fontWeight: bold);

  static TextStyle buttonText = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: whiteColor,
      fontWeight: bold);
  static TextStyle linkText = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: blackColor,
      fontWeight: bold);

  static TextStyle logoText = TextStyle(
      fontFamily: fontFamily2,
      fontSize: 86,
      color: whiteColor,
      fontWeight: bold);
  static TextStyle appBarTitleText = TextStyle(
      fontFamily: fontFamily1,
      fontSize: largeSize,
      color: whiteColor,
      fontWeight: bold);

  static List<String> monthName = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];

  static String dateText(DateTime dateTime) {
    if (dateTime == null) return "";
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year + 543;
    String result =
        day.toString() + " " + monthName[month - 1] + " " + year.toString();
    return result;
  }
}

/*
  PROBLEMS
  - [History] History time sorting problem.
  - [Overall] Card Text Overflow
  - [Overall] Keyboard Overflow
  - [History] Change tab while refreshing list get error message (not fatal ?)
  - [Transfer] Multi-tap at text field get error message (other text field?)
  UNFINISHED
  - [Overall] Query optimization
  - [Setting] UI
  - [Splash] UI
  - [Main] Stream builder !!?
  DONE
  - [Home] 3* Card Text Overflow -> Work ?
  - [Confirm] At loading animation when confirm -> On fail ?
  - [Detail] 4* ImageList not correct sorting. -> Corrected ?
  //-- On 04/11 Morning
  - [Detail] Fullscreen Images -> Working well ?
  - [Transfer] AlertDialog, Loading -> Need more test

*/
