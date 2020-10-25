import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/loginpage.dart';
import 'package:page_transition/page_transition.dart';

class MyMainPage extends StatefulWidget {
  // final FirebaseAuth _auth;
  // MyMainPage(this._auth, {Key key}) : super(key: key);

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  User loginUser;
  List<Data> items = new List<Data>();

  final searchController = new TextEditingController();

  Widget searchTitle = Text("", style: MyConfig.normalText1);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //------------------ Custom Methods ------------------
  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;

      if (user != null) {
        loginUser = user;

        print("user id is " + loginUser.uid);

        // --> generate list

        generateItems();


      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyLoginPage()),
            ModalRoute.withName('/'));
      }
    } catch (e) {
      print(e.toString());
    }
  }


  void generateItems() async {

    items = new List<Data>();

    final _firestoreInstance = FirebaseFirestore.instance;

    _firestoreInstance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _firestoreInstance
            .collection("users")
            .doc(result.id)
            .collection("amulets")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {

            items.add(new Data(
                result.data()['images'],
                result.data()['name'],
                result.data()['categories'],
                result.data()['texture'],
                result.data()['information']));
          });
        });
      });
    });
  }

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double searchBarHeight = 45.0;
    double searchBardEdge = 7.5;
    double boxCurve = 18.0;
    double gridRatio = 2.5;
    int minGridCount = 1;
    double cardInnerEdge = 2.5;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;

    int gridCount = minGridCount +
        ((screenWidth < minWidth)
            ? 0
            : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    //------------------ Sample Variables ------------------
    String path = 'assets/images/amulet1.jpg';

    List<String> sampleTexts = [
      'พระกริ่งชัย-วัฒน์ทั่วไป',
      'ชื่อพระ : พระชัยวัฒน์',
      'พิมพ์พระ : พิมพ์อุดมีกริ่ง',
      'เนื้อพระ : ทองเหลือง',
      'สถานที่ : วัดชนะสงคราม พ.ศ. 2484',
      'วันที่รับรอง : 8 พฤศจิกายน 2562'
    ];

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.account_circle),
        color: MyConfig.whiteColor,
        onPressed: () {},
      ),
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            signOut(context);
          },
        ),
      ],
    );

    Widget mySearchBar = PreferredSize(
      preferredSize: Size.fromHeight(searchBarHeight),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: MyConfig.themeColor1,
        automaticallyImplyLeading: false,
        title: searchTitle,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                searchController.clear();
                if (this.searchIcon.icon == Icons.search) {
                  this.searchIcon = Icon(
                    Icons.close,
                    color: MyConfig.whiteColor,
                  );
                  this.searchTitle = Container(
                    height: searchBarHeight - searchBardEdge,
                    child: TextField(
                      controller: searchController,
                      style: MyConfig.normalText1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyConfig.whiteColor,
                        contentPadding: EdgeInsets.only(
                            bottom: (searchBarHeight - searchBardEdge) / 2),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(boxCurve)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: MyConfig.blackColor),
                        hintText: "ค้นหา",
                        hintStyle: MyConfig.normalText1,
                      ),
                    ),
                  );
                } else {
                  this.searchIcon =
                      Icon(Icons.search, color: MyConfig.whiteColor);
                  this.searchTitle = Text("", style: MyConfig.normalText1);
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buildCard(String path, List<String> texts, int index) {
      return Container(
        margin: EdgeInsets.all(cardInnerEdge),
        child: Card(
          color: MyConfig.whiteColor,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(cardInnerEdge * 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.all(cardInnerEdge),
                        child: Image(image: AssetImage(path))),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(texts[0], style: MyConfig.normalBoldText1),
                        Text(texts[1], style: MyConfig.smallText1),
                        Text(texts[2], style: MyConfig.smallText1),
                        Text(texts[3], style: MyConfig.smallText1),
                        Text(texts[4], style: MyConfig.smallText1),
                        Text(texts[5], style: MyConfig.smallText1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: MyDetailPage(index)));
            },
          ),
        ),
      );
    }

    Widget myGrid = GridView.count(
      //controller: scrollController,
      crossAxisCount: gridCount,
      childAspectRatio: gridRatio,
      children: List.generate(7, (index) {
        return buildCard(path, sampleTexts, index);
      }),
    );

    Widget myBottomNavBar = BottomNavigationBar(
      backgroundColor: MyConfig.themeColor1,
      selectedItemColor: MyConfig.whiteColor,
      unselectedItemColor: MyConfig.whiteColor.withOpacity(0.5),
      selectedLabelStyle: MyConfig.normalText1,
      unselectedLabelStyle: MyConfig.normalText1,
      items: const <BottomNavigationBarItem>[
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
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: myAppBar,
        backgroundColor: MyConfig.themeColor1,
        body: Scaffold(
          backgroundColor: MyConfig.themeColor2,
          appBar: mySearchBar,
          body: Container(
            child: myGrid,
          ),
        ),
        bottomNavigationBar: myBottomNavBar,
      ),
    );
  }
}

class Data {
  String image;
  String amuletName;
  String amuletCategories;
  String texture;
  String info;

  Data(this.image, this.amuletName, this.amuletCategories, this.texture,
      this.info);
}
