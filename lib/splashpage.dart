import 'package:flutter/material.dart';
import 'package:hongpra/mainpage.dart';
import 'package:hongpra/myconfig.dart';

class MySplashPage extends StatefulWidget {

  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3)).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyMainPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: MyConfig.themeColor1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('สุดยอดพระเครื่อง', style: MyConfig.logoText),
            SizedBox(height: screenHeight / 2),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor2)),
          ],
        ),
      ),
    );
  }
}
