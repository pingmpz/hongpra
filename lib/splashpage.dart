import 'package:flutter/material.dart';
import 'package:hongpra/mainpage.dart';
import 'package:hongpra/myconfig.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashPage extends StatefulWidget {
  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {

  @override
  Widget build(BuildContext context) {

    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: MyMainPage(),
        title: Text('ห้องพระ', style: MyConfig.logoText),
        backgroundColor: MyConfig.themeColor1,
        loaderColor: MyConfig.whiteColor,
    );
  }
}
