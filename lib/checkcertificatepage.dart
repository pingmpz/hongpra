import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';


class MyCheckCertificatePage extends StatefulWidget {
  const MyCheckCertificatePage();

  @override
  _MyCheckCertificatePage createState() => _MyCheckCertificatePage();
}

class _MyCheckCertificatePage extends State<MyCheckCertificatePage> {
  //-- Controller
  TextEditingController idController = TextEditingController();

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  bool _isLoading = false;

  //-------------------------------------------------------------------------------------------------------- Functions

  void confirmCertificateId() async {
    if (idController.text.isEmpty) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'โปรดระบุ ID ของใบรับรอง');
    } else if (idController.text.length != 9) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบใบรับรอง');
    } else{

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
          (_isLoading) ? SizedBox() : Align(
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
    Center(child: Text('ตรวจสอบใบรับรองพระ', style: MyConfig.largeBoldTextBlack));

    Widget idButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => confirmCertificateId(),
          color: MyConfig.themeColor1,
          child: Text('ยืนยัน', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget idTextField = TextField(
      controller: idController,
      maxLength: 9,
      textAlign: TextAlign.center,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อน ID ของใบรับรอง",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

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
              ],
            ),
          ),
        ),
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
            Text('โปรดรอสักครู่ กำลังตรวจสอบใบรับรอง', style: MyConfig.normalBoldTextTheme1),
          ],
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
            (_isLoading) ? loadingEffect : detailBox,
          ],
        ),
      ),
    );
  }
}
