//-- Flutter Materials
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//-- Pages and Models
import 'package:hongpra/loginpage.dart';
import 'package:hongpra/myconfig.dart';

class MyRegisterPage extends StatefulWidget {
  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  //-- Firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  bool validatePassword(String value) {
    Pattern pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  String createUniqueId() {
    String result = "";
    DateTime dateTime = new DateTime.now(); //-- new Date(firebase.firestore.Timestamp.now().toDate());

    //-- Layer 1
    String day = (dateTime.day < 10)
        ? "0" + dateTime.day.toString()
        : dateTime.day.toString();
    String month = (dateTime.month < 10)
        ? "0" + dateTime.month.toString()
        : dateTime.month.toString();
    int yearText = int.parse((dateTime.toString()).substring(2, 4));
    String year =
        (yearText < 10) ? "0" + yearText.toString() : yearText.toString();
    String hour = (dateTime.hour < 10)
        ? "0" + dateTime.hour.toString()
        : dateTime.hour.toString();
    String min = (dateTime.minute < 10)
        ? "0" + dateTime.minute.toString()
        : dateTime.minute.toString();
    String sec = (dateTime.second < 10)
        ? "0" + dateTime.second.toString()
        : dateTime.second.toString();
    result = day + month + year + hour + min + sec;
    //-- Layer 2 : SWAP
    List<String> resultList = result.split("");
    for (int i = 0; i < resultList.length - 1; i += 2) {
      String temp = resultList[i];
      resultList[i] = resultList[i + 1];
      resultList[i + 1] = temp;
    }
    result = resultList.reduce((value, element) => value += element);
    //-- Layer 3 : SPLIT & MERGE
    String head = "";
    String tail = "";
    for (int i = 0; i < resultList.length - 1; i += 2) {
      head = head + result.substring(i, i + 1);
      tail = tail + result.substring(i + 1, i + 2);
    }
    result = head + tail;
    return result;
  }

  void signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();

    if (email == "") {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "โปรดระบุอีเมล");
    } else if (password == "") {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "โปรดระบุรหัสผ่าน");
    } else if (confirmPassword == "") {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "โปรดระบุยืนยันรหัสผ่าน");
    } else if (firstName == "") {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "โปรดระบุชื่อ");
    } else if (lastName == "") {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "โปรดระบุนามสกุล");
    } else if (!validateEmail(email)) {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "รูปแบบอีเมลไม่ถูกต้อง");
    } else if (!validatePassword(password)) {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัว ต้องเป็นตัวอักษรภาษาอังกฤษและต้องมีตัวเลขรวมอยู่ด้วยอย่างน้อย 1 ตัว");
    } else if (password != confirmPassword) {
      buildAlertDialog("สมัครสมาชิกล้มเหลว", "รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน");
    } else {
      _auth.createUserWithEmailAndPassword(email: email, password: password).then((user) {
        print("Register Success");
        String userId = user.user.uid;
        String uniqueId = createUniqueId();

        _firestoreInstance.collection('users').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
          'uniqueId': uniqueId,
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
      }).catchError((error) {
        print(error.message);
        buildAlertDialog("สมัครสมาชิกล้มเหลว", "มีบัญชีนี้ในระบบแล้ว");
      });
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
          Text('สมัครสมาชิก', style: MyConfig.appBarTitleText)
        ],
      ),
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
    );

    Widget emailLabel = Text('อีเมล', style: MyConfig.normalTextBlack);

    Widget emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนอีเมลของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget passwordLabel = Text('รหัสผ่าน', style: MyConfig.normalTextBlack);

    Widget passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนรหัสผ่านของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget rePasswordLabel =
        Text('ยืนยันรหัสผ่าน', style: MyConfig.normalTextBlack);

    Widget rePasswordField = TextField(
      controller: confirmPasswordController,
      obscureText: true,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนรหัสผ่านของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget firstNameLabel = Text('ชื่อ', style: MyConfig.normalTextBlack);

    Widget firstNameField = TextField(
      controller: firstNameController,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(textFieldEdge),
          hintText: "ป้อนชื่อของคุณ",
          filled: true,
          fillColor: MyConfig.whiteColor,
          border: OutlineInputBorder()),
    );

    Widget lastNameLabel = Text('นามสกุล', style: MyConfig.normalTextBlack);

    Widget lastNameField = TextField(
      controller: lastNameController,
      obscureText: false,
      style: MyConfig.normalTextBlack,
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
          onPressed: () => signUp(),
          color: MyConfig.blackColor,
          child: Text('สมัครสมาชิก', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget footerBar = Container(
      height: footerHeight,
      color: MyConfig.blackColor,
      child: Center(
        child: Text('@ultimateamulet.com 2020, All right Reserved.',
            style: MyConfig.normalTextWhite),
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
              firstNameLabel,
              SizedBox(height: desireHeight * 0.005),
              firstNameField,
              SizedBox(height: desireHeight * 0.01),
              lastNameLabel,
              SizedBox(height: desireHeight * 0.005),
              lastNameField,
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
