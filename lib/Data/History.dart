class History {
  int type;
  String certificateId;
  String receiverId;
  String receiverName = "";
  String senderId;
  String senderName = "";
  DateTime timestamp;

  History(this.type, this.certificateId, this.receiverId, this.receiverName, this.senderId, this.senderName, this.timestamp);

  void setReceiverName(String receiverName) => this.receiverName = receiverName;
  void setSenderName(String senderName) => this.senderName = senderName;
}