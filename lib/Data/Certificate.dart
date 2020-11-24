import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  String docId;
  String name;
  String category;
  String texture;
  String info;
  List<String> amuletImages;
  String id;
  String certificateImage;
  String confirmBy;
  DateTime confirmDate;
  bool isShowing = true;

  Certificate.fromDocumentSnapshot(DocumentSnapshot snapshot){
    docId = (snapshot.id != null) ? snapshot.id : "";
    name = (snapshot.data()['name'] != null) ? snapshot.data()['name'] : "";
    category = (snapshot.data()['category'] != null) ? snapshot.data()['category'] : "";
    texture = (snapshot.data()['texture'] != null) ? snapshot.data()['texture'] : "";
    info = (snapshot.data()['info'] != null) ? snapshot.data()['info'] : "";
    amuletImages = (snapshot.data()['amuletImages'] != null) ? snapshot.data()['amuletImages'].toList().cast<String>() : [];
    id = (snapshot.data()['id'] != null) ? snapshot.data()['id'] : "";
    certificateImage = (snapshot.data()['certificateImage'] != null) ? snapshot.data()['certificateImage'] : "";
    confirmBy = (snapshot.data()['confirmBy'] != null) ? snapshot.data()['confirmBy'] : "";
    confirmDate = (snapshot.data()['confirmDate'] != null) ? snapshot.data()['confirmDate'].toDate() : null;
  }
}