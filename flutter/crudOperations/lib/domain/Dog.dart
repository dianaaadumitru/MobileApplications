class Dog {
  int currentId = 1;

  late int id;
  String name;
  String breed;
  int yearOfBirth;
  String arrivalDate;
  String medicalDetails;
  int crateNumber;

  Dog(this.name, this.breed, this.yearOfBirth, this.arrivalDate,
      this.medicalDetails, this.crateNumber) {
    id = -1;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'yearOfBirth': yearOfBirth,
      'arrivalDate': arrivalDate,
      'medicalDetails': medicalDetails,
      'crateNumber': crateNumber
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'yearOfBirth': yearOfBirth,
      'arrivalDate': arrivalDate,
      'medicalDetails': medicalDetails,
      'crateNumber': crateNumber
    };
  }

  factory Dog.fromJson(dynamic json) {
    var dog = Dog(json['name'], json['breed'], json['yearOfBirth'], json['arrivalDate'], json['medicalDetails'], json['crateNumber']);

    dog.id = json['id'];

    return dog;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'yearOfBirth': yearOfBirth,
      'arrivalDate': arrivalDate,
      'medicalDetails': medicalDetails,
      'crateNumber': crateNumber
    };
  }
}
