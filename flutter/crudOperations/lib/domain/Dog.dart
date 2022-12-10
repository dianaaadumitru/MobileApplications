class Dog {
  int currentId = 1;

  late int id;
  String name;
  String breed;
  int yearOfBirth;
  String arrivalDate;
  String medicalDetails;
  int crateNumber;

  Dog(this.name, this.breed, this.yearOfBirth,
      this.arrivalDate, this.medicalDetails, this.crateNumber) {
    id = currentId++;
  }

}