import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  TabController tabController;

  //-- Widget -> Animation & Switch
  Widget searchTitle = Text("", style: MyConfig.normalTextBlack);
  Icon searchIcon = new Icon(Icons.search, color: MyConfig.whiteColor);

  //-- Firebase
  User loginUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Items
  Person currentUser = new Person.fromEmpty();
  List<AmuletCard> amuletCardList = new List<AmuletCard>();

  //-- Search Stream
  StreamController<String> streamController = StreamController<String>.broadcast();
  Stream stream;

  //-------------------------------------------------------------------------------------------------------- Functions

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    stream = streamController.stream;
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    // tabController.dispose();
  }

  void getCurrentUser() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        loginUser = FirebaseAuth.instance.currentUser;
        print("##### Login User ID : " + loginUser.uid);
        DocumentSnapshot result = await _firestoreInstance.collection("users").doc(loginUser.uid).get();
        currentUser = new Person.fromDocumentSnapshot(result);
      } else {
        Future(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyLoginPage()), ModalRoute.withName('/'));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
  }

  void search(String value){
    streamController.add(value);
  }

  void searching(AsyncSnapshot<String> search) {
    for(AmuletCard ele in amuletCardList) {
      if(ele.amulet.name.toLowerCase().trim().contains(search.data.toLowerCase().trim()) == true
          || ele.certificate.confirmBy.toLowerCase().trim().contains(search.data.toLowerCase().trim()) == true
      ) ele.isShowing = true;
      else ele.isShowing = false;
    }
  }

  void onPageChanged(int index) {
    setState(() {
      if(selectedPage != index){
        searchController.clear();
      }
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
    double searchBarEdge = 7.5;
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
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    int gridCount = minGridCount + ((screenWidth < minWidth) ? 0 : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    //-------------------------------------------------------------------------------------------------------- Widgets [ALL]

    Widget myAppBar = AppBar(
      backgroundColor: MyConfig.themeColor1,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Text('ห้องพระ', style: MyConfig.appBarTitleText),
      centerTitle: true,
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
                    height: searchBarHeight - searchBarEdge,
                    child: TextField(
                      controller: searchController,
                      style: MyConfig.normalTextBlack,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyConfig.whiteColor,
                        contentPadding: EdgeInsets.only(bottom: searchBarEdge),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(boxCurve)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: MyConfig.blackColor),
                        hintText: "ค้นหา... ชื่อพระ/ชื่อผู้รับรอง",
                        hintStyle: MyConfig.normalTextGrey,
                      ),
                      onChanged: (value) => search(value),
                    ),
                  );
                } else {
                  this.searchIcon = Icon(Icons.search, color: MyConfig.whiteColor);
                  this.searchTitle = Text("", style: MyConfig.normalTextBlack);
                  search("");
                }
              });
            },
          ),
        ],
      ),
    );

    Widget emptyAmuletList = Container(
      child: Center(
        child: Text('คุณยังไม่มีพระในครอบครอง',
            style: MyConfig.normalBoldTextTheme1),
      ),
    );

    Widget emptySearchAmuletList = Container(
      child: Center(
        child: Text('ไม่พบพระที่ตรงกับคำค้นหา',
            style: MyConfig.normalBoldTextTheme1),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyDetailPage(amuletCard.amulet, amuletCard.certificate)))
            },
          ),
        ),
      );
    }

    Widget amuletCardListBuilder() {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestoreInstance.collection("users").doc(loginUser.uid).collection("amulet").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.size != 0){
            amuletCardList = new List<AmuletCard>();
            snapshot.data.docs.forEach((element) => amuletCardList.add(new AmuletCard.fromDocumentSnapshot(element)));
          }
          return (!snapshot.hasData)
              ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)))
              : (snapshot.data.size == 0) ? emptyAmuletList
              : StreamBuilder<String>(
              stream: stream,
              initialData: "",
              builder: (context, searchText){
                if(amuletCardList.isNotEmpty){
                  searching(searchText);
                }
                List<AmuletCard> showingList = amuletCardList.where((element) => element.isShowing == true).toList();
                return (showingList.length == 0) ? emptySearchAmuletList : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    childAspectRatio: gridRatio,
                  ),
                  itemCount: showingList.length,
                  itemBuilder: (context, index) {
                    return buildAmuletCard(showingList[index]);
                  },
                );
              }
          );
        },
      );
    }
    
    //-------------------------------------------------------------------------------------------------------- Page [0]

    Widget page_0 = Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: mySearchBar,
      body: (loginUser != null) ? amuletCardListBuilder() : SizedBox(),
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

    Widget emptyHistoryList(int type) {
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

    Widget buildHistoryHeader(DateTime dateTime) {
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

    Widget buildHistoryCardName(int type, String id) {
      String typeName = (type == 1) ? "ผู้ส่งมอบ : " : "ผู้รับมอบ : ";
      if(type != null && id != null) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestoreInstance.collection("users").where("userId", isEqualTo: id).limit(1).snapshots(),
          builder: (context, snapshot) {
            String name = "", firstName = "", lastName = "";
            if (snapshot.hasData) {
              snapshot.data.docs.forEach((result) {
                firstName = (result.data()['firstName'] != null) ? result.data()['firstName'] : "";
                lastName = (result.data()['lastName'] != null) ? result.data()['lastName'] : "";
              });
            }
            name = firstName + " " + lastName;
            return Text(typeName + name, style: MyConfig.smallTextBlack);
          },
        );
      } else {
        return Text(typeName, style: MyConfig.smallTextBlack);
      }
    }

    Widget buildHistoryCard(History history) {
      String typeName = (history.type == 1) ? "ส่งมอบ" : "รับมอบ";
      return Card(
        color: MyConfig.whiteColor,
        child: Padding(
          padding: EdgeInsets.all(cardInnerEdge * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(typeName, style: MyConfig.normalBoldTextBlack),
              Text("รหัสใบรับรอง : " + history.certificateId, style: MyConfig.smallTextBlack),
              (history.type == 1) ? buildHistoryCardName(history.type, history.receiverId) : SizedBox(),
              (history.type == 2) ? buildHistoryCardName(history.type, history.senderId) : SizedBox(),
              Text("เวลา : " + MyConfig.timeText(history.timestamp), style: MyConfig.smallTextBlack),
            ],
          ),
        ),
      );
    }

    List<Widget> buildHistoryCardList(int type, QuerySnapshot snapshot) {
      List<Widget> resultList = new List<Widget>();
      String selectedDate = DateFormat('dd-MM-yyyy').format(new DateTime.now().subtract(Duration(hours: 999999)));
      for (int i = 0; i < snapshot.size; i++) {
        History showingHistory = new History.fromDocumentSnapshot(snapshot.docs[i]);
        if(type != 0 && showingHistory.type != type) {
          continue;
        } else {
          String showingDate = DateFormat('dd-MM-yyyy').format(showingHistory.timestamp);
          if (selectedDate != showingDate) {
            selectedDate = showingDate;
            resultList.add(buildHistoryHeader(showingHistory.timestamp));
          }
          resultList.add(buildHistoryCard(showingHistory));
        }
      }
      return resultList;
    }

    Widget historyCardListBuilder(int type) {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestoreInstance.collection("users").doc(loginUser.uid).collection("history").orderBy("date", descending: true).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)))
              : (snapshot.data.size == 0) ? emptyHistoryList(type) : ListView(
              children : buildHistoryCardList(type, snapshot.data),
              );
        },
      );
    }

    //-------------------------------------------------------------------------------------------------------- Page [2]

    Widget page_2 = DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Scaffold(
            appBar: myTabBar,
            body: (loginUser != null) ? Container(
              padding: EdgeInsets.only(top: screenEdge),
              color: MyConfig.themeColor2,
              child: TabBarView(
                children: [
                  Container(
                    height: screenHeight,
                    color: MyConfig.themeColor2,
                    child: historyCardListBuilder(0),
                  ),
                  Container(
                    height: screenHeight,
                    color: MyConfig.themeColor2,
                    child: historyCardListBuilder(1),
                  ),
                  Container(
                    height: screenHeight,
                    color: MyConfig.themeColor2,
                    child: historyCardListBuilder(2),
                  ),
                ],
              ),
            ) : SizedBox(),
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
