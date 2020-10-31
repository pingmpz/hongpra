class History {
  int type;
  String certificateId;
  String receiverId;
  String receiverName;
  String senderId;
  String senderName;
  DateTime timestamp;

  History(this.type, this.certificateId, this.receiverId, this.receiverName, this.senderId, this.senderName, this.timestamp);
}