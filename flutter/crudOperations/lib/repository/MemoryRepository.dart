import 'package:crud_operations/repository/Repository.dart';

import '../domain/Dog.dart';

class MemoryRepository implements Repository{
  late final List<Dog> dogs = [];

  @override
  void addDog(Dog newDog) {
    dogs.add(newDog);
  }

  @override
  void removeDog(int id) {
    Dog dog = dogs.where((element) => element.id == id).first;
    dogs.remove(dog);
  }

  @override
  void updateDog(int id, Dog dog) {
    dogs[dogs.indexWhere((element) => element.id == id)] = dog;
    dog.id = id;
  }

  @override
  Dog returnDogById(int id) {
    Dog dog = Dog("", "", 0, "", "", 0);
    for (var element in dogs) {
      if (element.id == id) {
        return element;
      }
    }
    return dog;
  }

  @override
  List<Dog> getAllDogs() {
    return dogs;
  }
}
