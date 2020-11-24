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

class MyCheckCertificatePage extends StatefulWidget {
  const MyCheckCertificatePage();

  @override
  _MyCheckCertificatePage createState() => _MyCheckCertificatePage();
}

class _MyCheckCertificatePage extends State<MyCheckCertificatePage> {
  //-- Controller
  TextEditingController idController = TextEditingController();

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  bool _isLoading = false;
  Certificate certificate;
  Person certificateOwner;

  //-------------------------------------------------------------------------------------------------------- Functions

  void confirmCertificateId() async {
    if (idController.text.isEmpty) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'โปรดระบุรหัสใบรับรอง');
    } else if (idController.text.length != 9) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบใบรับรอง');
    } else{
      print('### START QUERY ###');
      // Get Certificate Info
      setState(() => _isLoading = true);
      QuerySnapshot result = await _firestoreInstance.collection("certificates").where("id", isEqualTo: idController.text).limit(1).get();
      if (result != null && result.size != 0) {
        result.docs.forEach((res) async {
          print(res.data()['id']);
          print(res.data()['userId']);
          certificate = new Certificate.fromDocumentSnapshot(res);
          DocumentSnapshot result2 = await _firestoreInstance.collection("users").doc(res.data()['userId']).get();
          certificateOwner = new Person.fromDocumentSnapshot(result2);
          setState(() => _isLoading = false);
          buildSuccessAlertDialog();
          return;
        });
      } else {
        setState(() => _isLoading = false);
        buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบใบรับรอง');
      }
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
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return result;
      },
    );
  }

  void buildSuccessAlertDialog() {
    Widget okButton = FlatButton(
      child: Text("ยืนยัน", style: MyConfig.linkText),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    //Widget buildHeaderText(String text) => Center(child: Text(text, style: MyConfig.normalBoldTextTheme1));
    Widget buildTitleText(String text) => Expanded(child: Text(text, style: MyConfig.smallBoldTextBlack));
    Widget buildDetailText(String text) => Expanded(child: Text(text, style: MyConfig.smallTextBlack));
    Widget buildRowTitle(String title) => Row(children: [buildTitleText(title)]);
    Widget buildRowDetail(String detail) => Row(children: [buildDetailText(detail)]);
    Widget rowSpaceOutter = SizedBox(height: 10);
    Widget rowSpaceInner = SizedBox(height: 2);

    Widget result = AlertDialog(
      title: Center(child: Text('ตรวจพบใบรับรอง', style: MyConfig.normalBoldTextTheme1)),
      content: Container(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRowTitle('รหัสใบรับรอง'),
            rowSpaceInner,
            buildRowDetail(certificate.id),
            rowSpaceOutter,
            buildRowTitle('ชื่อพระ'),
            rowSpaceInner,
            buildRowDetail(certificate.name),
            rowSpaceOutter,
            buildRowTitle('ผู้ครอบครอง'),
            rowSpaceInner,
            buildRowDetail(certificateOwner.getFullName()),
            rowSpaceOutter,
            buildRowTitle('วันที่รับรอบ'),
            rowSpaceInner,
            buildRowDetail(MyConfig.dateText(certificate.confirmDate)),
          ],
        ),
      ),
      actions: [okButton],
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
    Center(child: Text('ตรวจสอบใบรับรองพระ', style: MyConfig.largeBoldTextBlack));

    Widget idButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => confirmCertificateId(),
          color: MyConfig.themeColor1,
          child: Text('ยืนยัน', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget idTextField = TextField(
      controller: idController,
      maxLength: 9,
      textAlign: TextAlign.center,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อน ID ของใบรับรอง",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText,
                SizedBox(height: desireHeight * 0.01),
                idTextField,
                SizedBox(height: desireHeight * 0.01),
                idButton,
                SizedBox(height: desireHeight * 0.01),
              ],
            ),
          ),
        ),
      ),
    );

    Widget loadingEffect = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: desireHeight * 0.02),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)),
            SizedBox(height: desireHeight * 0.02),
            Text('โปรดรอสักครู่ กำลังตรวจสอบใบรับรอง', style: MyConfig.normalBoldTextTheme1),
          ],
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
            (_isLoading) ? loadingEffect : detailBox,
          ],
        ),
      ),
    );
  }
}
