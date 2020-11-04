import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String id;
  String firstName;
  String lastName;
  String uniqueId;

  Person(this.id, this.firstName, this.lastName, this.uniqueId);

  Person.fromDocumentSnapshot(DocumentSnapshot snapshot){
    this.id = (snapshot.data()['userId'] != null) ? snapshot.data()['userId'] : "";
    this.firstName = (snapshot.data()['firstName'] != null) ? snapshot.data()['firstName'] : "";
    this.lastName = (snapshot.data()['lastName'] != null) ? snapshot.data()['lastName'] : "";
    this.uniqueId = (snapshot.data()['uniqueId'] != null) ? snapshot.data()['uniqueId'] : "";
  }

  Person.fromEmpty(){
    this.id = "";
    this.firstName = "";
    this.lastName = "";
    this.uniqueId = "";
  }

  String getFullName() {
    return firstName + " " + lastName;
  }
}