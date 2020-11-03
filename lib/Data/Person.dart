class Person {
  String id;
  String firstName;
  String lastName;
  String uniqueId;

  Person(this.id, this.firstName, this.lastName, this.uniqueId);

  String getFullName(){
    return firstName + " " + lastName;
  }
}