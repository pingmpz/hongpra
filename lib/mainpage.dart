import 'dart:math';
import 'dart:ui';
import 'dart:collection';

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

import 'Data/Amulet.dart';
import 'Data/Certificate.dart';
import 'Data/AmuletCard.dart';
import 'Data/History.dart';
import 'Data/Person.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int selectedPage = 0;

  //-- Controller
  final searchController = new TextEditingController();
  RefreshController refreshAmuletListController =
      new RefreshController(initialRefresh: false);
  RefreshController refreshHistoryListController =
      new RefreshController(initialRefresh: false);
  TabController tabController;

  //-- Widget -> Animation & Switch
  Widget searchTitle = Text("", style: MyConfig.normalTextBlack);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  //-- Firebase
  User loginUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Items
  List<AmuletCard> amuletList = new List<AmuletCard>();
  List<History> historyList = new List<History>();
  Person currentUser = new Person('', '', '', '');

  //-- Items State
  bool _isAmuletListLoaded = false;
  bool _isHistoryListLoaded = false;

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
    refreshAmuletListController.dispose();
    refreshHistoryListController.dispose();
    // tabController.dispose();
  }

  void getCurrentUser() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        loginUser = FirebaseAuth.instance.currentUser;
        print("# Login User ID : " + loginUser.uid);
        getUserInfo();
        generateAmuletList();
        generateHistoryList();
      } else {
        Future(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyLoginPage()), ModalRoute.withName('/'));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getUserInfo() async {
    DocumentSnapshot result =
    await _firestoreInstance.collection("users").doc(loginUser.uid).get();
    currentUser = new Person(
      (result.data()['userId'] != null) ? result.data()['userId'] : "",
      (result.data()['firstName'] != null) ? result.data()['firstName'] : "",
      (result.data()['lastName'] != null) ? result.data()['lastName'] : "",
      (result.data()['uniqueId'] != null) ? result.data()['uniqueId'] : "",
    );
  }

  void generateAmuletList() async {
    setState(() {
      amuletList = new List<AmuletCard>();
      _isAmuletListLoaded = false;
    });

    QuerySnapshot result = await _firestoreInstance
        .collection("users")
        .doc(loginUser.uid)
        .collection("amulet")
        .get();
    if (result.size == 0) setState(() => _isAmuletListLoaded = true);
    result.docs.forEach((value) {
      setState(() {
        amuletList.add(new AmuletCard(
          Amulet(
            (value.data()['amuletId'] != null) ? value.data()['amuletId'] : "",
            (value.data()['amuletImageList'] != null)
                ? HashMap<String, dynamic>.from(value.data()['amuletImageList'])
                    .values
                    .toList()
                    .cast<String>()
                : [],
            (value.data()['name'] != null) ? value.data()['name'] : "",
            (value.data()['categories'] != null)
                ? value.data()['categories']
                : "",
            (value.data()['texture'] != null) ? value.data()['texture'] : "",
            (value.data()['information'] != null)
                ? value.data()['information']
                : "",
          ),
          Certificate(
            (value.data()['certificateId'] != null)
                ? value.data()['certificateId']
                : "",
            (value.data()['certificateImage'] != null)
                ? value.data()['certificateImage']
                : "",
            (value.data()['confirmBy'] != null)
                ? value.data()['confirmBy']
                : "",
            (value.data()['confirmDate'] != null)
                ? value.data()['confirmDate'].toDate()
                : null,
          ),
        ));
        _isAmuletListLoaded = true;
      });
    });
  }

  void generateHistoryList() async {
    setState(() {
      historyList = new List<History>();
      _isHistoryListLoaded = false;
    });

    QuerySnapshot result = await _firestoreInstance
        .collection("users")
        .doc(loginUser.uid)
        .collection("history")
        .orderBy("date", descending: true)
        .get();
    if (result.size == 0) setState(() => _isHistoryListLoaded = true);
    result.docs.forEach((value) async {
      String receiverName = "";
      String senderName = "";
      if (value.data()['receiverId'] != null) {
        DocumentSnapshot user = await _firestoreInstance.collection("users").doc(value.data()['receiverId']).get();
        String firstName = (user.data()['firstName'] != null) ? user.data()['firstName'] : "";
        String lastName = (user.data()['lastName'] != null) ? user.data()['lastName'] : "";
        receiverName = firstName + " " + lastName;
      }
      if (value.data()['senderId'] != null) {
        DocumentSnapshot user = await _firestoreInstance.collection("users").doc(value.data()['senderId']).get();
        String firstName = (user.data()['firstName'] != null) ? user.data()['firstName'] : "";
        String lastName = (user.data()['lastName'] != null) ? user.data()['lastName'] : "";
        senderName = firstName + " " + lastName;
      }
      setState(() {
        historyList.add(new History(
          (value.data()['type'] != null) ? value.data()['type'] : -1,
          (value.data()['certificateId'] != null)
              ? value.data()['certificateId']
              : "",
          (value.data()['receiverId'] != null)
              ? value.data()['receiverId']
              : "",
          receiverName,
          (value.data()['senderId'] != null) ? value.data()['senderId'] : "",
          senderName,
          (value.data()['date'] != null) ? value.data()['date'].toDate() : null,
        ));
        // _isHistoryListLoaded = true;
      });
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyLoginPage()));
  }

  void search() {
    setState(() {
      String result = searchController.text;
      for (AmuletCard item in amuletList) {
        if (item.amulet.name.toLowerCase().contains(result.toLowerCase())) {
          item.isShowing = true;
        } else if (item.certificate.confirmBy
            .toLowerCase()
            .contains(result.toLowerCase())) {
          item.isShowing = true;
        } else {
          item.isShowing = false;
        }
      }
    });
  }

  void reset() {
    setState(() {
      for (AmuletCard item in amuletList) {
        item.isShowing = true;
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

  bool historyListIsNotEmpty(int type) {
    List<History> showingList = historyList;
    if (type != 0)
      showingList = historyList.where((element) => element.type == type).toList();
    if (showingList.isNotEmpty) return true;
    return false;
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
    double loginButtonWidth = double.infinity;
    double loginButtonHeight = 40.0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth)
        ? screenMinEdge
        : min(screenWidth - minWidth, screenMaxEdge);

    int gridCount = minGridCount +
        ((screenWidth < minWidth)
            ? 0
            : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    //-------------------------------------------------------------------------------------------------------- Widgets [ALL]

    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
    );

    Widget loadingEffect = Container(
      child: Center(
        child: Loading(
            indicator: BallPulseIndicator(),
            size: 50.0,
            color: MyConfig.themeColor1),
      ),
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
                      style: MyConfig.normalTextBlack,
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
                        hintStyle: MyConfig.normalTextBlack,
                      ),
                      onChanged: (text) => {search()},
                    ),
                  );
                } else {
                  this.searchIcon =
                      Icon(Icons.search, color: MyConfig.whiteColor);
                  this.searchTitle = Text("", style: MyConfig.normalTextBlack);
                  reset();
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buildAmuletCard(AmuletCard amuletCard) {
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
                      child: (amuletCard.amulet.images[0] != "")
                          ? Image.network(amuletCard.amulet.images[0])
                          : Image(
                              image: AssetImage("assets/images/notfound.png")),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(amuletCard.amulet.name,
                              style: MyConfig.normalBoldTextBlack),
                          Text("ประเภท : " + amuletCard.amulet.categories,
                              style: MyConfig.smallTextBlack),
                          Text(
                              "วันที่รับรอง : " +
                                  MyConfig.dateText(
                                      amuletCard.certificate.confirmDate),
                              style: MyConfig.smallTextBlack),
                          Text(
                              "รับรองโดย : " + amuletCard.certificate.confirmBy,
                              style: MyConfig.smallTextBlack),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyDetailPage(
                          amuletCard.amulet, amuletCard.certificate)))
            },
          ),
        ),
      );
    }

    List<Widget> amuletCardBuilder() {
      List<AmuletCard> showingList =
          amuletList.where((element) => element.isShowing == true).toList();
      return List<Widget>.generate(showingList.length, (index) {
        return buildAmuletCard(showingList[index]);
      });
    }

    Widget amuletGrid = GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: gridRatio,
      children: amuletCardBuilder(),
    );

    Widget emptyAmuletScreen = Container(
      child: Center(
        child: Text('คุณยังไม่มีพระในครอบครอง',
            style: MyConfig.normalBoldTextTheme1),
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
        child: (amuletList.isNotEmpty)
            ? amuletGrid
            : (_isAmuletListLoaded)
                ? emptyAmuletScreen
                : loadingEffect,
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
              Text('QR Code', style: MyConfig.largeBoldTextTheme1),
              SizedBox(height: screenHeight * 0.005),
              Container(
                  height: desireHeight / 2,
                  child: Center(
                    child: (loginUser != null)
                        ? QrImage(
                            data: loginUser.uid,
                            version: QrVersions.auto,
                            size: min(300.0, 300.0 * (screenWidth / minWidth)),
                          )
                        : Image(
                            image: AssetImage('assets/images/notfound.png')),
                  )),
              SizedBox(height: screenHeight * 0.005),
              Text('UID', style: MyConfig.largeBoldTextTheme1),
              SizedBox(height: screenHeight * 0.01),
              Center(
                  child: Text(currentUser.uniqueId,
                      style: MyConfig.largeBoldTextBlack
                          .copyWith(letterSpacing: 2))),
            ],
          ),
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Widgets [PAGE : 2]

    Widget myTabBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor2,
      title: Text('ประวัติกิจกรรม', style: MyConfig.largeBoldTextBlack),
      bottom: TabBar(
        controller: tabController,
        labelColor: MyConfig.blackColor,
        labelStyle: MyConfig.normalBoldTextBlack,
        unselectedLabelColor: MyConfig.greyColor,
        unselectedLabelStyle: MyConfig.normalBoldTextBlack,
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
          child: Text(MyConfig.dateText(dateTime),
              style: MyConfig.normalTextBlack),
        ),
      );
    }

    Widget historyCard(History history) {
      String typeName = (history.type == 1) ? "ส่งมอบ" : "รับมอบ";
      String hourText = (history.timestamp.hour < 10)
          ? "0" + history.timestamp.hour.toString()
          : history.timestamp.hour.toString();
      String minuteText = (history.timestamp.minute < 10)
          ? "0" + history.timestamp.minute.toString()
          : history.timestamp.minute.toString();
      String time = hourText + "." + minuteText;
      return Card(
        color: MyConfig.whiteColor,
        child: Padding(
          padding: EdgeInsets.all(cardInnerEdge * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(typeName, style: MyConfig.normalBoldTextBlack),
              Text("รหัสใบรับรอง : " + history.certificateId,
                  style: MyConfig.smallTextBlack),
              (history.type == 1)
                  ? Text("ผู้รับมอบ : " + history.receiverName,
                      style: MyConfig.smallTextBlack)
                  : SizedBox(),
              (history.type == 2)
                  ? Text("ผู้ส่งมอบ : " + history.senderName,
                      style: MyConfig.smallTextBlack)
                  : SizedBox(),
              Text("เวลา : " + time, style: MyConfig.smallTextBlack),
            ],
          ),
        ),
      );
    }

    List<Widget> buildHistoryCard(int type) {
      List<Widget> resultList = new List<Widget>();
      List<History> showingList = historyList;
      if (type != 0)
        showingList =
            historyList.where((element) => element.type == type).toList();
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
          resultList.add(historyCard(showingList[i]));
        }
      }
      return resultList;
    }

    Widget buildEmptyHistoryScreen(int type) {
      String text = "";
      if (type == 0) {
        text = "คุณยังไม่มีประวัติกิจกรรม";
      } else if (type == 1) {
        text = "คุณยังไม่มีประวัติการส่งมอบ";
      } else if (type == 2) {
        text = "คุณยังไม่มีประวัติการรับมอบ";
      }
      return Container(
        child: Center(
          child: Text(text, style: MyConfig.normalBoldTextTheme1),
        ),
      );
    }

    //-------------------------------------------------------------------------------------------------------- Page [2]

    Widget page_2 = DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Scaffold(
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
                      child: (historyListIsNotEmpty(0))
                          ? ListView(
                              children: buildHistoryCard(0),
                            )
                          : (_isHistoryListLoaded)
                              ? buildEmptyHistoryScreen(0)
                              : loadingEffect,
                    ),
                  ),
                  Container(
                    height: screenHeight,
                    color: MyConfig.themeColor2,
                    child: SmartRefresher(
                      enablePullDown: true,
                      controller: refreshHistoryListController,
                      onRefresh: refreshHistoryList,
                      child: (historyListIsNotEmpty(1))
                          ? ListView(
                              children: buildHistoryCard(1),
                            )
                          : (_isHistoryListLoaded)
                              ? buildEmptyHistoryScreen(1)
                              : loadingEffect,
                    ),
                  ),
                  Container(
                    height: screenHeight,
                    color: MyConfig.themeColor2,
                    child: SmartRefresher(
                      enablePullDown: true,
                      controller: refreshHistoryListController,
                      onRefresh: refreshHistoryList,
                      child: (historyListIsNotEmpty(2))
                          ? ListView(
                              children: buildHistoryCard(2),
                            )
                          : (_isHistoryListLoaded)
                              ? buildEmptyHistoryScreen(2)
                              : loadingEffect,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page [3]

    Widget page_3 = Container(
      color: MyConfig.themeColor2,
      height: screenHeight,
      child: Container(
        margin: EdgeInsets.all(screenEdge),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: loginButtonWidth,
                height: loginButtonHeight,
                child: RaisedButton(
                  onPressed: () => signOut(),
                  color: MyConfig.redColor,
                  child: Text('ออกจากระบบ', style: MyConfig.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //-------------------------------------------------------------------------------------------------------- Page [ALL]

    Widget buildPage() {
      Widget currentPage = SizedBox();
      setState(() {
        switch (selectedPage) {
          case 0:
            currentPage = page_0;
            break;
          case 1:
            currentPage = page_1;
            break;
          case 2:
            currentPage = page_2;
            break;
          case 3:
            currentPage = page_3;
            break;
        }
      });
      return currentPage;
    }

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
        body: buildPage(),
        bottomNavigationBar: myBottomNavBar,
      ),
    );
  }
}
