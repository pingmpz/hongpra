import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

class MyConfirmPage extends StatefulWidget {
  final String recieverId;
  final String amuletId;
  const MyConfirmPage(this.recieverId, this.amuletId);

  @override
  _MyConfirmPageState createState() => _MyConfirmPageState();
}

class _MyConfirmPageState extends State<MyConfirmPage> {
  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double cardPadding = 8.0;
    double columnSpace = 10.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double buttonWidth = (screenWidth - (screenEdge * 3)) / 2;
    double buttonHeight = 40.0;

    //------------------ Sample Variables ------------------
    List<String> headers = [
      'วันที่',
      'ผู้ส่งมอบ',
      'ผู้รับ',
      'รหัสใบรับรอง',
    ];

    List<String> texts = [
      '24 ตุลาคม 2563',
      'สมศักดิ์',
      'ธนกร',
      '19945A007',
    ];

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: MyConfig.whiteColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Text('', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );

    Widget detailBox = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child: Text("ข้อมูลการส่งมอบ", style: MyConfig.normalBoldText4)),
              SizedBox(height: columnSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[0], style: MyConfig.smallBoldText1),
                  Text(texts[0], style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[1], style: MyConfig.smallBoldText1),
                  Text(texts[1], style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[2], style: MyConfig.smallBoldText1),
                  Text(texts[2], style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[3], style: MyConfig.smallBoldText1),
                  Text(texts[3], style: MyConfig.smallText1),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    Widget buttonBox = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonTheme(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              color: MyConfig.greenColor,
              child: Text('ตกลง', style: MyConfig.buttonText),
              onPressed: () => {
              },
            ),
          ),
          SizedBox(width: screenEdge),
          ButtonTheme(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              color: MyConfig.redColor,
              child: Text('ยกเลิก', style: MyConfig.buttonText),
              onPressed: () => {
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: myAppBar,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          margin: EdgeInsets.all(screenEdge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              detailBox,
              SizedBox(height: desireHeight * 0.01),
              buttonBox,
            ],
          ),
        ),
      ),
    );
  }
}
