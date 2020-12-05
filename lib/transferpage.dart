//-- Flutter Materials
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//-- Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/confirmpage.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/Person.dart';
import 'package:hongpra/Model/Certificate.dart';
//-- External Libraries
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyTransferPage extends StatefulWidget {
  final Certificate certificate;
  const MyTransferPage(this.certificate);

  @override
  _MyTransferPageState createState() => _MyTransferPageState();
}

class _MyTransferPageState extends State<MyTransferPage> {
  //-- Controller
  TextEditingController idController = TextEditingController();

  //-- Firebase
  final loginUser = FirebaseAuth.instance.currentUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Item
  String scanner = "";
  bool _isLoading = false;
  Person senderUser;
  Person receiverUser;

  //-------------------------------------------------------------------------------------------------------- Functions

  void scan() async {
    scanner = await FlutterBarcodeScanner.scanBarcode("#" + MyConfig.colorTheme1, "Cancel", true, ScanMode.QR);
    if(scanner == "-1"){
      return;
    } else if(scanner != null && scanner != "" && scanner.isNotEmpty && scanner.length > 4 && scanner.substring(0,2) == "UA" && scanner.substring(scanner.length - 2,scanner.length) == "UA"){
      print('### START QUERY ###');
      // Get Receiver Info
      setState(() => _isLoading = true);
      String scannerResult = scanner.substring(2, scanner.length - 2);
      DocumentSnapshot result = await _firestoreInstance.collection("users").doc(scannerResult).get();
      if (result != null) {
        receiverUser = new Person.fromDocumentSnapshot(result);
        print('# (1/2) Collected Receiver Info');
        approve();
      } else {
        print('### END QUERY (Fail) ###');
        setState(() => _isLoading = false);
        buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
      }
    } else {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
    }
  }

  void confirmId() async {
    if (idController.text.isEmpty) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'โปรดระบุ หมายเลขสมาชิก ของผู้รับ');
    } else if (idController.text.length != 12) {
      setState(() => _isLoading = false);
      buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
    } else {
      print('### START QUERY ###');
      // Get Receiver Info
      setState(() => _isLoading = true);
      QuerySnapshot result = await _firestoreInstance.collection("users").where("uniqueId", isEqualTo: idController.text).limit(1).get();
      if (result != null && result.size != 0) {
        result.docs.forEach((res) {
          receiverUser = new Person.fromDocumentSnapshot(res);
        });
        if (receiverUser.docId == loginUser.uid) {
          print('### END QUERY (Fail) ###');
          setState(() => _isLoading = false);
          buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่สามารถส่งมอบให้ตัวเองได้');
          return;
        }
        print('# (1/2) Collected Receiver Info');
        approve();
      } else {
        print('### END QUERY (Fail) ###');
        setState(() => _isLoading = false);
        buildAlertDialog('เกิดข้อผิดพลาด', 'ไม่พบบัญชีผู้ใช้งาน');
      }
    }
  }

  void approve() async {
      // Get Sender Info
      DocumentSnapshot result = await _firestoreInstance.collection("users").doc(loginUser.uid).get();
      if (result != null) {
        senderUser = new Person.fromDocumentSnapshot(result);
        print('# (2/2) Collected Sender Info');
        print('### END QUERY (Success) ###');
        setState(() => _isLoading = false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyConfirmPage(senderUser, receiverUser, widget.certificate)));
      } else {
        print('### END QUERY (Fail) ###');
        setState(() => _isLoading = false);
        buildAlertDialog('เกิดข้อผิดพลาด', 'ระบบขัดข้อง');
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
    double cardPadding = 8.0;
    double dividerInnerEdge = 20.0;
    double dividerOutterEdge = 10.0;
    double dividerHeight = 36.0;
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
        Center(child: Text('เลือกผู้รับ', style: MyConfig.largeBoldTextBlack));

    Widget idButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => confirmId(),
          color: MyConfig.themeColor1,
          child: Text('ยืนยัน', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget idTextField = TextField(
      controller: idController,
      maxLength: 12,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      textAlign: TextAlign.center,
      obscureText: false,
      style: MyConfig.normalTextBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(textFieldEdge),
        hintText: "ป้อน หมายเลขสมาชิก ของผู้รับ",
        filled: true,
        fillColor: MyConfig.whiteColor,
        border: OutlineInputBorder(),
      ),
    );

    Widget scanButton = Center(
      child: ButtonTheme(
        minWidth: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          onPressed: () => scan(),
          color: MyConfig.themeColor1,
          child: Text('สแกนด้วย QR Code', style: MyConfig.buttonText),
        ),
      ),
    );

    Widget myDivider = Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
                left: dividerOutterEdge, right: dividerInnerEdge),
            child: Divider(
              color: MyConfig.blackColor,
              height: dividerHeight,
            )),
      ),
      Text("หรือ", style: MyConfig.normalTextBlack),
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
                left: dividerInnerEdge, right: dividerOutterEdge),
            child: Divider(
              color: MyConfig.blackColor,
              height: dividerHeight,
            )),
      ),
    ]);

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
                myDivider,
                SizedBox(height: desireHeight * 0.01),
                scanButton,
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
            Text('โปรดรอสักครู่ กำลังตรวจสอบผู้รับ', style: MyConfig.normalBoldTextTheme1),
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
