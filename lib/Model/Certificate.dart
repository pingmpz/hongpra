import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  String docId;
  String name;
  String category;
  String info;
  List<String> amuletImages;
  String id;
  String certificateImage;
  String confirmBy;
  DateTime confirmDate;
  bool isShowing = true;

  Certificate.fromDocumentSnapshot(DocumentSnapshot doc){
    docId = (doc.id != null) ? doc.id : "";
    name = (doc.data()['name'] != null) ? doc.data()['name'] : "";
    category = (doc.data()['category'] != null) ? doc.data()['category'] : "";
    info = (doc.data()['info'] != null) ? doc.data()['info'] : "";
    amuletImages = (doc.data()['amuletImages'] != null) ? doc.data()['amuletImages'].toList().cast<String>() : [];
    id = (doc.data()['id'] != null) ? doc.data()['id'] : "";
    certificateImage = (doc.data()['certificateImage'] != null) ? doc.data()['certificateImage'] : "";
    confirmBy = (doc.data()['confirmBy'] != null) ? doc.data()['confirmBy'] : "";
    confirmDate = (doc.data()['confirmDate'] != null) ? doc.data()['confirmDate'].toDate() : null;
  }
}