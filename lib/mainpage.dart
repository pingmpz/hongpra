import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/longinpage.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  final searchController = new TextEditingController();

  Widget searchTitle = Text("", style: MyConfig.normalText2);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double innerEdge = 0.2;
    double gridRatio = 2.5;
    int minGridCount = 1;
    double searchBarHeight = 45.0;
    double cardTextWidth = double.infinity; // max width of card
    double boxCurve = 18.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth < minWidth)
        ? minEdge
        : min(screenWidth - minWidth, maxEdge);
    int gridCount = minGridCount +
        ((screenWidth < minWidth)
            ? 0
            : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

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
          onPressed: () {},
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
                if (this.searchIcon.icon == Icons.search) {
                  this.searchIcon = Icon(
                    Icons.close,
                    color: MyConfig.whiteColor,
                  );
                  this.searchTitle = TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: MyConfig.whiteColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.search, color: MyConfig.whiteColor),
                      hintText: "ค้นหา",
                      hintStyle: MyConfig.normalText2,
                    ),
                  );
                } else {
                  this.searchIcon =
                      Icon(Icons.search, color: MyConfig.whiteColor);
                  this.searchTitle = Text("", style: MyConfig.normalText2);
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buildCard(String path, List<String> texts) {
      return Container(
        margin: EdgeInsets.all(innerEdge),
        decoration: BoxDecoration(
          color: MyConfig.whiteColor,
//          borderRadius: BorderRadius.circular(boxCurve),
        ),
        child: Card(
          elevation: 0.0,
          child: InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(innerEdge),
                    child: Image(image: AssetImage(path))),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(texts[0], style: MyConfig.largeText1),
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
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyDetailPage(123456)));
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
        return buildCard('assets/images/lg.jpg', sampleTexts);
      }),
    );

    Widget myBottomNavBar = BottomNavigationBar(
      backgroundColor: MyConfig.themeColor1,
      selectedItemColor: MyConfig.whiteColor,
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
          backgroundColor: MyConfig.greyColor,
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
