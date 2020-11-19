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
      (snapshot.data()['name'] != null) ? snapshot.data()['name'] : "",
      (snapshot.data()['category'] != null) ? snapshot.data()['category'] : "",
      (snapshot.data()['texture'] != null) ? snapshot.data()['texture'] : "",
      (snapshot.data()['info'] != null) ? snapshot.data()['info'] : "",
      (snapshot.data()['amuletImages'] != null) ? snapshot.data()['amuletImages'].toList().cast<String>() : [],
    );
    this.certificate = new Certificate(
      (snapshot.data()['id'] != null) ? snapshot.data()['id'] : "",
      (snapshot.data()['certificateImage'] != null) ? snapshot.data()['certificateImage'] : "",
      (snapshot.data()['confirmBy'] != null) ? snapshot.data()['confirmBy'] : "",
      (snapshot.data()['confirmDate'] != null) ? snapshot.data()['confirmDate'].toDate() : null,
    );
  }
}