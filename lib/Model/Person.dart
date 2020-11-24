import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String docId;
  String firstName;
  String lastName;
  String uniqueId;

  Person.fromDocumentSnapshot(DocumentSnapshot doc){
    this.docId = (doc.id != null) ? doc.id : "";
    this.firstName = (doc.data()['firstName'] != null) ? doc.data()['firstName'] : "";
    this.lastName = (doc.data()['lastName'] != null) ? doc.data()['lastName'] : "";
    this.uniqueId = (doc.data()['uniqueId'] != null) ? doc.data()['uniqueId'] : "";
  }

  Person.fromEmpty(){
    this.docId = "";
    this.firstName = "";
    this.lastName = "";
    this.uniqueId = "";
  }

  String getFullName() {
    return firstName + " " + lastName;
  }
}