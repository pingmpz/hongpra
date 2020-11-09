import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hongpra/firstpage.dart';
import 'package:hongpra/fourthpage.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hongpra/secondpage.dart';
import 'package:hongpra/thirdpage.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int selectedPage = 0;
  List<Widget> pageList = new List<Widget>();

  //-- Firebase
  User loginUser;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        loginUser = FirebaseAuth.instance.currentUser;
        print("##### Login User ID : " + loginUser.uid);
        pageList.add(MyFirstPage(loginUser));
        pageList.add(MySecondPage(loginUser));
        pageList.add(MyThirdPage(loginUser));
        pageList.add(MyFourthPage(loginUser));
      } else {
        Future(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyLoginPage()), ModalRoute.withName('/'));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onPageChanged(int index) => setState(() => selectedPage = index );

  @override
  Widget build(BuildContext context) {
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
    );


    Widget myBottomNavBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: MyConfig.themeColor1,
      selectedItemColor: MyConfig.whiteColor,
      unselectedItemColor: MyConfig.whiteColor.withOpacity(0.3),
      selectedLabelStyle: MyConfig.normalTextBlack,
      unselectedLabelStyle: MyConfig.normalTextBlack,
      currentIndex: selectedPage,
      onTap: onPageChanged,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: 'QR Code',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'ประวัติกิจกรรม',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'ตั้งค่า',
        ),
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: myAppBar,
        backgroundColor: MyConfig.themeColor1,
        body: IndexedStack(
          children: pageList,
          index: selectedPage,
        ),
        bottomNavigationBar: myBottomNavBar,
      ),
    );
  }
}
