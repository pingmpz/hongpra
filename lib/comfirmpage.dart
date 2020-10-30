import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

import 'mainpage.dart';

class MyConfirmPage extends StatefulWidget {
  final String receiverId;
  final String amuletId;
  const MyConfirmPage(this.receiverId, this.amuletId);

  @override
  _MyConfirmPageState createState() => _MyConfirmPageState();
}

class _MyConfirmPageState extends State<MyConfirmPage> {
  String senderName = "";
  String receiverName = "";
  String certificateId = "";

  // FireStore and FireAuth instance
  final _firestoreInstance = FirebaseFirestore.instance;
  final checkUser = FirebaseAuth.instance.currentUser.uid;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
    getMyInfo();
    getReceiverInfo();
    getAmuletInfo();
  }

  void getMyInfo() async {
    senderName = "";
    var result = await _firestoreInstance
        .collection("users")
        .where("userId", isEqualTo: checkUser)
        .get();
    result.docs.forEach((res) {
      setState(() {
        senderName = res.data()['firstname'];
      });
    });
  }

  void getReceiverInfo() async {
    receiverName = "";
    var result = await _firestoreInstance
        .collection("users")
        .where("userId", isEqualTo: widget.receiverId)
        .get();
    result.docs.forEach((res) {
      setState(() {
        receiverName = res.data()['firstname'];
      });
    });
  }

  void getAmuletInfo() async {
    certificateId = "";
    var result = await _firestoreInstance
        .collection("users")
        .doc(checkUser)
        .collection("amulet")
        .where("amuletId", isEqualTo: widget.amuletId)
        .get();
    result.docs.forEach((res) {
      setState(() {
        certificateId = res.data()['certificateId'];
      });
    });
  }

  void confirm() async {
    //-- Get Receiever and Sender Unique ID
    String recieverUserId = widget.receiverId;
    String senderUserId = checkUser;

    //-- Get amulet data
    String amuletId = "";
    List<String> amuletImageList = [];
    String categories = "";
    String certificateIdResult = "";
    String certificateImage = "";
    DateTime confirmDate;
    String confirmBy = "";
    String image = "";
    String information = "";
    String name = "";
    String texture = "";

    //-- Create History of Sender
    await _firestoreInstance
        .collection("users")
        .doc(checkUser)
        .collection("history")
        .add({
      "certificateId": certificateId,
      "date": FieldValue.serverTimestamp(),
      "recieverTd": recieverUserId,
      "senderId": senderUserId,
      "type": 1
    });

    //-- Create History of Receiver
    await _firestoreInstance
        .collection("users")
        .doc(widget.receiverId)
        .collection("history")
        .add({
      "certificateId": certificateId,
      "date": FieldValue.serverTimestamp(),
      "receiverTd": recieverUserId,
      "senderId": senderUserId,
      "type": 2
    });

    var resultAmulet = await _firestoreInstance
        .collection("users")
        .doc(checkUser)
        .collection("amulet")
        .doc(widget.amuletId)
        .get();

    amuletId = (resultAmulet.data()['amuletId'] != null) ? resultAmulet.data()['amuletId'] : "";
    amuletImageList = (resultAmulet.data()['amuletImageList'] != null) ? HashMap<String, dynamic>.from(resultAmulet.data()['amuletImageList']).values.toList().cast<String>() : [];
    categories = (resultAmulet.data()['categories'] != null) ? resultAmulet.data()['categories'] : "";
    certificateIdResult = (resultAmulet.data()['certificateId'] != null) ? resultAmulet.data()['certificateId'] : "";
    certificateImage = (resultAmulet.data()['certificateImage'] != null) ? resultAmulet.data()['certificateImage'] : "";
    confirmDate = (resultAmulet.data()['confirmDate'] != null) ? resultAmulet.data()['confirmDate'].toDate() : "";
    confirmBy = (resultAmulet.data()['confirmBy'] != null) ? resultAmulet.data()['confirmBy'] : "";
    image = (resultAmulet.data()['image'] != null) ? resultAmulet.data()['image'] : "";
    information = (resultAmulet.data()['information'] != null) ? resultAmulet.data()['information'] : "";
    name = (resultAmulet.data()['name'] != null) ? resultAmulet.data()['name'] : "";
    texture = (resultAmulet.data()['texture'] != null) ? resultAmulet.data()['texture'] : "";

    //-- Add Amulet to Receiver
    await _firestoreInstance
        .collection("users")
        .doc(widget.receiverId)
        .collection("amulet")
        .doc(widget.amuletId)
        .set({
      "amuletId": amuletId,
      "amuletImageList": {
        for(int i = 0;i < amuletImageList.length; i++) "image" + (i + 1).toString() : amuletImageList[i],
      },
      "categories": categories,
      "certificateId": certificateIdResult,
      "certificateImage": certificateImage,
      "confirmDate": confirmDate,
      "confirmBy": confirmBy,
      "image": image,
      "information": information,
      "name": name,
      "texture": texture
    });

    //-- Remove Amulet of Sender
    await _firestoreInstance
        .collection("users")
        .doc(checkUser)
        .collection("amulet")
        .doc(widget.amuletId)
        .delete()
        .then((value) => print("Delete Successful!!"));

    //--  Navigate
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyMainPage()));
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
                      Text("ข้อมูลการส่งมอบ", style: MyConfig.normalBoldText4)),
              SizedBox(height: columnSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('วันที่', style: MyConfig.smallBoldText1),
                  Text(MyConfig.dateText(DateTime.now()),
                      style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ผู้ส่ง', style: MyConfig.smallBoldText1),
                  Text(senderName, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ผู้รับ', style: MyConfig.smallBoldText1),
                  Text(receiverName, style: MyConfig.smallText1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('รหัสใบรับรอง', style: MyConfig.smallBoldText1),
                  Text(certificateId, style: MyConfig.smallText1),
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

    //-------------------------------------------------------------------------------------------------------- Page

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
