import 'dart:math';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

class MyDetailPage extends StatefulWidget {
  final int id;
  const MyDetailPage(this.id);

  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double innerEdge = 5.0;
    double imageRatio = 0.33; // 33%
    double dotSize = 5.0;
    double dotSpace = dotSize * 2.5;
    double certificateButtonWidth = 100;
    double certificateButtonHeight = 40;
    double handinButtonWidth = 100;
    double handinButtonHeight = 40;
    double buttonCurve = 12.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth < minWidth)
        ? minEdge
        : min(screenWidth - minWidth, maxEdge);

    List<Image> photos = [
      Image(image: AssetImage("assets/images/logo.png")),
      Image(image: AssetImage("assets/images/logo.png")),
      Image(image: AssetImage("assets/images/logo.png")),
      Image(image: AssetImage("assets/images/logo.png")),
      Image(image: AssetImage("assets/images/logo.png")),
    ];

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: MyConfig.themeColor2,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('ห้องพระ', style: MyConfig.smallTitleText),
      centerTitle: true,
    );

    Widget titleText = Container(
      margin: EdgeInsets.all(innerEdge),
      child: Center(
          child: Text('พระเครื่องบูชา', style: MyConfig.amuletTitleText)),
    );

    Widget myCorousel = Container(
      height: screenHeight * imageRatio,
      child: Carousel(
        images: photos,
        dotSize: dotSize,
        dotSpacing: dotSpace,
        dotColor: MyConfig.whiteColor,
        dotBgColor: Colors.transparent,
        indicatorBgPadding: innerEdge,
        //borderRadius: true,
      ),
    );

    Widget amuletDetailBox = Container(
      color: MyConfig.themeColor5,
      padding: EdgeInsets.all(innerEdge),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('คำอธิบาย', style: MyConfig.headerText),
              Text('พระพุทธรูป', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ประเภท', style: MyConfig.headerText),
              Text('ทองคำแท้', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รุ่น', style: MyConfig.headerText),
              Text('2020', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('สร้างโดย', style: MyConfig.headerText),
              Text('อาจารย์ เคน', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ครอบครองโดย', style: MyConfig.headerText),
              Text('บุรินทร์', style: MyConfig.normalText1),
            ],
          ),
        ],
      ),
    );

    Widget certificateButton = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: innerEdge),
        child: ButtonTheme(
          minWidth: certificateButtonWidth,
          height: certificateButtonHeight,
          child: RaisedButton(
            onPressed: () => {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonCurve),
            ),
            color: MyConfig.themeColor2,
            child: Text('ดูใบรับรอง', style: MyConfig.buttonText),
          ),
        ),
      ),
    );

    Widget certificateDetailBox = Container(
      color: MyConfig.themeColor5,
      padding: EdgeInsets.all(innerEdge),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รหัสใบรับรอง', style: MyConfig.headerText),
              Text('10110012', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ออกโดย', style: MyConfig.headerText),
              Text('หัวหน้าสมาคมพระเครื่องไทย', style: MyConfig.normalText1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ออกวันที่', style: MyConfig.headerText),
              Text('16 ตุลาคม 2563', style: MyConfig.normalText1),
            ],
          ),
        ],
      ),
    );

    Widget handinButton = Container(
      margin: EdgeInsets.only(left: innerEdge),
      child: ButtonTheme(
        minWidth: handinButtonWidth,
        height: handinButtonHeight,
        child: RaisedButton(
          onPressed: () => {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonCurve),
          ),
          color: MyConfig.themeColor3,
          child: Text('ส่งมอบ', style: MyConfig.buttonText),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleText,
              SizedBox(height: desireHeight * 0.01),
              myCorousel,
              SizedBox(height: desireHeight * 0.01),
              amuletDetailBox,
              SizedBox(height: desireHeight * 0.01),
              certificateButton,
              SizedBox(height: desireHeight * 0.01),
              certificateDetailBox,
              SizedBox(height: desireHeight * 0.01),
              handinButton,
            ],
          ),
        ),
      ),
    );
  }
}
