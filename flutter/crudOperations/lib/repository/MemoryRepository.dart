import 'package:crud_operations/repository/Repository.dart';

import '../domain/Dog.dart';

class MemoryRepository implements Repository {
  late final List<Dog> dogs = [];

  @override
  Future<void> addDog(Dog newDog) async {
    dogs.add(newDog);
  }

  @override
  Future<void> removeDog(int id) async {
    Dog dog = dogs.where((element) => element.id == id).first;
    dogs.remove(dog);
  }

  @override
  Future<void> updateDog(int id, Dog dog) async {
    dogs[dogs.indexWhere((element) => element.id == id)] = dog;
    dog.id = id;
  }

  @override
  Future<Dog> returnDogById(int id) async {
    Dog dog = Dog("", "", 0, "", "", 0);
    for (var element in dogs) {
      if (element.id == id) {
        return element;
      }
    }
    return dog;
  }

  @override
  Future<List<Dog>> getAllDogs() async {
    return dogs;
  }
}
