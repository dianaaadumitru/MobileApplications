import 'package:crud_operations/domain/Dog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Repository.dart';

class DatabaseRepository implements Repository {

  static Database? _database;
  static const String tableName = "Dogs";

  static const String idColumn = "_id";
  static const String nameColumn = "name";
  static const String breedColumn = "breed";
  static const String yearOfBirthColumn = "yearOfBirth";
  static const String arrivalDateColumn = "arrivalDate";
  static const String medicalDetailsColumn = "medicalDetails";
  static const String crateNoColumn = "crateNo";



  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB("dog_shelter.db");
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    var path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database database, int version) async {
    await database.execute('''
    CREATE TABLE  $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, '
              '$breedColumn TEXT, $yearOfBirthColumn INTEGER, $arrivalDateColumn TEXT, 
              $medicalDetailsColumn TEXT, $crateNoColumn INTEGER)
    ''');
  }

  Future close() async {
    // final db = await instance.database;
    _database?.close();
  }


  @override
  void addDog(Dog newDog) async{
    Map<String, Object?> values = {
      nameColumn: newDog.name,
      breedColumn: newDog.breed,
      yearOfBirthColumn: newDog.yearOfBirth,
      arrivalDateColumn: newDog.arrivalDate,
      medicalDetailsColumn: newDog.medicalDetails,
      crateNoColumn: newDog.crateNumber
    };
    await _database?.insert(tableName, values);
  }

  @override
  List<Dog> getAllDogs() {
    // TODO: implement getAllDogs
    throw UnimplementedError();
  }

  @override
  void removeDog(int id) {
    // TODO: implement removeDog
  }

  @override
  Dog returnDogById(int id) {
    // TODO: implement returnDogById
    throw UnimplementedError();
  }

  @override
  void updateDog(int id, Dog dog) {
    // TODO: implement updateDog
  }

}