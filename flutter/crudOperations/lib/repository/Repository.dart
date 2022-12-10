import '../domain/Dog.dart';

abstract class Repository {
  Future<void> addDog(Dog newDog);

  Future<void> removeDog(int id);

  Future<void> updateDog(int id, Dog dog);

  Future<Dog> returnDogById(int id);

  Future<List<Dog>> getAllDogs();
}
