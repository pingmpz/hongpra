import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hongpra/confirmpage.dart';
import 'package:hongpra/myconfig.dart';

import 'Data/Amulet.dart';
import 'Data/Certificate.dart';
import 'Data/Person.dart';

class MyTransferPage extends StatefulWidget {
  final Amulet amulet;
  final Certificate certificate;
  const MyTransferPage(this.amulet, this.certificate);

  @override
  _MyTransferPageState createState() => _MyTransferPageState();
}

class _MyTransferPageState extends State<MyTransferPage> {
  //-- Controller
  TextEditingController idController = TextEditingController();

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  String scanner = "";

  //-------------------------------------------------------------------------------------------------------- Functions

  void scan() async {
    scanner = await FlutterBarcodeScanner.scanBarcode(
        "#" + MyConfig.colorTheme1, "Cancel", true, ScanMode.QR);
    approve(2, scanner);
  }

  void prepare() {
    if (idController.text.isEmpty) {
      buildAlertDialog('เกิดข้อผิดพลาด', 'โปรดระบุ UID ของผู้รับ');
    } else if (idController.text.length < 12) {
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
    } else {
      approve(1, idController.text);
    }
  }

  void approve(int type, String id) async {
    Person senderUser;
    Person receiverUser;
    QuerySnapshot result;

    // Get Receiver Info
    if (type == 1) {
      //-- Check By uniqueId
      result = await _firestoreInstance.collection("users").where("uniqueId", isEqualTo: id).get();
    } else if (type == 2) {
      //-- Check By userId
      result = await _firestoreInstance.collection("users").where("userId", isEqualTo: id).get();
    }
    if (result != null) {
      result.docs.forEach((res) {
        receiverUser = new Person(
          (res.data()['userId'] != null) ? res.data()['userId'] : "",
          (res.data()['firstName'] != null) ? res.data()['firstName'] : "",
          (res.data()['lastName'] != null) ? res.data()['lastName'] : "",
          (res.data()['uniqueId'] != null) ? res.data()['uniqueId'] : "",
        );
      });
      if (receiverUser.id == loginUser.uid) {
        buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่สามารถส่งมอบให้ตัวเองได้');
        return;
      }

      // Get Sender Info
      result = null;
      result = await _firestoreInstance.collection("users").where("userId", isEqualTo: loginUser.uid).get();
      if (result != null) {
        result.docs.forEach((res) {
          senderUser = new Person(
            (res.data()['userId'] != null) ? res.data()['userId'] : "",
            (res.data()['firstName'] != null) ? res.data()['firstName'] : "",
            (res.data()['lastName'] != null) ? res.data()['lastName'] : "",
            (res.data()['uniqueId'] != null) ? res.data()['uniqueId'] : "",
          );
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => MyConfirmPage(senderUser, receiverUser, widget.amulet, widget.certificate)));
      } else {
        buildAlertDialog('เกิดข้อผิดพลาด', 'ระบบขัดข้อง');
      }
    } else {
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
    }
  }

  void buildAlertDialog(String title, String content) {
    Widget okButton = FlatButton(
      child: Text("ยืนยัน", style: MyConfig.linkText),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget result = AlertDialog(
      title: Center(child: Text(title, style: MyConfig.normalBoldTextTheme1)),
      content: Text(content, style: MyConfig.normalTextBlack),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return result;
      },
    );
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
    double dividerInnerEdge = 20.0;
    double dividerOutterEdge = 10.0;
    double dividerHeight = 36.0;
    double maxTextFieldEdge = 12.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double buttonWidth = (screenWidth - (screenEdge * 2));
    double buttonHeight = 40.0;
    double textFieldEdge = (screenWidth < minWidth)
        ? screenWidth / minWidth * maxTextFieldEdge
        : maxTextFieldEdge;

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

    Widget titleText =
        Center(child: Text('เลือกผู้รับ', style: MyConfig.largeBoldTextBlack));

    Widget idButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => prepare(),
          color: MyConfig.themeColor1,
          child: Text('ยืนยัน', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget idTextField = TextField(
      controller: idController,
      maxLength: 12,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      textAlign: TextAlign.center,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อน UID ของผู้รับ",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget scanButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => scan(),
          color: MyConfig.themeColor1,
          child: Text('สแกนด้วย QR Code', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget myDivider = Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
                left: dividerOutterEdge, right: dividerInnerEdge),
            child: Divider(
              color: MyConfig.blackColor,
              height: dividerHeight,
            )),
      ),
      Text("หรือ", style: MyConfig.normalTextBlack),
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
                left: dividerInnerEdge, right: dividerOutterEdge),
            child: Divider(
              color: MyConfig.blackColor,
              height: dividerHeight,
            )),
      ),
    ]);

    Widget detailBox = Center(
      child: Container(
        width: desireWidth,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText,
                SizedBox(height: desireHeight * 0.01),
                idTextField,
                SizedBox(height: desireHeight * 0.01),
                idButton,
                SizedBox(height: desireHeight * 0.01),
                myDivider,
                SizedBox(height: desireHeight * 0.01),
                scanButton,
              ],
            ),
          ),
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page

    return Scaffold(
      backgroundColor: MyConfig.themeColor2,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: myAppBar,
      body: Container(
        height: screenHeight,
        margin: EdgeInsets.all(screenEdge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            detailBox,
          ],
        ),
      ),
    );
  }
}
