//-- Flutter Materials
import 'dart:math';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/Person.dart';
//-- External Libraries
import 'package:qr_flutter/qr_flutter.dart';

class MySecondPage extends StatefulWidget {
  final User loginUser;
  MySecondPage(this.loginUser);

  @override
  _MySecondPageState createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  //-- Firebase
  User loginUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Items
  Person currentUser = new Person.fromEmpty();

  void initState() {
    super.initState();
    loginUser = widget.loginUser;
    getUserInfo();
  }

  void getUserInfo() async {
    DocumentSnapshot result = await _firestoreInstance.collection("users").doc(loginUser.uid).get();
    setState(() {
      currentUser = new Person.fromDocumentSnapshot(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    return Container(
      color: MyConfig.themeColor2,
      height: screenHeight,
      child: Container(
        margin: EdgeInsets.all(screenEdge),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('QR Code', style: MyConfig.largeBoldTextTheme1),
              SizedBox(height: screenHeight * 0.005),
              Container(
                  height: desireHeight / 2,
                  child: Center(
                    child: (loginUser != null)
                        ? QrImage(
                      data: ("UA" + loginUser.uid + "UA"),
                      version: QrVersions.auto,
                      size: min(300.0, 300.0 * (screenWidth / minWidth)),
                    ) : Image(image: AssetImage('assets/images/notfound.png')),
                  )),
              SizedBox(height: screenHeight * 0.005),
              Text('หมายเลขสมาชิก', style: MyConfig.largeBoldTextTheme1),
              SizedBox(height: screenHeight * 0.01),
              Center(child: Text(currentUser.uniqueId, style: MyConfig.largeBoldTextBlack.copyWith(letterSpacing: 2))),
            ],
          ),
        ),
      ),
    );
  }
}
