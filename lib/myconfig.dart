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

  static TextStyle normalText1 = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: blackColor);
  static TextStyle normalText2 = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: whiteColor);
  static TextStyle normalText3 =
      TextStyle(fontFamily: fontFamily1, fontSize: normalSize, color: redColor);
  static TextStyle normalText4 = TextStyle(
      fontFamily: fontFamily1, fontSize: normalSize, color: themeColor1);

  static TextStyle normalBoldText1 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: blackColor,
      fontWeight: bold);
  static TextStyle normalBoldText2 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: whiteColor,
      fontWeight: bold);
  static TextStyle normalBoldText3 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: redColor,
      fontWeight: bold);
  static TextStyle normalBoldText4 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: normalSize,
      color: themeColor1,
      fontWeight: bold);

  static TextStyle smallText1 = TextStyle(
      fontFamily: fontFamily1, fontSize: smallSize, color: blackColor);
  static TextStyle smallText5 =
      TextStyle(fontFamily: fontFamily1, fontSize: smallSize, color: greyColor);

  static TextStyle smallBoldText1 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: smallSize,
      color: blackColor,
      fontWeight: bold);

  static TextStyle largeBoldText1 = TextStyle(
      fontFamily: fontFamily1,
      fontSize: largeSize,
      color: blackColor,
      fontWeight: bold);
  static TextStyle largeBoldText4 = TextStyle(
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
    int month = dateTime.month - 1;
    int year = dateTime.year + 543;
    String result =
        day.toString() + " " + monthName[month] + " " + year.toString();
    return result;
  }

  static String splitDateTimeText(DateTime dateTime) {

    String hoursString = "";
    String minutesString = "";


    if (dateTime == null) return "";
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year + 543;
    int hours = dateTime.hour;
    int minutes = dateTime.minute;

    if(hours < 10){
      hoursString = "0"+hours.toString();
    }else{
      hoursString = hours.toString();
    }

    if(minutes < 10){
      minutesString = "0"+minutes.toString();
    }else{
      minutesString = minutes.toString();
    }

    String result = day.toString() +
        month.toString() +
        year.toString().substring(2, year.toString().length) +
        hoursString +
        minutesString;
    return result;
  }
}
