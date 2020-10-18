import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';

class MyRegisterPage extends StatefulWidget {
  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double maxTextFieldEdge = 12.0;
    double registerButtonWidth = 200;
    double registerButtonHeight = 40;
    double footerHeight = 30;
    double boxEdgeWidth = 15.0;
    double boxEdgeHeight = 5.0;
    double boxCurve = 18.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? minEdge : min(screenWidth - minWidth, maxEdge);
    double textFieldEdge = (screenWidth < minWidth) ? screenWidth/minWidth * maxTextFieldEdge : maxTextFieldEdge;

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: MyConfig.themeColor2,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('สมัครสมาชิก', style: MyConfig.appBarTitleText),
    );

    Widget titleLabel = Center(
      child: Text('สมัครสมาชิก', style: MyConfig.mediumTitleText),
    );

    Widget emailLabel = Text('อีเมล', style: MyConfig.normalText1);

    Widget emailField = TextField(
      obscureText: false,
      style: MyConfig.normalText1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนอีเมลของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget passwordLabel = Text('รหัสผ่าน', style: MyConfig.normalText1);

    Widget passwordField = TextField(
      obscureText: true,
      style: MyConfig.normalText1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนรหัสผ่านของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget rePasswordLabel = Text('ยืนยันรหัสผ่าน', style: MyConfig.normalText1);

    Widget rePasswordField = TextField(
      obscureText: true,
      style: MyConfig.normalText1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนรหัสผ่านของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget surnameLabel = Text('ชื่อ', style: MyConfig.normalText1);

    Widget surnameField = TextField(
      obscureText: false,
      style: MyConfig.normalText1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนชื่อของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget lastnameLabel = Text('นามสกุล', style: MyConfig.normalText1);

    Widget lastnameField = TextField(
      obscureText: false,
      style: MyConfig.normalText1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนนามสกุลของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget registerButton = Center(
      child: ButtonTheme(
        minWidth: registerButtonWidth,
        height: registerButtonHeight,
        child: RaisedButton(
          onPressed: () => {},
          color: MyConfig.blackColor,
          child: Text('สมัครสมาชิก', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget footerBar = Container(
      height: footerHeight,
      color: MyConfig.blackColor,
      child: Center(
        child: Text('@HongPra.com 2020, All right Reserved.', style: MyConfig.normalText2),
      ),
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      resizeToAvoidBottomInset: false,
      //extendBodyBehindAppBar: true,
      appBar: myAppBar,
      body: Center(
        child: Container(
          width: desireWidth,
          height: desireHeight,
          margin: EdgeInsets.all(screenEdge),
          padding: EdgeInsets.symmetric(horizontal: boxEdgeWidth, vertical: boxEdgeHeight),
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
              emailField,
              SizedBox(height: desireHeight * 0.01),
              passwordLabel,
              SizedBox(height: desireHeight * 0.005),
              passwordField,
              SizedBox(height: desireHeight * 0.01),
              rePasswordLabel,
              SizedBox(height: desireHeight * 0.005),
              rePasswordField,
              SizedBox(height: desireHeight * 0.01),
              surnameLabel,
              SizedBox(height: desireHeight * 0.005),
              surnameField,
              SizedBox(height: desireHeight * 0.01),
              lastnameLabel,
              SizedBox(height: desireHeight * 0.005),
              lastnameField,
              SizedBox(height: desireHeight * 0.03),
              registerButton,
            ],
          ),
        ),
      ),
      bottomNavigationBar: footerBar,
    );
  }
}
