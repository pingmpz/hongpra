//-- Flutter Materials
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/Certificate.dart';
import 'package:hongpra/Model/Person.dart';

class MyResetPasswordPage2 extends StatefulWidget {
  const MyResetPasswordPage2();

  @override
  _MyResetPasswordPage2 createState() => _MyResetPasswordPage2();
}

class _MyResetPasswordPage2 extends State<MyResetPasswordPage2> {
  //-- Controller
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController1 = TextEditingController();
  TextEditingController newPasswordController2 = TextEditingController();

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  bool _isLoading = false;
  Certificate certificate;
  Person certificateOwner;

  //-------------------------------------------------------------------------------------------------------- Functions

  void resetPasswordCheck() {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword1 = newPasswordController1.text.trim();
    String newPassword2 = newPasswordController2.text.trim();
    RegExp regExp = new RegExp(r"^(?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9]{6,}$");
    if(oldPassword == "" || newPassword1 == "" || newPassword2 == ""){
      buildAlertDialog("เปลี่ยนรหัสผ่านล้มเหลว", "โปรดกรอกข้อมูลให้ครบถ้วน");
    } else if(false){
      //check old password correct -----------***************************************************************
    } else if(newPassword1.length < 6){
      buildAlertDialog("เปลี่ยนรหัสผ่านล้มเหลว", "รหัสผ่านต้องมีความยาวไม่น้อยกว่า 6 ตัวอักษร");
    } else if(!regExp.hasMatch(newPassword1)) {
      buildAlertDialog("เปลี่ยนรหัสผ่านล้มเหลว", "รหัสผ่านต้องเป็นตัวอักษรภาษาอังกฤษและต้องมีตัวเลขรวมอยู่ด้วยอย่างน้อย 1 ตัว");
    } else if(newPassword1 != newPassword2) {
      buildAlertDialog("เปลี่ยนรหัสผ่านล้มเหลว", "ยืนยันรหัสผ่านไม่ถูกต้อง");
    } else {
      buildConfirmDialog("ยืนยันการเปลี่ยนรหัสผ่าน", "กรุณายืนยันการเปลี่ยนรหัสผ่าน");
    }
  }

  void resetPassword() {
    // reset password  -----------***************************************************************
    buildAlertDialog("เปลี่ยนรหัสผ่านสำเร็จ", "");
    // ? logout
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

  void buildConfirmDialog(String title, String content) {
    Widget okButton = FlatButton(
      child: Text("ยืนยัน", style: MyConfig.linkText),
      onPressed: () {
        Navigator.pop(context);
        resetPassword();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("ยกเลิก", style: MyConfig.linkText),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget result = AlertDialog(
      title: Center(child: Text(title, style: MyConfig.normalBoldTextTheme1)),
      content: Text(content, style: MyConfig.normalTextBlack),
      actions: [
        okButton,
        cancelButton,
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
    Center(child: Text('เปลี่ยนรหัสผ่าน', style: MyConfig.largeBoldTextBlack));

    Widget oldPasswordLabel =
    Center(child: Text('รหัสผ่านปัจจุบัน', style: MyConfig.normalBoldTextBlack));

    Widget newPasswordLabel1 =
    Center(child: Text('รหัสผ่านใหม่', style: MyConfig.normalBoldTextBlack));

    Widget newPasswordLabel2 =
    Center(child: Text('ยืนยันรหัสผ่าน', style: MyConfig.normalBoldTextBlack));

    Widget notiLabel =
    Center(child: Text('รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัว ต้องเป็นตัวอักษรภาษาอังกฤษและต้องมีตัวเลขรวมอยู่ด้วยอย่างน้อย 1 ตัว', style: MyConfig.smallTextBlack));

    Widget oldPasswordTextField = TextField(
      controller: oldPasswordController,
      textAlign: TextAlign.center,
      obscureText: true,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        //hintText: "รหัสผ่านปัจจุบัน",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget newPasswordTextField1 = TextField(
      controller: newPasswordController1,
      textAlign: TextAlign.center,
      obscureText: true,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        //hintText: "รหัสผ่านใหม่",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget newPasswordTextField2 = TextField(
      controller: newPasswordController2,
      textAlign: TextAlign.center,
      obscureText: true,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        //hintText: "ยืนยันรหัสผ่าน",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget confirmButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => resetPasswordCheck(),
          color: MyConfig.themeColor1,
          child: Text('ยืนยัน', style: MyConfig.buttonText),
        ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                titleText,
                SizedBox(height: desireHeight * 0.03),
                oldPasswordLabel,
                SizedBox(height: desireHeight * 0.01),
                oldPasswordTextField,
                SizedBox(height: desireHeight * 0.01),
                newPasswordLabel1,
                SizedBox(height: desireHeight * 0.01),
                newPasswordTextField1,
                SizedBox(height: desireHeight * 0.01),
                newPasswordLabel2,
                SizedBox(height: desireHeight * 0.01),
                newPasswordTextField2,
                SizedBox(height: desireHeight * 0.01),
                notiLabel,
                SizedBox(height: desireHeight * 0.01),
                confirmButton,
                SizedBox(height: desireHeight * 0.01),
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
