import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/mainpage.dart';
import 'package:hongpra/registerpage.dart';
import 'package:hongpra/resetpasswordpage.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  //-- Firebase
  final _auth = FirebaseAuth.instance;

  //-- Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyMainPage()));
      }
    } catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          print("Wrong Password! Try again.Wrong email/password combination.");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
          break;
        case "invalid-email":
          print("Email is not correct!, Try again");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", 'ไม่พบบัญชีผู้ใช้งาน');
          break;
        case "user-not-found":
          print("User not found! Register first!");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", 'ไม่พบบัญชีผู้ใช้งาน');
          break;
        case "user-disabled":
          print("User has been disabled!, Try again");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", 'บัญชีนี้ถูกระงับ');
          break;
        case "too-many-requests":
          print("Too many requests!, Please wait for a while");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", "พยายามเข้าสู่ระบบมากเกินไป โปรดรอสักครู่ ก่อนทำการเข้าสู่ระบบอีกครั้ง");
          break;
        case "operation-not-allowed":
          print(
              "Operation not allowed!, Please enable it in the firebase console");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", "ไม่สามารถใช่งานได้ในขณะนี้");
          break;
        default:
          print("Unknown error");
          buildAlertDialog("เข้าสู่ระบบล้มเหลว", "");
          break;
      }
    }
  }

  void resetpassword(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyResetPasswordPage()));
  }

  void register(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyRegisterPage()));
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

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double maxTextFieldEdge = 12.0;
    double loginButtonWidth = double.infinity;
    double loginButtonHeight = 40.0;
    double registerButtonWidth = 100.0;
    double registerButtonHeight = 15.0;
    double footerHeight = 30.0;
    double boxEdgeWidth = 15.0;
    double boxEdgeHeight = 20.0;
    double boxCurve = 18.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? minEdge : min(screenWidth - minWidth, maxEdge);
    double textFieldEdge = (screenWidth < minWidth) ? screenWidth / minWidth * maxTextFieldEdge : maxTextFieldEdge;

    //-------------------------------------------------------------------------------------------------------- Widgets

    Widget headerText = Center(child: Text('สุดยอดพระเครื่อง', style: MyConfig.logoText));
    Widget titleText = Center(child: Text('ยินดีต้อนรับ', style: MyConfig.largeBoldTextBlack));
    Widget subtitleText = Center(child: Text('เข้าสู่ระบบเพื่อใช้งาน', style: MyConfig.smallTextGrey));
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

    Widget passwordLabel = Text('รหัสผ่าน', style: MyConfig.normalTextBlack);

    Widget passwordTextField = TextField(
      controller: passwordController,
      obscureText: true,
      style: MyConfig.normalTextBlack,
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
          onPressed: () => signIn(),
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
          onPressed: () => register(),
          child: Text('สมัครสมาชิก', style: MyConfig.linkText),
        ),
      ),
    );

    Widget resetPasswordButton = Center(
      child: FlatButton(
        onPressed: () => resetpassword(),
        child: Text('ลืมรหัสผ่าน', style: MyConfig.linkText),
      ),
    );

    Widget footerBar = Container(
      height: footerHeight,
      color: MyConfig.blackColor,
      child: Center(
        child: Text('@ultimateamulet.com 2020, All right Reserved.', style: MyConfig.normalTextWhite),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page

    return Scaffold(
      backgroundColor: MyConfig.themeColor1,
      resizeToAvoidBottomInset: false,
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
              SizedBox(height: desireHeight * 0.05),
              Container(
                padding: EdgeInsets.symmetric(horizontal: boxEdgeWidth, vertical: boxEdgeHeight),
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
                    resetPasswordButton,
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
