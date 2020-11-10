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
  static TextStyle normalTextGrey = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: greyColor);

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
    String result = day.toString() + " " + monthName[month - 1] + " " + year.toString();
    return result;
  }

  static String timeText(DateTime dateTime) {
    if (dateTime == null) return "";
    String hourText = (dateTime.hour < 10) ? "0" + dateTime.hour.toString() : dateTime.hour.toString();
    String minuteText = (dateTime.minute < 10) ? "0" + dateTime.minute.toString() : dateTime.minute.toString();
    String result = hourText + "." + minuteText;
    return result;
  }
}

/*
  PROBLEMS
  - [Overall] Card Text Overflow
  - [Overall] Keyboard Overflow
  - [Splash] Error ??
  - [Detail/Confirm] Card Text Overflow
  UNFINISHED
  - [Overall] Query optimization
  - [Setting] UI
  - [Splash] UI
  - [Confirm] At loading animation when confirm -> On fail ? -> Connection lost
  DONE
  - [Main] Static search box
  OBS
  - [Detail] ImageList not correct sorting. -> Corrected ?
*/
