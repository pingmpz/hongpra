import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:hongpra/transferpage.dart';
import 'package:photo_view/photo_view.dart';

class MyDetailPage extends StatefulWidget {
  final String id;
  const MyDetailPage(this.id);

  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  bool _isImageShown = false;
  bool _isArrowLeftShown = false;
  bool _isArrowRightShown = false;
  int currentIndex;
  List<String> currentPaths;
  Amulet amulet = new Amulet("", [], "", "", "", "");
  Certificate certificate= new Certificate("", "", "", null);

  //------------------ Custom Functions ------------------
  @override
  void initState() {
    super.initState();
    setState(() {
      getAmulet();
    });
  }

  Future getAmulet() async {
    String id = widget.id;
    final checkUser = FirebaseAuth.instance.currentUser.uid;
    final _firestoreInstance = FirebaseFirestore.instance;

      _firestoreInstance
          .collection("users")
          .doc(checkUser)
          .collection("amulet")
          .doc(id)
          .get()
          .then((value) {
            setState(() {
              amulet = new Amulet(
                (value.data()['amuletId'] != null) ? value.data()['amuletId'] : "",
                (value.data()['amuletImageList'] != null) ? HashMap<String, dynamic>.from(value.data()['amuletImageList']).values.toList().cast<String>() : [],
                (value.data()['name'] != null) ? value.data()['name'] : "",
                (value.data()['categories'] != null) ? value.data()['categories'] : "",
                (value.data()['texture'] != null) ? value.data()['texture'] : "",
                (value.data()['information'] != null) ? value.data()['information'] : "",
              );

              certificate = new Certificate(
                (value.data()['certificateId'] != null) ? value.data()['certificateId'] : "",
                (value.data()['certificateImage'] != null) ? value.data()['certificateImage'] : "",
                (value.data()['confirmBy'] != null) ? value.data()['confirmBy'] : "",
                (value.data()['confirmDate'] != null) ? value.data()['confirmDate'].toDate() : null,
              );
            });
      });

  }

  void enterFullScreenImage(List<String> paths, int index) {
    setState(() {
      currentPaths = paths;
      currentIndex = index;
      _isImageShown = true;
      _isArrowLeftShown = (index == 0) ? false : true;
      _isArrowRightShown = (index == paths.length - 1) ? false : true;
    });
  }

  void exitFullScreenImage() {
    setState(() {
      _isImageShown = false;
    });
  }

  void nextImage() {
    setState(() {
      currentIndex = currentIndex + 1;
      _isArrowLeftShown = (currentIndex == 0) ? false : true;
      _isArrowRightShown =
          (currentIndex == currentPaths.length - 1) ? false : true;
    });
  }

  void previousImage() {
    setState(() {
      currentIndex = currentIndex - 1;
      _isArrowLeftShown = (currentIndex == 0) ? false : true;
      _isArrowRightShown =
          (currentIndex == currentPaths.length - 1) ? false : true;
    });
  }

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
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double carouselHeight = screenHeight * imageHeightRatio;
    double carouselWidth = screenWidth;
    double buttonWidth = screenWidth - (screenEdge * 4);
    double buttonHeight = 40.0;

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
        Center(child: Text(amulet.name, style: MyConfig.largeBoldText1));

    List<Widget> buildImages(List<String> paths) {
      return List<Widget>.generate(
        paths.length,
        (index) => GestureDetector(
          //child: Image.network(paths[index]),
          child: (paths[index] != null && paths[index] != "" && paths[index].isNotEmpty) ? Image.network(paths[index]) : Image(image: AssetImage("assets/images/notfound.png")),
          onDoubleTap: () => {enterFullScreenImage(paths, index)},
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

    Widget buildFullScreenImage() {
      return Container(
        color: MyConfig.greyColor.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            PhotoView(
              imageProvider: NetworkImage(currentPaths[currentIndex]),
            ),
            Padding(
              padding: EdgeInsets.all(screenEdge),
              child: Material(
                color: MyConfig.transparentColor,
                child: Ink(
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () => {exitFullScreenImage()},
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (_isArrowLeftShown)
                      ? Padding(
                          padding: EdgeInsets.all(screenEdge),
                          child: Material(
                            color: MyConfig.transparentColor,
                            child: Ink(
                              child: IconButton(
                                icon: Icon(Icons.chevron_left),
                                color: MyConfig.whiteColor,
                                onPressed: () => {previousImage()},
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  (_isArrowRightShown)
                      ? Padding(
                          padding: EdgeInsets.all(screenEdge),
                          child: Material(
                            color: MyConfig.transparentColor,
                            child: Ink(
                              child: IconButton(
                                icon: Icon(Icons.chevron_right),
                                color: MyConfig.whiteColor,
                                onPressed: () => {nextImage()},
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            )
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
                  Text(amulet.category, style: MyConfig.smallText1),
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
                  Text(MyConfig.dateText(certificate.confirmDate), style: MyConfig.smallText1),
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
                    onPressed: () => {
                      if (certificate.image != "") enterFullScreenImage([certificate.image], 0)
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
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyTransferPage(widget.id)))
          },
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
        if (_isImageShown) buildFullScreenImage(),
      ],
    );
  }
}

class Amulet {
  String id;
  List<String> images;
  String name;
  String category;
  String texture;
  String info;

  Amulet(
      this.id,
      this.images,
      this.name,
      this.category,
      this.texture,
      this.info,);
}

class Certificate {
  String id;
  String image;
  String confirmBy;
  DateTime confirmDate;

  Certificate(
      this.id,
      this.image,
      this.confirmBy,
      this.confirmDate,
      );
}
