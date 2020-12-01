import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hongpra/splashpage.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //---
  bool testing = true;

  if (testing)
    runApp(DevicePreview(builder: (context) => MyTestApp()));
  else
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplashPage(),
    );
  }
}

class MyTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สุดยอดพระเครื่อง',
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: MySplashPage(),
    );
  }
}
