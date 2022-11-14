import 'package:crud_operations/repository/Repository.dart';
import 'package:flutter/cupertino.dart';

import '../domain/Dog.dart';

class DogService extends ChangeNotifier{
  late final Repository dogsRepository;

  DogService() {
    dogsRepository = Repository();
    populateList();
  }

  void populateList() {
    List<Dog> dogs = [
      Dog("Max", "Pitt-Bull type", 2019, "2022-10-16", "vaccines up to date", 2),
      Dog("Bella", "Bichon type", 0, "2022-10-21", "", 1),
      Dog("Frodo", "Shepherd type", 2021, "2002-10-7", "vaccines up to date; sensitive stomach", 2)
    ];

    for (int i = 0; i < dogs.length; i ++) {
      dogsRepository.addDog(dogs[i]);
    }
    notifyListeners();
  }

   List<Dog> getAllDogs() {
    return dogsRepository.dogs;

  }

  void addDog(String name, String breed, int yearOfBirth, String arrivalDate, String medicalDetails, int crateNumber) {
    Dog newDog = Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);
    dogsRepository.addDog(newDog);
    notifyListeners();
  }

  void removeDog(int id) {
    dogsRepository.removeDog(id);
    notifyListeners();
  }

  void updateDog(int id, String name, String breed, int yearOfBirth, String arrivalDate, String medicalDetails, int crateNumber) {
    Dog dog = Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);
    dogsRepository.updateDog(id, dog);
    notifyListeners();
  }
}
