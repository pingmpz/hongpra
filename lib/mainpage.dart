import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int selectedPage = 0;

  final searchController = new TextEditingController();
  RefreshController refreshController = new RefreshController(initialRefresh: false);
  TabController tabController;

  Widget searchTitle = Text("", style: MyConfig.normalText1);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  User loginUser;
  List<Amulet> amuletList = new List<Amulet>();
  List<History> historyList = new List<History>();

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    refreshController.dispose();
    tabController.dispose();
  }

  //------------------ Custom Functions ------------------
  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        loginUser = user;
        print("# Login User ID : " + loginUser.uid);
        generateAmuletList();
        generateHistoryList();
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

  void generateAmuletList() async {
    final checkUser = FirebaseAuth.instance.currentUser.uid;
    final _firestoreInstance = FirebaseFirestore.instance;

    amuletList = new List<Amulet>();

    _firestoreInstance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _firestoreInstance
            .collection("users")
            .doc(result.id) // amulets document ID
            .collection("amulets")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            //print("Result Id + " + result.id);
            setState(() {
              amuletList.add(
                new Amulet(
                    result.data()['amuletId'],
                    result.data()['image'],
                    result.data()['name'],
                    result.data()['categories'],
                    result.data()['texture'],
                    result.data()['information']),
              );
            });
          });
        });
      });
    });
  }

  void generateHistoryList() async {
      setState(() {
        int day = 24;
        //-- Need sort desc before add
        historyList.add(new History(1, "9999999", "PING", new DateTime.now()));
        historyList.add(new History(2, "8888888", "BOY", new DateTime.now().subtract(Duration(hours: day))));
        historyList.add(new History(1, "7777777", "KEN", new DateTime.now().subtract(Duration(hours: day))));
        historyList.add(new History(2, "6666666", "TURBO", new DateTime.now().subtract(Duration(hours: day * 2))));
        historyList.add(new History(1, "5555555", "PLAYSPACE", new DateTime.now().subtract(Duration(hours: day * 3))));
      });
  }

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
        ModalRoute.withName('/'));
  }

  void search() {
    setState(() {
      String result = searchController.text;
      for (Amulet item in amuletList) {
        if (item.amuletName.toLowerCase().contains(result.toLowerCase())) {
          item.isActive = true;
        } else {
          item.isActive = false;
        }
      }
    });
  }

  void reset() {
    setState(() {
      for (Amulet item in amuletList) {
        item.isActive = true;
      }
    });
  }

  void refresh() async {
    setState(() async {
      generateAmuletList();
      searchController.clear();
      await Future.delayed(Duration(milliseconds: 1000));
      refreshController.refreshCompleted();
    });
  }

  void onPageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
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
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);

    int gridCount = minGridCount +
        ((screenWidth < minWidth)
            ? 0
            : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    //------------------ Custom Widgets ------------------
    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.account_circle),
        color: MyConfig.whiteColor,
        onPressed: () {
          setState(() {});
        },
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

    //----------------- Page 0 -------------------
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
                      onChanged: (text) => {search()},
                    ),
                  );
                } else {
                  this.searchIcon =
                      Icon(Icons.search, color: MyConfig.whiteColor);
                  this.searchTitle = Text("", style: MyConfig.normalText1);
                  reset();
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buildAmuletCard(
        String id, String image, amuletName, amuletCategories, texture, info) {
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
                      child: (image != null) ? Image.network(image) : Image(image: AssetImage("assets/images/notfound.png")),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(amuletName, style: MyConfig.normalBoldText1),
                        Text("ประเภท : " + amuletCategories,
                            style: MyConfig.smallText1),
                        Text("เนื้อพระ : " + texture,
                            style: MyConfig.smallText1),
                        Text("รายละเอียด : " + info,
                            style: MyConfig.smallText1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyDetailPage(id)))
            },
          ),
        ),
      );
    }

    List<Widget> amuletCardBuilder() {
      List<Amulet> showingList =
          amuletList.where((element) => element.isActive == true).toList();
      return List<Widget>.generate(showingList.length, (index) {
        return buildAmuletCard(
            showingList[index].id != null ? showingList[index].id : "",
            showingList[index].image != null ? showingList[index].image : "",
            showingList[index].amuletName != null
                ? showingList[index].amuletName
                : "",
            showingList[index].amuletCategories != null
                ? showingList[index].amuletCategories
                : "",
            showingList[index].texture != null
                ? showingList[index].texture
                : "",
            showingList[index].info != null ? showingList[index].info : "");
      });
    }

    Widget amuletGrid = GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: gridRatio,
      children: amuletCardBuilder(),
    );

    Widget page_0 = Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: mySearchBar,
      body: SmartRefresher(
        enablePullDown: true,
        controller: refreshController,
        onRefresh: refresh,
        //header: WaterDropHeader(),
        child: amuletGrid,
      ),
    );

    //----------------- Page 1 -------------------

    //----------------- Page 2 -------------------

    Widget myTabBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor2,
      title: Text('ประวัติกิจกรรม', style: MyConfig.largeBoldText),
      bottom: TabBar(
        controller: tabController,
        labelColor: MyConfig.blackColor,
        labelStyle: MyConfig.normalBoldText1,
        unselectedLabelColor: MyConfig.greyColor,
        unselectedLabelStyle: MyConfig.normalBoldText1,
        indicatorColor: MyConfig.themeColor1,
        tabs: [
          Tab(text: "ทั้งหมด"),
          Tab(text: "ส่งมอบ"),
          Tab(text: "รับมอบ"),
        ],
      ),
    );

    Widget historyHeader(int day, int month, int year){
      List<String> monthName = ['มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม'];
      // day = day + 1;
      month = month - 1;
      year = year + 543;
      return Card(
        color: MyConfig.transparentColor,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(cardInnerEdge * 3),
          child:
          Text(day.toString() + " " + monthName[month] + " " + year.toString(), style: MyConfig.normalText1),
        ),
      );
    }

    Widget historyCard(int type,String certificateId,String name){
      String typeName = (type == 1)?"ส่งมอบ":"รับมอบ";
      String typeUser = (type == 1)?"ผู้รับมอบ":"ผู้ส่งมอบ";
      return Card(
        color: MyConfig.whiteColor,
        child: Padding(
          padding: EdgeInsets.all(cardInnerEdge * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(typeName, style: MyConfig.normalBoldText1),
              Text("รหัสใบรับรอง : " + certificateId,
                  style: MyConfig.smallText1),
              Text(typeUser + " : " + name,
                  style: MyConfig.smallText1),
            ],
          ),
        ),
      );
    }

    List<Widget> buildHistoryCard(int type){
      List<History> showingList = historyList;
      if(type != 0) showingList = historyList.where((element) => element.type == type).toList();
      List<Widget> resultList = new List<Widget>();
      if(showingList.length != 0) {
        DateTime selectedDate = new DateTime.now().subtract(Duration(hours: 999999));
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        String selectedDateF = formatter.format(selectedDate);
        for (int i = 0; i < showingList.length; i++) {
          String showingDateF = formatter.format(showingList[i].timestamp);
          if(selectedDateF != showingDateF){
            selectedDateF = showingDateF;
            resultList.add(historyHeader(showingList[i].timestamp.day, showingList[i].timestamp.month, showingList[i].timestamp.year));
          }
          resultList.add(historyCard(showingList[i].type, showingList[i].certificateId, showingList[i].name));
        }
      }
      return resultList;
    }

    Widget page_2 = DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: myTabBar,
        body: Container(
          padding: EdgeInsets.only(top: screenEdge),
          color: MyConfig.themeColor2,
          child: TabBarView(
            children: [
              Container(
                height: screenHeight,
                color: MyConfig.themeColor2,
                child: ListView(
                  children: buildHistoryCard(0),
                ),
              ),
              Container(
                height: screenHeight,
                color: MyConfig.themeColor2,
                child: ListView(
                  children: buildHistoryCard(1),
                ),
              ),
              Container(
                height: screenHeight,
                color: MyConfig.themeColor2,
                child: ListView(
                  children: buildHistoryCard(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //--------------------------------------------

    Widget buildPage() {
      Widget currentPage = SizedBox();
      setState(() {
        if (selectedPage == 0) {
          currentPage = page_0;
        } else if (selectedPage == 1) {
        } else if (selectedPage == 2) {
          currentPage = page_2;
        }
      });
      return currentPage;
    }

    Widget myBottomNavBar = BottomNavigationBar(
      backgroundColor: MyConfig.themeColor1,
      selectedItemColor: MyConfig.whiteColor,
      unselectedItemColor: MyConfig.whiteColor.withOpacity(0.5),
      selectedLabelStyle: MyConfig.normalText1,
      unselectedLabelStyle: MyConfig.normalText1,
      currentIndex: selectedPage,
      onTap: onPageChanged,
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
        body: buildPage(),
        bottomNavigationBar: myBottomNavBar,
      ),
    );
  }
}

class Amulet {
  String id;
  String image;
  String amuletName;
  String amuletCategories;
  String texture;
  String info;
  bool isActive = true;

  Amulet(this.id, this.image, this.amuletName, this.amuletCategories,
      this.texture, this.info);
}

class History {
  int type;
  String certificateId;
  String name;
  DateTime timestamp;

  History(this.type, this.certificateId, this.name, this.timestamp);
}
