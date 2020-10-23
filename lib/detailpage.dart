import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:hongpra/registerpage.dart';
import 'package:photo_view/photo_view.dart';

class MyDetailPage extends StatefulWidget {
  final int index;
  const MyDetailPage(this.index);

  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  bool _isImageShown = false;
  String currentPath = "";

  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double imageHeightRatio = 0.4;
    double dotSize = 5.0;
    double cardPadding = 8.0;
    double columnSpace = 10.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth < minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double carouselHeight = screenHeight * imageHeightRatio;
    double carouselWidth = screenWidth;
    double buttonWidth = screenWidth - (screenEdge * 4);
    double buttonHeight = 40.0;

    String certificatePath = "assets/images/certificate1.jpg";

    List<String> paths = [
      "assets/images/amulet1.jpg",
      "assets/images/amulet1.jpg",
      "assets/images/amulet1.jpg",
      "assets/images/amulet1.jpg",
      "assets/images/amulet1.jpg",
    ];

    String amuletName = 'พระกริ่งชัย-วัฒน์ทั่วไป';

    List<String> headers = [
      'ชื่อพระ',
      'พิมพ์พระ',
      'เนื้อพระ',
      'รายละเอียด',
      'รหัสใบรับรอง',
      'วันที่รับรอง',
      'รับรองโดย',
    ];

    List<String> texts = [
      'พระชัยวัฒน์',
      'พิมพ์อุดมีกริ่ง',
      'ทองเหลือง',
      'วัดชนะสงคราม พ.ศ. 2484',
      '19945A007',
      '8 พฤศจิกายน 2562',
      'หัวหน้าสมาคมพระเครื่องแห่งประเทศไทย',
    ];

    //------------------ Custom Methods ------------------

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
          Text('ข้อมูลพระ', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );

    Widget amuletTitleText =
        Center(child: Text(amuletName, style: MyConfig.largeBoldText));

    List<Widget> buildImages(List<String> paths) {
      return List<Widget>.generate(
        paths.length,
        (index) => GestureDetector(
          child: Image(image: AssetImage(paths[index])),
          onDoubleTap: () {
            setState(() {
              currentPath = paths[index];
              _isImageShown = true;
            });
          },
        ),
      );
    }

    Widget myCarousel = Container(
      width: carouselWidth,
      height: carouselHeight,
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Carousel(
              dotSize: dotSize,
              dotSpacing: dotSize * 3,
              indicatorBgPadding: dotSize,
              autoplay: false,
              images: buildImages(paths),
            ),
          ),
        ),
      ),
    );

    Widget buildFullScreenImage(String path) {
      return Container(
        color: MyConfig.greyColor.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            PhotoView(
              imageProvider: AssetImage(path),
            ),
            Padding(
              padding: EdgeInsets.all(screenEdge),
              child: Material(
                color: MyConfig.transparentColor,
                child: Ink(
                  // decoration: ShapeDecoration(
                  //   color: MyConfig.themeColor1,
                  //   shape: CircleBorder(),
                  // ),
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        currentPath = "";
                        _isImageShown = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget detailBox = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child: Text("ข้อมูลพระ", style: MyConfig.normalBoldText4)),
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

    Widget detailBox2 = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child:
                      Text("ข้อมูลใบรับรอง", style: MyConfig.normalBoldText4)),
              SizedBox(height: columnSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[4], style: MyConfig.smallBoldText1),
                  Text(texts[4], style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[5], style: MyConfig.smallBoldText1),
                  Text(texts[5], style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(headers[6], style: MyConfig.smallBoldText1),
                  Text(texts[6], style: MyConfig.smallText1),
                ],
              ),
              SizedBox(height: columnSpace),
              Center(
                child: ButtonTheme(
                  minWidth: buttonWidth,
                  height: buttonHeight,
                  child: RaisedButton(
                    color: MyConfig.greyColor,
                    child: Text('ดูใบรับรอง', style: MyConfig.buttonText),
                    onPressed: () {
                      setState(() {
                        currentPath = certificatePath;
                        _isImageShown = true;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget buttonBox = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          color: MyConfig.themeColor1,
          child: Text('ส่งมอบ', style: MyConfig.buttonText),
          onPressed: () => {},
        ),
      ),
    );

    return Stack(
      children: [
        Scaffold(
          backgroundColor: MyConfig.themeColor2,
          appBar: myAppBar,
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(screenEdge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  amuletTitleText,
                  SizedBox(height: desireHeight * 0.01),
                  myCarousel,
                  SizedBox(height: desireHeight * 0.01),
                  detailBox,
                  SizedBox(height: desireHeight * 0.01),
                  detailBox2,
                  SizedBox(height: desireHeight * 0.01),
                  buttonBox,
                ],
              ),
            ),
          ),
        ),
        if (_isImageShown) buildFullScreenImage(currentPath),
      ],
    );
  }
}
