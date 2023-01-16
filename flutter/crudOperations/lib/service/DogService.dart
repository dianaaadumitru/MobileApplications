import 'package:crud_operations/repository/ServerRepository.dart';
import 'package:flutter/cupertino.dart';

import '../domain/Dog.dart';

class DogService extends ChangeNotifier {
  // final Repository dogsRepository;
  final ServerRepository dogsRepository;

  DogService(this.dogsRepository);

  static Future<DogService> init() async {
    // var repository = await DatabaseRepository.initDB();
    var repository = await ServerRepository.initDB();
    // await repository.getAllDogs();
    return DogService(repository);
  }

  void populateList() {
    List<Dog> dogs = [
      Dog("Max", "Pitt-Bull type", 2019, "2022-10-16", "vaccines up to date",
          2),
      Dog("Bella", "Bichon type", 0, "2022-10-21", "", 1),
      Dog("Frodo", "Shepherd type", 2021, "2002-10-7",
          "vaccines up to date; sensitive stomach", 2),
      Dog("Milo", "Shepherd type", 2021, "2002-10-7", "healthy", 2)
    ];

    for (int i = 0; i < dogs.length; i++) {
      dogsRepository.addDog(dogs[i]);
    }
    notifyListeners();
  }

  Future<List<Dog>> getAllDogs() async => await dogsRepository.getAllDogs();

  void addDog(String name, String breed, int yearOfBirth, String arrivalDate,
      String medicalDetails, int crateNumber) {
    Dog newDog =
        Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);
    dogsRepository.addDog(newDog);
    notifyListeners();
  }

  Future<String> removeDog(int id) {
    var result = dogsRepository.removeDog(id);
    notifyListeners();
    return result;
  }

  Future<String> updateDog(int id, String name, String breed, int yearOfBirth,
      String arrivalDate, String medicalDetails, int crateNumber) {
    Dog dog =
        Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);
    var result = dogsRepository.updateDog(id, dog);
    notifyListeners();
    return result;
  }
}
