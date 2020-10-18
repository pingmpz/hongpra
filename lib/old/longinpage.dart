import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/mainpage.dart';
import 'package:hongpra/registerpage.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double maxTextFieldEdge = 12.0;
    double logoRatio = 0.25; // 25%
    double loginButtonWidth = 200.0;
    double loginButtonHeight = 40.0;
    double registerButtonWidth = 100.0;
    double registerButtonHeight = 15.0;
    double footerHeight = 30.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? minEdge : min(screenWidth - minWidth, maxEdge);
    double textFieldEdge = (screenWidth < minWidth) ? screenWidth/minWidth * maxTextFieldEdge : maxTextFieldEdge;

    //------------------ Custom Widgets ------------------
    Widget backgroundImage = Image(
      image: AssetImage("assets/images/background.jpg"),
      width: screenWidth,
      height: screenHeight,
      fit: BoxFit.cover,
    );

    Widget titleText = Center(child: Text('ห้องพระ', style: MyConfig.largeHeaderText));

    Widget logoImage = Center(
      child: Image(
        image: AssetImage('assets/images/logo.png'),
        height: desireHeight * logoRatio,
      ),
    );

    Widget emailLabel = Text('อีเมล', style: MyConfig.normalText1);

    Widget emailTextField = TextField(
      obscureText: false,
      style: MyConfig.normalText2,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อนอีเมลของคุณ",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget passwordLabel = Text('รหัสผ่าน', style: MyConfig.normalText1);

    Widget passwordTextField = TextField(
      obscureText: true,
      style: MyConfig.normalText2,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อนรหัสผ่านของคุณ",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget loginButton = Center(
      child: ButtonTheme(
        minWidth: loginButtonWidth,
        height: loginButtonHeight,
        child: RaisedButton(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyMainPage()))
          },
          color: MyConfig.themeColor2,
          child: Text('เข้าสู่ระบบ', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget registerButton = Center(
      child: ButtonTheme(
        minWidth: registerButtonWidth,
        height: registerButtonHeight,
        child: FlatButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyRegisterPage()))
          },
          child: Text('สมัครสมาชิก', style: MyConfig.linkText),
        ),
      ),
    );

    Widget footerBar = Container(
      height: footerHeight,
      color: MyConfig.themeColor2,
      child: Center(
        child: Text('@HongPra.com 2020, All right Reserved.'),
      ),
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundImage,
          Center(
            child: Container(
              width: desireWidth,
              height: screenHeight,
              padding:
                  EdgeInsets.symmetric(horizontal: screenEdge, vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleText,
                  SizedBox(height: desireHeight * 0.01),
                  logoImage,
                  SizedBox(height: desireHeight * 0.01),
                  emailLabel,
                  SizedBox(height: desireHeight * 0.005),
                  emailTextField,
                  SizedBox(height: desireHeight * 0.01),
                  passwordLabel,
                  SizedBox(height: desireHeight * 0.005),
                  passwordTextField,
                  SizedBox(height: desireHeight * 0.03),
                  loginButton,
                  SizedBox(height: desireHeight * 0.01),
                  registerButton,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: footerBar,
    );
  }
}
