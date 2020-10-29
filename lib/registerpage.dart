import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/loginpage.dart';
import 'package:hongpra/myconfig.dart';

class MyRegisterPage extends StatefulWidget {
  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  //------------------ Custom Functions ------------------
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid password';
      else
        return null;
    }
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  void signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String firstname = firstNameController.text.trim();
    String lastname = lastNameController.text.trim();

    final String uniqueID = Uuid().generateUniqueId();

    validateEmail(email);
    validatePassword(password);

    if (password == confirmPassword && password.length >= 6) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print("Registation Success");

        String userId = user.user.uid;
        // Print user ID
        print(userId);
        // Print unique ID
        print("Unique ID: " + uniqueID);

        //Print dateTime
        DateTime dateTime = new DateTime.now();
        String date = MyConfig.splitDateTimeText(dateTime);
        print("DateTime " + date);

        // 'userid': userId,
        Firestore.instance.collection('users').doc(userId).set({
          'userId': userId,
          'firstname': firstname,
          'lastname': lastname,
          'uniqueId': uniqueID
        });
        // NAVIGATE
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyLoginPage()));
      }).catchError((error) {
        print(error.message);
        buildAlertDialog("สมัครสมาชิกล้มเหลว", "");
      });
    } else {
      print("Password and Confirm-password is not match.");
      buildAlertDialog(
          "สมัครสมาชิกล้มเหลว", "รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน");
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
      title: Center(child: Text(title, style: MyConfig.normalBoldText1)),
      content: Text(content, style: MyConfig.normalText1),
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
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double boxEdgeWidth = 15.0;
    double boxEdgeHeight = 5.0;
    double boxCurve = 18.0;
    double maxTextFieldEdge = 12.0;
    double registerButtonWidth = 200;
    double registerButtonHeight = 40;
    double footerHeight = 30;

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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Text('สมัครสมาชิก', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );

    Widget emailLabel = Text('อีเมล', style: MyConfig.normalText1);

    Widget emailField = TextField(
      controller: emailController,
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
      controller: passwordController,
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

    Widget rePasswordLabel =
        Text('ยืนยันรหัสผ่าน', style: MyConfig.normalText1);

    Widget rePasswordField = TextField(
      controller: confirmPasswordController,
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

    Widget firstnameLabel = Text('ชื่อ', style: MyConfig.normalText1);

    Widget firstnameField = TextField(
      controller: firstNameController,
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
      controller: lastNameController,
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
          onPressed: () => {signUp()},
          color: MyConfig.blackColor,
          child: Text('สมัครสมาชิก', style: MyConfig.buttonText),
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
              firstnameLabel,
              SizedBox(height: desireHeight * 0.005),
              firstnameField,
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

class Uuid {
  final Random _random = Random();

  /// Generate a random uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateUniqueId() {
    //final int special = 8 + _random.nextInt(4);

    // Format xxxxxxxx
    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

// - 99 - (HH) = 80 <- 2
// - Swap H2 H1 <- 3
// - HMSymdxHMSymd <- 1

class swappingString{

  String generateString(String str){

    var char = "";

    if(str == null || str.isEmpty) return "";

    for(int i=0; i < str.length; i++) {
      char = str[i];
    }

    for (int i = 0; i < char.length - 1; i += 2) {

      // Swapping the characters
      var temp = char[i];
      char[i] = char[i + 1];
      char[i + 1] = temp;
    }

    // Converting the result into a
    // string and return
    return new String(char);

  }

}