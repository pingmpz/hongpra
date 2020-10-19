import 'dart:math';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

class MyDetailPage extends StatefulWidget {
  final int index;
  const MyDetailPage(this.index);

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

    String path = "assets/images/lg.jpg";
    List<String> texts = [
      'พระกริ่งชัย-วัฒน์ทั่วไป',
      'ชื่อพระ : พระชัยวัฒน์',
      'พิมพ์พระ : พิมพ์อุดมีกริ่ง',
      'เนื้อพระ : ทองเหลือง',
      'สถานที่ : วัดชนะสงคราม พ.ศ. 2484',
      'วันที่รับรอง : 8 พฤศจิกายน 2562'
    ];

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: MyConfig.whiteColor,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Hero(tag: 'hero' + widget.index.toString(), child: Image(image: AssetImage(path)))),
              SizedBox(height: desireHeight * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(texts[0], style: MyConfig.largeText1),
                  Text(""),
                  Text(texts[1], style: MyConfig.smallText1),
                  Text(texts[2], style: MyConfig.smallText1),
                  Text(texts[3], style: MyConfig.smallText1),
                  Text(texts[4], style: MyConfig.smallText1),
                  Text(texts[5], style: MyConfig.smallText1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
