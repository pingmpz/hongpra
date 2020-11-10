import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

import 'Data/Amulet.dart';
import 'Data/Certificate.dart';
import 'Data/Person.dart';

class MyConfirmPage extends StatefulWidget {
  final Person senderUser;
  final Person receiverUser;
  final Amulet amulet;
  final Certificate certificate;
  const MyConfirmPage(this.senderUser, this.receiverUser, this.amulet, this.certificate);

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
    await _firestoreInstance.collection("users").doc(loginUser.uid).collection("history").add({
      "certificateId": widget.certificate.id,
      "date": FieldValue.serverTimestamp(),
      "receiverId": widget.receiverUser.id,
      "senderId": widget.senderUser.id,
      "type": 1
    });
    print('# (1/5) Created history to sender');

    //-- Create History of Receiver
    await _firestoreInstance.collection("users").doc(widget.receiverUser.id).collection("history")
        .add({
      "certificateId": widget.certificate.id,
      "date": FieldValue.serverTimestamp(),
      "receiverId": widget.receiverUser.id,
      "senderId": widget.senderUser.id,
      "type": 2
    });
    print('# (2/5) Created history to receiver');

    DocumentSnapshot resultAmulet = await _firestoreInstance.collection("users").doc(loginUser.uid).collection("amulet").doc(widget.amulet.id).get();
    print('# (3/5) Get amulet info');

    //-- Add Amulet to Receiver
    await _firestoreInstance.collection("users").doc(widget.receiverUser.id).collection("amulet").doc(widget.amulet.id).set(resultAmulet.data());
    print('# (4/5) Added amulet to receiver');

    //-- Remove Amulet of Sender
    await _firestoreInstance.collection("users").doc(loginUser.uid).collection("amulet").doc(widget.amulet.id).delete();
    print('# (5/5) Removed amulet from sender');
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

    Widget detailBox = Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child:
                      Text("ข้อมูลการส่งมอบ", style: MyConfig.normalBoldTextTheme1)),
              SizedBox(height: columnSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('วันที่', style: MyConfig.smallBoldTextBlack),
                  Text(MyConfig.dateText(DateTime.now()),
                      style: MyConfig.smallTextBlack),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ผู้ส่ง', style: MyConfig.smallBoldTextBlack),
                  Text(widget.senderUser.getFullName(), style: MyConfig.smallTextBlack),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ผู้รับ', style: MyConfig.smallBoldTextBlack),
                  Text(widget.receiverUser.getFullName(), style: MyConfig.smallTextBlack),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('รหัสใบรับรอง', style: MyConfig.smallBoldTextBlack),
                  Text(widget.certificate.id, style: MyConfig.smallTextBlack),
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
