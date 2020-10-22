import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  //------------------ Custom Methods ------------------
  // Check user log-in
  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      print("Already singed-in with");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyMainPage(user, _auth)));
    }
  }

  // Log-in
  Future<FirebaseUser> signIn() async {
    final FirebaseUser user = await _auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((user) {
      print("signed in ${user.email}");
      checkAuth(context); // add here
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double boxEdgeWidth = 15.0;
    double boxEdgeHeight = 20.0;
    double boxCurve = 18.0;
    double maxTextFieldEdge = 12.0;
    double loginButtonWidth = double.infinity;
    double loginButtonHeight = 40.0;
    double registerButtonWidth = 100.0;
    double registerButtonHeight = 15.0;
    double footerHeight = 30.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);
    double textFieldEdge = (screenWidth < minWidth)
        ? screenWidth / minWidth * maxTextFieldEdge
        : maxTextFieldEdge;

    //------------------ Custom Widgets ------------------

    Widget headerText =
        Center(child: Text('ห้องพระ', style: MyConfig.logoText));
    Widget titleText = Center(
        child: Text('ยินดีต้อนรับสู่ ห้องพระ', style: MyConfig.largeBoldText));
    Widget subtitleText = Center(
        child: Text('เข้าสู่ระบบเพื่อใช้งาน', style: MyConfig.smallText2));
    Widget emailLabel = Text('อีเมล', style: MyConfig.normalText1);

    Widget emailTextField = TextField(
      controller: emailController,
      obscureText: false,
      style: MyConfig.normalText1,
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
      controller: passwordController,
      obscureText: true,
      style: MyConfig.normalText1,
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
          onPressed: () => {signIn()},
          color: MyConfig.blackColor,
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
      color: MyConfig.blackColor,
      child: Center(
        child: Text('@HongPra.com 2020, All right Reserved.',
            style: MyConfig.normalText2),
      ),
    );

    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: desireWidth,
          height: screenHeight,
          padding: EdgeInsets.symmetric(horizontal: screenEdge, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              headerText,
              SizedBox(height: desireHeight * 0.01),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: boxEdgeWidth, vertical: boxEdgeHeight),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(boxCurve)),
                  color: MyConfig.whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText,
                    SizedBox(height: desireHeight * 0.005),
                    subtitleText,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: footerBar,
    );
  }
}
