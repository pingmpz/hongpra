import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  int type;
  String certificateId;
  String receiverId;
  String receiverName = "";
  String senderId;
  String senderName = "";
  DateTime timestamp;

  History(this.type, this.certificateId, this.receiverId, this.receiverName, this.senderId, this.senderName, this.timestamp);

  History.fromDocumentSnapshot(DocumentSnapshot snapshot, String userId){
    this. certificateId = (snapshot.data()['certificateId'] != null) ? snapshot.data()['certificateId'] : "";
    this.receiverId = (snapshot.data()['receiverId'] != null) ? snapshot.data()['receiverId'] : "";
    this.senderId = (snapshot.data()['senderId'] != null) ? snapshot.data()['senderId'] : "";
    this.timestamp = (snapshot.data()['date'] != null) ? snapshot.data()['date'].toDate() : null;
    this.type = (this.senderId == userId) ? 1 : 2;
  }

  History.fromDocumentSnapshotWithName(DocumentSnapshot snapshot, this.receiverName, this.senderName){
    this.type = (snapshot.data()['type'] != null) ? snapshot.data()['type'] : -1;
    this. certificateId = (snapshot.data()['certificateId'] != null) ? snapshot.data()['certificateId'] : "";
    this.receiverId = (snapshot.data()['receiverId'] != null) ? snapshot.data()['receiverId'] : "";
    this.senderId = (snapshot.data()['senderId'] != null) ? snapshot.data()['senderId'] : "";
    this.timestamp = (snapshot.data()['date'] != null) ? snapshot.data()['date'].toDate() : null;
  }

  void setReceiverName(String receiverName) => this.receiverName = receiverName;
  void setSenderName(String senderName) => this.senderName = senderName;
}