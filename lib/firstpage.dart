import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hongpra/detailpage.dart';
import 'package:hongpra/myconfig.dart';

import 'Data/AmuletCard.dart';


class MyFirstPage extends StatefulWidget {
  final User loginUser;
  MyFirstPage(this.loginUser);

  @override
  _MyFirstPageState createState() => _MyFirstPageState();
}

class _MyFirstPageState extends State<MyFirstPage> {
  //-- Controller
  final searchController = new TextEditingController();
  StreamController<String> streamController = StreamController<String>.broadcast();
  Stream stream;
  bool _isClear = true;

  //-- Firebase
  User loginUser;
  final _firestoreInstance = FirebaseFirestore.instance;

  //-- Items
  List<AmuletCard> amuletCardList = new List<AmuletCard>();

  @override
  void initState() {
    super.initState();
    stream = streamController.stream;
    loginUser = widget.loginUser;
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void search(String value) {
    streamController.add(value);
    if(!_isClear && value.length > 0) return;
    else setState(() => _isClear = (value.length == 0) ? true : false);
  }

  void filter(AsyncSnapshot<String> search) {
    bool isContain(String text1, String text2) => text1.toLowerCase().trim().contains(text2.toLowerCase().trim());

    for (AmuletCard ele in amuletCardList) {
      ele.isShowing = (isContain(ele.amulet.name, search.data) || isContain(ele.certificate.confirmBy, search.data));
    }
  }

  void reset(){
    searchController.clear();
    streamController.add(searchController.text);
    setState(() => _isClear = true);
  }


  @override
  Widget build(BuildContext context) {
    //-- Sizing Variables
    double minWidth = 360.0;
    //double minHeight = 600.0;
    //double screenMinEdge = 9.0;
    //double screenMaxEdge = 18.0;
    double searchBarHeight = 45.0;
    double searchBarEdge = 7.5;
    double boxCurve = 18.0;
    double gridRatio = 2.5;
    int minGridCount = 1;
    double cardInnerEdge = 2.5;
    //double loginButtonWidth = double.infinity;
    //double loginButtonHeight = 40.0;

    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    //double desireWidth = (screenWidth < minWidth) ? screenWidth : minWidth;
    //double desireHeight = (screenHeight < minHeight) ? screenHeight : minHeight;
    //double screenEdge = (screenWidth <= minWidth) ? screenMinEdge : min(screenWidth - minWidth, screenMaxEdge);

    int gridCount = minGridCount + ((screenWidth < minWidth) ? 0 : ((screenWidth - minWidth) / (minWidth / minGridCount)).floor());

    Widget mySearchBar = PreferredSize(
      preferredSize: Size.fromHeight(searchBarHeight),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: MyConfig.themeColor1,
        automaticallyImplyLeading: false,
        title: Container(
          height: searchBarHeight - searchBarEdge,
          child: TextField(
            controller: searchController,
            style: MyConfig.normalTextBlack,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: searchBarEdge),
              filled: true,
              fillColor: MyConfig.whiteColor,
              hintText: "ค้นหา... ชื่อพระ/ชื่อผู้รับรอง",
              hintStyle: MyConfig.normalTextGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(boxCurve)),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: MyConfig.blackColor),
              suffixIcon: (_isClear) ? SizedBox() : IconButton(
                icon: Icon(Icons.clear),
                color: MyConfig.greyColor,
                onPressed: () => reset(),
              ),
            ),
            onChanged: (value) => search(value),
          ),
        ),
      ),
    );

    Widget emptyAmuletList = Container(child: Center(child: Text('คุณยังไม่มีพระในครอบครอง', style: MyConfig.normalBoldTextTheme1)));

    Widget emptySearchAmuletList = Container(child: Center(child: Text('ไม่พบพระที่ตรงกับคำค้นหา', style: MyConfig.normalBoldTextTheme1)));

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
                      child: (amuletCard.amulet.images.isNotEmpty)
                          ? Image.network(amuletCard.amulet.images[0])
                          : Image(image: AssetImage("assets/images/notfound.png")),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(amuletCard.amulet.name, style: MyConfig.normalBoldTextBlack),
                          Text("ประเภท : " + amuletCard.amulet.category, style: MyConfig.smallTextBlack),
                          Text("วันที่รับรอง : " + MyConfig.dateText(amuletCard.certificate.confirmDate), style: MyConfig.smallTextBlack),
                          Text("รับรองโดย : " + amuletCard.certificate.confirmBy, style: MyConfig.smallTextBlack),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDetailPage(amuletCard.amulet, amuletCard.certificate))),
          ),
        ),
      );
    }

    Widget amuletCardListBuilder() {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestoreInstance.collection("certificates").where("userId", isEqualTo: loginUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.size != 0) {
            amuletCardList = new List<AmuletCard>();
            snapshot.data.docs.forEach((element) => amuletCardList.add(new AmuletCard.fromDocumentSnapshot(element)));
          }
          return (!snapshot.hasData)
              ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(MyConfig.themeColor1)))
              : (snapshot.data.size == 0) ? emptyAmuletList
              : StreamBuilder<String>(
              stream: stream,
              initialData: searchController.text,
              builder: (context, searchText) {
                if (amuletCardList.isNotEmpty) filter(searchText);
                List<AmuletCard> showingList = amuletCardList.where((element) => element.isShowing == true).toList();
                return (showingList.length == 0) ? emptySearchAmuletList
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    childAspectRatio: gridRatio,
                  ),
                  itemCount: showingList.length,
                  itemBuilder: (context, index) => buildAmuletCard(showingList[index]),
                );
              });
        },
      );
    }

    return Scaffold(
      backgroundColor: MyConfig.themeColor2,
      appBar: mySearchBar,
      body: (loginUser != null) ? amuletCardListBuilder() : SizedBox(),
    );
  }
}
