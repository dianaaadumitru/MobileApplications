import '../domain/Dog.dart';

class Repository {
  late final List<Dog> dogs;

  Repository() {
    dogs = [];
  }


  void addDog(Dog newDog) {
    dogs.add(newDog);
  }

  void removeDog(int id) {
    Dog dog = dogs.where((element) => element.id == id) as Dog;
    dogs.remove(dog);
  }
  
  void updateDog(int id, Dog dog) {
    dogs[dogs.indexWhere((element) => element.id == id)] = dog;
    dog.id = id;
  }
}