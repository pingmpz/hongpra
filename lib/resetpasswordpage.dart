import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hongpra/loginpage.dart';
import 'package:hongpra/myconfig.dart';

class MyResetPasswordPage extends StatefulWidget {
  MyResetPasswordPage({Key key}) : super(key: key);

  @override
  _MyResetPasswordPageState createState() => _MyResetPasswordPageState();
}


class _MyResetPasswordPageState extends State<MyResetPasswordPage> {
  //-- Firebase
  final _auth = FirebaseAuth.instance;

  //-- Controller
  TextEditingController emailController = TextEditingController();

  resetPassword() {
    String email = emailController.text.trim();
    _auth.sendPasswordResetEmail(email: email);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
  }

  void back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double boxEdgeWidth = 15.0;
    double boxEdgeHeight = 5.0;
    double boxCurve = 18.0;
    double maxTextFieldEdge = 12.0;
    double resetPasswordButtonWidth = double.infinity;
    double resetPasswordButtonHeight = 40.0;
    double footerHeight = 30.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);
    double textFieldEdge = (screenWidth < minWidth) ? screenWidth / minWidth * maxTextFieldEdge : maxTextFieldEdge;

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
          Text('ลืมรหัสผ่าน', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );


    Widget emailLabel = Text('อีเมล', style: MyConfig.normalTextBlack);

    Widget emailTextField = TextField(
      controller: emailController,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อนอีเมลของคุณ",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget resetPasswordButton = Center(
      child: ButtonTheme(
        minWidth: resetPasswordButtonWidth,
        height: resetPasswordButtonHeight,
        child: RaisedButton(
          onPressed: () => resetPassword(),
          color: MyConfig.redColor,
          child: Text('ยืนยันอีเมล์', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget footerBar = Container(
      height: footerHeight,
      color: MyConfig.blackColor,
      child: Center(child: Text('@HongPra.com 2020, All right Reserved.', style: MyConfig.normalTextWhite),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page
    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      resizeToAvoidBottomInset: false,
      appBar: myAppBar,
      body: Center(
        child: Container(
          width: desireWidth,
          height: desireHeight,
          margin: EdgeInsets.all(screenEdge),
          padding: EdgeInsets.symmetric(
              horizontal: boxEdgeWidth, vertical: boxEdgeHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(boxCurve)),
            color: MyConfig.whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              emailLabel,
              SizedBox(height: desireHeight * 0.005),
              emailTextField,
              SizedBox(height: desireHeight * 0.01),
              SizedBox(height: desireHeight * 0.03),
              resetPasswordButton,
            ],
          ),
        ),
      ),
      bottomNavigationBar: footerBar,
    );

  }


}