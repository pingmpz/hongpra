import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:hongpra/transferpage.dart';
import 'package:photo_view/photo_view.dart';

import 'Data/Amulet.dart';
import 'Data/Certificate.dart';

class MyDetailPage extends StatefulWidget {
  final Amulet amuletF;
  final Certificate certificateF;
  const MyDetailPage(this.amuletF, this.certificateF);

  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  //-- Fullscreen
  bool _isImageShown = false;
  int currentIndex;
  List<String> currentPaths;

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  //final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  Amulet amulet;
  Certificate certificate;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
    amulet = widget.amuletF;
    certificate = widget.certificateF;
  }

  void transfer() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyTransferPage(widget.amuletF.id)));
  }

  void back() {
    Navigator.pop(context);
  }

  void certificateFullScreen() {
    if (certificate.image != "") enterFullScreenImage([certificate.image], 0);
  }

  void enterFullScreenImage(List<String> paths, int index) {
    setState(() {
      currentPaths = paths;
      currentIndex = index;
      _isImageShown = true;
    });
  }

  void exitFullScreenImage() {
    setState(() {
      _isImageShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
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

    // double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);
    double carouselHeight = screenHeight * imageHeightRatio;
    double carouselWidth = screenWidth;
    double buttonWidth = screenWidth - (screenEdge * 4);
    double buttonHeight = 40.0;

    //-------------------------------------------------------------------------------------------------------- Widgets

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
                onPressed: () => back(),
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
        Center(child: Text(amulet.name, style: MyConfig.largeBoldText1));

    List<Widget> buildImages(List<String> paths) {
      return List<Widget>.generate(
        paths.length,
        (index) => GestureDetector(
          child: (paths[index].isNotEmpty)
              ? Image.network(paths[index])
              : Image(image: AssetImage("assets/images/notfound.png")),
          onDoubleTap: () => enterFullScreenImage(paths, index),
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
            child: (amulet.images.isNotEmpty)
                ? Carousel(
                    dotSize: dotSize,
                    dotSpacing: dotSize * 3,
                    indicatorBgPadding: dotSize,
                    autoplay: false,
                    images: buildImages(amulet.images),
                  )
                : Image(image: AssetImage("assets/images/notfound.png")),
          ),
        ),
      ),
    );

    List<Widget> buildFullScreenImages(List<String> paths) {
      return List<Widget>.generate(
        paths.length, (index) => PhotoView(imageProvider: NetworkImage(paths[index]),
            ),
      );
    }

    Widget fullScreenImages() {
      return Container(
        color: MyConfig.blackColor,
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: CarouselSlider(
                items: buildFullScreenImages(currentPaths),
                options: CarouselOptions(
                  autoPlay: false,
                  height: screenHeight,
                  viewportFraction: 1.0,
                  initialPage: currentIndex,
                  enableInfiniteScroll: false,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: screenEdge, top: screenEdge),
              child: Material(
                color: MyConfig.transparentColor,
                child: Ink(
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () => exitFullScreenImage(),
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
                  Text("ชื่อพระ", style: MyConfig.smallBoldText1),
                  Text(amulet.name, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("พิมพ์พระ", style: MyConfig.smallBoldText1),
                  Text(amulet.categories, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("เนื้อพระ", style: MyConfig.smallBoldText1),
                  Text(amulet.texture, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("รายละเอียด", style: MyConfig.smallBoldText1),
                  Text(amulet.info, style: MyConfig.smallText1),
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
                  Text("รหัสใบรับรอง", style: MyConfig.smallBoldText1),
                  Text(certificate.id, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("วันที่รับรอง", style: MyConfig.smallBoldText1),
                  Text(MyConfig.dateText(certificate.confirmDate),
                      style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("รับรองโดย", style: MyConfig.smallBoldText1),
                  Text(certificate.confirmBy, style: MyConfig.smallText1),
                ],
              ),
              SizedBox(height: columnSpace),
              Center(
                child: ButtonTheme(
                  minWidth: buttonWidth,
                  height: buttonHeight,
                  child: RaisedButton(
                    color: (certificate.image != "")
                        ? MyConfig.greenColor
                        : MyConfig.greyColor,
                    child: Text('ดูใบรับรอง', style: MyConfig.buttonText),
                    onPressed: () => certificateFullScreen(),
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
          onPressed: () => transfer(),
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
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
          if (_isImageShown) fullScreenImages(),
        ],
      ),
    );
  }
}
