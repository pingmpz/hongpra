import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/checkcertificatepage.dart';
import 'package:hongpra/loginpage.dart';
import 'package:hongpra/myconfig.dart';

class MyFourthPage extends StatefulWidget {
  final User loginUser;
  MyFourthPage(this.loginUser);

  @override
  _MyFourthPageState createState() => _MyFourthPageState();
}

class _MyFourthPageState extends State<MyFourthPage> {
  //-- Firebase
  User loginUser;

  @override
  void initState() {
    super.initState();
    loginUser = widget.loginUser;
  }

  void checkCertificate(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyCheckCertificatePage()));
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    // double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double loginButtonWidth = double.infinity;
    double loginButtonHeight = 40.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    //double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    Widget checkCertificateButton = Center(
      child: ButtonTheme(
        minWidth: loginButtonWidth,
        height: loginButtonHeight,
        child: RaisedButton(
          onPressed: () => checkCertificate(),
          color: MyConfig.blackColor,
          child: RichText(
              text: TextSpan(
                style: MyConfig.buttonText,
                children: [
                  WidgetSpan(child: Icon(Icons.search, color: MyConfig.whiteColor, size: 20)),
                  TextSpan(text: ' ตรวจสอบใบรับรอง', style: MyConfig.buttonText),
                ],
              ),
          ),
        ),
      ),
    );

    Widget logoutButton = Center(
      child: ButtonTheme(
        minWidth: loginButtonWidth,
        height: loginButtonHeight,
        child: RaisedButton(
          onPressed: () => signOut(),
          color: MyConfig.redColor,
          child: Text('ออกจากระบบ', style: MyConfig.buttonText),
        ),
      ),
    );

    return Container(
      color: MyConfig.themeColor2,
      height: screenHeight,
      child: Container(
        margin: EdgeInsets.all(screenEdge),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkCertificateButton,
              logoutButton,
            ],
          ),
        ),
      ),
    );
  }
}
