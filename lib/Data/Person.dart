class Person {
  String id;
  String firstName;
  String lastName;

  Person(this.id, this.firstName, this.lastName);

  String getFullName(){
    return firstName + " " + lastName;
  }
}