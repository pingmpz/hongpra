import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int selectedPage = 0;

  //-- Controller
  final searchController = new TextEditingController();
  RefreshController refreshAmuletListController = new RefreshController(initialRefresh: false);
  RefreshController refreshHistoryListController = new RefreshController(initialRefresh: false);
  TabController tabController;

  //-- Animation & Switch
  Widget searchTitle = Text("", style: MyConfig.normalText1);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  //-- Firebase
  User loginUser;
  final checkUser = FirebaseAuth.instance.currentUser.uid;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Items
  List<Amulet> amuletList = new List<Amulet>();
  List<History> historyList = new List<History>();
  String uid = "";
  String qrCode = "";

  //-- Items State
  bool _isLoadedAmuletList = false;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    //refreshAmuletListController.dispose();
    //refreshHistoryListController.dispose();
    //tabController.dispose();
  }

  void getCurrentUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loginUser = user;
        print("# Login User ID : " + loginUser.uid);
        generateAmuletList();
        generateHistoryList();
        getUID();
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
    setState(() {
      amuletList = new List<Amulet>();
      _isLoadedAmuletList = false;
    });

    var result = await _firestoreInstance.collection("users")
          .doc(checkUser)
          .collection("amulet")
          .get();

    result.docs.forEach((values) {
      setState(() {
        amuletList.add(
          new Amulet(
              (values.data()['amuletId'] != null) ? values.data()['amuletId'] : "",
              (values.data()['amuletImageList']['image1'] != null) ? values.data()['amuletImageList']['image1'] : "",
              (values.data()['name'] != null) ? values.data()['name'] : "",
              (values.data()['categories'] != null) ? values.data()['categories'] : "",
              (values.data()['texture'] != null) ? values.data()['texture'] : "",
              (values.data()['information'] != null) ? values.data()['information'] : ""),
        );
      });
    });
    setState(() => _isLoadedAmuletList = true);
  }

  void generateHistoryList() async {
    setState(() {
      historyList = new List<History>();
    });

    var result = await _firestoreInstance
          .collection("users")
          .doc(checkUser)
          .collection("history")
          .orderBy("date", descending: true)
          .get();

    result.docs.forEach((values) {
      setState(() {
        historyList.add(new History(
          (values.data()['type'] != null) ? values.data()['type'] : -1,
          (values.data()['certificateId'] != null) ? values.data()['certificateId'] : "",
          (values.data()['receiverId'] != null) ? values.data()['receiverId'] : "",
          (values.data()['senderId'] != null) ? values.data()['senderId'] : "",
          (values.data()['date'] != null) ? values.data()['date'].toDate() : null,
        ));
      });
    });
  }

  void getUID() async {
    historyList = new List<History>();

    var result = await _firestoreInstance.collection("users").doc(checkUser).get();
    uid = (result.data()['uniqueId'] != null) ? result.data()['uniqueId'] : "";
    qrCode = (result.data()['userId'] != null) ? result.data()['userId'] : "";
  }

  void signOut() {
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
        if (item.name.toLowerCase().contains(result.toLowerCase())) {
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

  void refreshAmuletList() async {
    setState(() async {
      generateAmuletList();
      searchController.clear();
      await Future.delayed(Duration(milliseconds: 1000));
      refreshAmuletListController.refreshCompleted();
    });
  }

  void refreshHistoryList() async {
    setState(() async {
      generateHistoryList();
      await Future.delayed(Duration(milliseconds: 1000));
      refreshHistoryListController.refreshCompleted();
    });
  }

  void onPageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
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
    //double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    int gridCount = minGridCount + ((screenWidth < minWidth) ? 0 : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    //-------------------------------------------------------------------------------------------------------- Widgets [ALL]

    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.account_circle),
        color: MyConfig.whiteColor,
        onPressed: () {
        },
      ),
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => signOut(),
        ),
      ],
    );

    //-------------------------------------------------------------------------------------------------------- Widgets [PAGE : 0]

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
                      child: (image != "")
                          ? Image.network(image)
                          : Image(
                              image: AssetImage("assets/images/notfound.png")),
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
            showingList[index].id,
            showingList[index].image,
            showingList[index].name,
            showingList[index].category,
            showingList[index].texture,
            showingList[index].info);
      });
    }

    Widget amuletGrid = GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: gridRatio,
      children: amuletCardBuilder(),
    );

    Widget loadingEffect = Container(
      child: Center(
        child: Loading(
            indicator: BallPulseIndicator(),
            size: 50.0,
            color: MyConfig.themeColor1),
      ),
    );

    Widget emptyAmuletScreen = Container(
      child: Center(
        child: Text('คุณยังไม่มีพระในครอบครอง', style: MyConfig.normalBoldText4),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page [0]

    Widget page_0 = Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: mySearchBar,
      body: SmartRefresher(
        enablePullDown: true,
        controller: refreshAmuletListController,
        onRefresh: refreshAmuletList,
        child: (amuletList.isNotEmpty) ? amuletGrid : (_isLoadedAmuletList) ? emptyAmuletScreen : loadingEffect,
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page [1]

    Widget page_1 = Container(
      color: MyConfig.themeColor2,
      height: screenHeight,
      child: Container(
        margin: EdgeInsets.all(screenEdge),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('QR Code', style: MyConfig.largeBoldText4),
              SizedBox(height: screenHeight * 0.005),
              Container(
                  height: desireHeight / 2,
                  child: Center(
                    child: (qrCode != "")
                        ? QrImage(
                            data: qrCode,
                            version: QrVersions.auto,
                            size: min(300.0, 300.0 * (screenWidth/minWidth)),
                          )
                        : Image(image: AssetImage('assets/images/notfound.png')),
                  )),
              SizedBox(height: screenHeight * 0.005),
              Text('UID', style: MyConfig.largeBoldText4),
              SizedBox(height: screenHeight * 0.01),
              Center(child: Text(uid, style: MyConfig.largeBoldText1)),
            ],
          ),
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Widgets [PAGE : 1]

    Widget myTabBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor2,
      title: Text('ประวัติกิจกรรม', style: MyConfig.largeBoldText1),
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

    Widget historyHeader(DateTime dateTime) {
      return Card(
        color: MyConfig.transparentColor,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(cardInnerEdge * 3),
          child: Text(MyConfig.dateText(dateTime), style: MyConfig.normalText1),
        ),
      );
    }

    Widget historyCard(int type, String certificateId, String receiver,
        String sender, int hour, int minute) {
      String typeName = (type == 1) ? "ส่งมอบ" : "รับมอบ";
      String hourText = (hour < 10) ? "0" + hour.toString() : hour.toString();
      String minuteText =
          (minute < 10) ? "0" + minute.toString() : minute.toString();
      String time = hourText + "." + minuteText;
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
              (type == 1)
                  ? Text("ผู้รับมอบ : " + receiver, style: MyConfig.smallText1)
                  : SizedBox(),
              (type == 2)
                  ? Text("ผู้ส่งมอบ : " + sender, style: MyConfig.smallText1)
                  : SizedBox(),
              Text("เวลา : " + time, style: MyConfig.smallText1),
            ],
          ),
        ),
      );
    }

    List<Widget> buildHistoryCard(int type) {
      List<Widget> resultList = new List<Widget>();
      List<History> showingList = historyList;
      if (type != 0) showingList = historyList.where((element) => element.type == type).toList();
      if (showingList.isNotEmpty) {
        String selectedDate = DateFormat('dd-MM-yyyy')
            .format(new DateTime.now().subtract(Duration(hours: 999999)));
        for (int i = 0; i < showingList.length; i++) {
          String showingDate =
              DateFormat('dd-MM-yyyy').format(showingList[i].timestamp);
          if (selectedDate != showingDate) {
            selectedDate = showingDate;
            resultList.add(historyHeader(showingList[i].timestamp));
          }
          resultList.add(historyCard(
              showingList[i].type,
              showingList[i].certificateId,
              showingList[i].receiver,
              showingList[i].sender,
              showingList[i].timestamp.hour,
              showingList[i].timestamp.minute));
        }
      }
      return resultList;
    }

    //-------------------------------------------------------------------------------------------------------- Page [2]

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
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: refreshHistoryListController,
                  onRefresh: refreshHistoryList,
                  child: ListView(
                    children: buildHistoryCard(0),
                  ),
                ),
              ),
              Container(
                height: screenHeight,
                color: MyConfig.themeColor2,
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: refreshHistoryListController,
                  onRefresh: refreshHistoryList,
                  child: ListView(
                    children: buildHistoryCard(1),
                  ),
                ),
              ),
              Container(
                height: screenHeight,
                color: MyConfig.themeColor2,
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: refreshHistoryListController,
                  onRefresh: refreshHistoryList,
                  child: ListView(
                    children: buildHistoryCard(2),
                  ),
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
          currentPage = page_1;
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

//-------------------------------------------------------------------------------------------------------- Class

class Amulet {
  String id;
  String image;
  String name;
  String category;
  String texture;
  String info;
  bool isActive = true;

  Amulet(
      this.id, this.image, this.name, this.category, this.texture, this.info);
}

class History {
  int type;
  String certificateId;
  String receiver;
  String sender;
  DateTime timestamp;

  History(this.type, this.certificateId, this.receiver, this.sender,
      this.timestamp);
}
