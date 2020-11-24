//-- Flutter Materials
import 'dart:math';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/transferpage.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/Certificate.dart';
//-- External Libraries
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyDetailPage extends StatefulWidget {
  final Certificate certificate;
  const MyDetailPage(this.certificate);

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

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
  }

  void transfer() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyTransferPage(widget.certificate)));
  }

  void back() {
    Navigator.pop(context);
  }

  void certificateFullScreen() {
    if (widget.certificate.certificateImage != "")
      enterFullScreenImage([widget.certificate.certificateImage], 0);
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

    Widget amuletTitleText = Center(
        child: Text(widget.certificate.name, style: MyConfig.largeBoldTextBlack));

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
            child: (widget.certificate.amuletImages.isNotEmpty)
                ? Carousel(
                    dotSize: dotSize,
                    dotSpacing: dotSize * 3,
                    indicatorBgPadding: dotSize,
                    autoplay: false,
                    images: buildImages(widget.certificate.amuletImages),
                  )
                : Image(image: AssetImage("assets/images/notfound.png")),
          ),
        ),
      ),
    );


    List<Widget> buildFullScreenImages(List<String> paths) {
      return [PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(paths[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
          );
        },
        itemCount: paths.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      )];
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

    Widget buildHeaderText(String text) => Center(child: Text(text, style: MyConfig.normalBoldTextTheme1));

    Widget buildTitleText(String text) => Expanded(flex:27,  child: Text(text, style: MyConfig.smallBoldTextBlack));

    Widget buildDetailText(String text) => Expanded(flex:73,  child: Text(text, style: MyConfig.smallTextBlack));

    Widget buildRow(String title, String detail) => Row(children: [buildTitleText(title), buildDetailText(detail)]);

    Widget detailBox = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildHeaderText("ข้อมูลพระ"),
              SizedBox(height: columnSpace),
              buildRow("ชื่อพระ", widget.certificate.name),
              buildRow("พิมพ์พระ", widget.certificate.category),
              buildRow("เนื้อพระ", widget.certificate.texture),
              buildRow("รายละเอียด", widget.certificate.info),
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
              buildHeaderText("ข้อมูลใบรับรอง"),
              SizedBox(height: columnSpace),
              buildRow("รหัสใบรับรอง", widget.certificate.id),
              buildRow("วันที่รับรอง", MyConfig.dateText(widget.certificate.confirmDate)),
              buildRow("รับรองโดย", widget.certificate.confirmBy),
              SizedBox(height: columnSpace),
              Center(
                child: ButtonTheme(
                  minWidth: buttonWidth,
                  height: buttonHeight,
                  child: RaisedButton(
                    color: (widget.certificate.certificateImage != "")
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
