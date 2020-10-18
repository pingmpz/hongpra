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
  final scrollController = ScrollController();
  final searchController = new TextEditingController();

  Widget searchTitle = Text("");
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.blackColor);

  @override
  Widget build(BuildContext context) {
    //------------------ Custom Variables ------------------
    double minWidth = 360.0;
    double minHeight = 600.0;
    double minEdge = 9.0;
    double maxEdge = 18.0;
    double innerEdge = 5.0;
    int minGridCount = 2;
    double searchBarHeight = 45.0;
    double cardTextWidth = double.infinity; // max width of card

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

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.account_circle),
        color: MyConfig.whiteColor,
        onPressed: () {},
      ),
      title: Text('ห้องพระ', style: MyConfig.smallTitleText),
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
      child: ScrollAppBar(
        backgroundColor: MyConfig.whiteColor,
        automaticallyImplyLeading: false,
        controller: scrollController,
        title: searchTitle,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                if (this.searchIcon.icon == Icons.search) {
                  this.searchIcon = Icon(
                    Icons.close,
                    color: MyConfig.blackColor,
                  );
                  this.searchTitle = TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: MyConfig.blackColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.search, color: MyConfig.blackColor),
                      hintText: "ค้นหา",
                      hintStyle: MyConfig.normalText1,
                    ),
                  );
                } else {
                  this.searchIcon =
                      Icon(Icons.search, color: MyConfig.blackColor);
                  this.searchTitle = Text("");
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buildCard(String path, String text) {
      return Card(
        elevation: 2.0,
        color: MyConfig.themeColor5,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: MyConfig.blackColor,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: innerEdge),
                    child: Image(image: AssetImage(path))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: cardTextWidth,
                      color: MyConfig.blackColor.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(text, style: MyConfig.normalText1),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyDetailPage(123456)));
          },
        ),
      );
    }

    Widget buildCard2(String path, String text) {
      return Card(
        elevation: 2.0,
        color: MyConfig.themeColor5,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: MyConfig.blackColor,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: innerEdge),
                    child: Image(image: AssetImage(path))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: cardTextWidth,
                      color: MyConfig.blackColor.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(text, style: MyConfig.normalText1),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyDetailPage(123456)));
          },
        ),
      );
    }

    Widget myList = ListView();

    Widget myGrid = GridView.count(
      //controller: scrollController,
      crossAxisCount: gridCount,
      childAspectRatio: 0.75,
      children: List.generate(0, (index) {
        return buildCard('assets/images/lg.jpg', 'พระเครื่องบูชา');
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
        body: Scaffold(
          backgroundColor: MyConfig.whiteColor,
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
