import '../domain/Dog.dart';

abstract class Repository {
  void addDog(Dog newDog);

  void removeDog(int id);

  void updateDog(int id, Dog dog);

  Dog returnDogById(int id);

  List<Dog> getAllDogs();
}
