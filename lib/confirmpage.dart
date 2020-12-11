//-- Flutter Materials
import 'dart:math';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/Certificate.dart';
import 'package:hongpra/Model/Person.dart';

class MyConfirmPage extends StatefulWidget {
  final Person senderUser;
  final Person receiverUser;
  final Certificate certificate;
  const MyConfirmPage(this.senderUser, this.receiverUser, this.certificate);

  @override
  _MyConfirmPageState createState() => _MyConfirmPageState();
}

class _MyConfirmPageState extends State<MyConfirmPage> {
  //--
  bool _isLoading = false;
  bool _isLoaded = false;

  // FireStore and FireAuth instance
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
  }


  void confirm() async {
    setState(() {
      _isLoading = true;
    });
    print('### START UPDATE ###');

    //-- Create History of Sender
    await _firestoreInstance.collection("histories").add({
      "certificateId": widget.certificate.id,
      "date": FieldValue.serverTimestamp(),
      "receiverId": widget.receiverUser.docId,
      "senderId": widget.senderUser.docId,
      "userId": widget.senderUser.docId,
    });
    print('# (1/3) Created History of Sender');

    //-- Create History of Sender
    await _firestoreInstance.collection("histories").add({
      "certificateId": widget.certificate.id,
      "date": FieldValue.serverTimestamp(),
      "receiverId": widget.receiverUser.docId,
      "senderId": widget.senderUser.docId,
      "userId": widget.receiverUser.docId,
    });
    print('# (2/3) Created History of Receiver');

    //-- Update Certificate
    await _firestoreInstance.collection("certificates").doc(widget.certificate.docId).update({"userId": widget.receiverUser.docId});
    print('# (3/3) Updated Certificate');
    print('### END UPDATE ###');

    setState(() {
      _isLoading = false;
      _isLoaded = true;
    });
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
  }

  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double cardPadding = 8.0;
    double columnSpace = 10.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double buttonWidth = (screenWidth - (screenEdge * 3)) / 2;
    double buttonHeight = 40.0;

    //-------------------------------------------------------------------------------------------------------- Widgets

    Widget myAppBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (! _isLoading && ! _isLoaded) ? Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: MyConfig.whiteColor,
                onPressed: () => back(),
              ),
            ),
          ) : SizedBox(),
          Text('', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );

    Widget buildHeaderText(String text) => Center(child: Text(text, style: MyConfig.mediumBoldTextTheme1));

    Widget buildTitleText(String text) => Expanded(flex:27,  child: Text(text, style: MyConfig.normalBoldTextBlack));

    Widget buildDetailText(String text) => Expanded(flex:73,  child: Text(text, style: MyConfig.normalTextBlack));

    Widget buildRow(String title, String detail) => Row(children: [buildTitleText(title), buildDetailText(detail)]);

    Widget detailBox = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildHeaderText("ข้อมูลการส่งมอบ"),
              SizedBox(height: columnSpace),
              buildRow('วันที่', MyConfig.dateText(DateTime.now())),
              buildRow('ผู้ส่งมอบ', widget.senderUser.getFullName()),
              buildRow('ผู้รับมอบ', widget.receiverUser.getFullName()),
              buildRow('รหัสใบรับรอง', widget.certificate.id),
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
              onPressed: () => confirm(),
            ),
          ),
          SizedBox(width: screenEdge),
          ButtonTheme(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              color: MyConfig.redColor,
              child: Text('ยกเลิก', style: MyConfig.buttonText),
              onPressed: () => back(),
            ),
          ),
        ],
      ),
    );

    Widget loadingEffect = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: desireHeight * 0.02),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)),
            SizedBox(height: desireHeight * 0.02),
            Text('โปรดรอสักครู่ กำลังทำการส่งมอบ', style: MyConfig.normalBoldTextTheme1),
          ],
        ),
      ),
    );

    Widget loadedEffect = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (true) ? Icon(
              Icons.check_circle_outline,
              color: MyConfig.greenColor,
              size: 60.0,
            ) : Icon(
                Icons.clear_outlined,
                color: MyConfig.redColor,
                size: 60.0,
              ),
            SizedBox(height: desireHeight * 0.02),
            (true) ? Text('ส่งมอบสำเร็จ กลับสู่หน้าหลัก', style: MyConfig.normalBoldTextGreen) : Text('ส่งมอบไม่สำเร็จ', style: MyConfig.normalBoldTextRed),
        ]
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page

    return Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: myAppBar,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          margin: EdgeInsets.all(screenEdge),
          child: (_isLoading) ? loadingEffect : (_isLoaded) ? loadedEffect : Column(
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
