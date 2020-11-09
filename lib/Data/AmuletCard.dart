import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Amulet.dart';
import 'Certificate.dart';

class AmuletCard {
  Amulet amulet;
  Certificate certificate;
  bool isShowing = true;

  AmuletCard(this.amulet, this.certificate);

  AmuletCard.fromDocumentSnapshot(DocumentSnapshot snapshot){
    this.amulet = new Amulet(
      (snapshot.data()['amuletId'] != null) ? snapshot.data()['amuletId'] : "",
      (snapshot.data()['amuletImageList'] != null) ? HashMap<String, dynamic>.from(snapshot.data()['amuletImageList']).values.toList().cast<String>() : [],
      (snapshot.data()['name'] != null) ? snapshot.data()['name'] : "",
      (snapshot.data()['categories'] != null) ? snapshot.data()['categories'] : "",
      (snapshot.data()['texture'] != null) ? snapshot.data()['texture'] : "",
      (snapshot.data()['information'] != null) ? snapshot.data()['information'] : "",
    );
    this.certificate = new Certificate(
      (snapshot.data()['certificateId'] != null) ? snapshot.data()['certificateId'] : "",
      (snapshot.data()['certificateImage'] != null) ? snapshot.data()['certificateImage'] : "",
      (snapshot.data()['confirmBy'] != null) ? snapshot.data()['confirmBy'] : "",
      (snapshot.data()['confirmDate'] != null) ? snapshot.data()['confirmDate'].toDate() : null,
    );
  }
}