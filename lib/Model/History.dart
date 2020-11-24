import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String docId;
  int type;
  String certificateId;
  String receiverId;
  String receiverName = "";
  String senderId;
  String senderName = "";
  DateTime timestamp;

  History.fromDocumentSnapshot(DocumentSnapshot doc){
    docId = (doc.id != null) ? doc.id : "";
    this. certificateId = (doc.data()['certificateId'] != null) ? doc.data()['certificateId'] : "";
    this.receiverId = (doc.data()['receiverId'] != null) ? doc.data()['receiverId'] : "";
    this.senderId = (doc.data()['senderId'] != null) ? doc.data()['senderId'] : "";
    this.timestamp = (doc.data()['date'] != null) ? doc.data()['date'].toDate() : null;
    this.type = (doc.data()['userId'] != null && doc.data()['userId'] == this.senderId) ? 1 : 2;
  }

  void setReceiverName(String receiverName) => this.receiverName = receiverName;
  void setSenderName(String senderName) => this.senderName = senderName;
}