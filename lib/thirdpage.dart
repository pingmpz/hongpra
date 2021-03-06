//-- Flutter Materials
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//-- Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//-- Pages and Models
import 'package:hongpra/myconfig.dart';
import 'package:hongpra/Model/History.dart';

class MyThirdPage extends StatefulWidget {
  final User loginUser;
  MyThirdPage(this.loginUser);

  @override
  _MyThirdPageState createState() => _MyThirdPageState();
}

class _MyThirdPageState extends State<MyThirdPage> {
  TabController tabController;

  //-- Firebase
  User loginUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loginUser = widget.loginUser;
  }

  @override
  void dispose() {
    super.dispose();
    //tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    // double minHeight = 600.0;
    double screenMinEdge = 9.0;
    double screenMaxEdge = 18.0;
    double cardInnerEdge = 2.5;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    // double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    Widget myTabBar = AppBar(
      elevation: 0.0,
      backgroundColor: MyConfig.themeColor2,
      title: Center(child: Text('ประวัติกิจกรรม', style: MyConfig.largeBoldTextBlack)),
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
          child: Text(MyConfig.dateText(dateTime), style: MyConfig.normalTextBlack),
        ),
      );
    }

    Widget buildHistoryCardName(int type, String id) {
      String typeName = (type == 2) ? "ผู้ส่งมอบ : " : "ผู้รับมอบ : ";
      if (type != null && id != null) {
        return StreamBuilder<DocumentSnapshot>(
          stream: _firestoreInstance.collection("users").doc(id).snapshots(),
          builder: (context, snapshot) {
            String name = "", firstName = "", lastName = "";
            if (snapshot.hasData) {
              firstName = (snapshot.data['firstName'] != null) ? snapshot.data['firstName'] : "";
              lastName = (snapshot.data['lastName'] != null) ? snapshot.data['lastName'] : "";
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
      List<History> tempList = new List<History>();
      snapshot.docs.forEach((element) => tempList.add(new History.fromDocumentSnapshot(element)));
      //-- IF NO ORDER BY -> CUSTOM SORTING
      Comparator<History> comparator = (a, b) => a.timestamp.compareTo(b.timestamp);
      tempList.sort(comparator);
      tempList = tempList.reversed.toList();
      //-- END IF
      String selectedDate = DateFormat('dd-MM-yyyy').format(new DateTime.now().subtract(Duration(hours: 999999)));
      for (int i = 0; i < tempList.length; i++) {
        History showingHistory = tempList[i];
        if (type != 0 && showingHistory.type != type) {
          continue;
        } else {
          if(showingHistory.timestamp != null) { //-- for error protection when adding history (server time delay?)
            String showingDate = DateFormat('dd-MM-yyyy').format(showingHistory.timestamp);
            if (selectedDate != showingDate) {
              selectedDate = showingDate;
              resultList.add(buildHistoryHeader(showingHistory.timestamp));
            }
          }
          resultList.add(buildHistoryCard(showingHistory));
        }
      }
      return resultList;
    }

    Widget historyCardListBuilder(int type) {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestoreInstance.collection("histories").where("userId", isEqualTo: loginUser.uid).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)))
              : (snapshot.data.size == 0) ? emptyHistoryList(type)
              : ListView(children: buildHistoryCardList(type, snapshot.data));
        },
      );
    }

    //-------------------------------------------------------------------------------------------------------- Page [2]

    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Scaffold(
            appBar: myTabBar,
            body: (loginUser != null)
                ? Container(
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
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
