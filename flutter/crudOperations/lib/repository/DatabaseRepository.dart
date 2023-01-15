import 'package:crud_operations/domain/Dog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Repository.dart';

class DatabaseRepository implements Repository {
  final Database _database;
  static const String tableName = "Dogs";

  static const String idColumn = "_id";
  static const String nameColumn = "name";
  static const String breedColumn = "breed";
  static const String yearOfBirthColumn = "yearOfBirth";
  static const String arrivalDateColumn = "arrivalDate";
  static const String medicalDetailsColumn = "medicalDetails";
  static const String crateNoColumn = "crateNo";

  DatabaseRepository(this._database);

  static Future<DatabaseRepository> initDB() async {
    // Get a location using getDatabasesPath
    final dbPath = await getDatabasesPath();
    var path = join(dbPath, "dog_shelter.db");

    // Delete the database
    // await deleteDatabase(path);

    var database = await openDatabase(path, version: 1, onCreate: createDB);

    return DatabaseRepository(database);
  }

  static Future createDB(Database database, int version) async {
    // When creating the db, create the table
    await database.execute('''
    CREATE TABLE  $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT,
              $breedColumn TEXT, $yearOfBirthColumn INTEGER, $arrivalDateColumn TEXT, 
              $medicalDetailsColumn TEXT, $crateNoColumn INTEGER)
    ''');
  }

  Future close() async {
    _database.close();
  }

  @override
  Future<void> addDog(Dog newDog) async {
    Map<String, Object?> values = {
      nameColumn: newDog.name,
      breedColumn: newDog.breed,
      yearOfBirthColumn: newDog.yearOfBirth,
      arrivalDateColumn: newDog.arrivalDate,
      medicalDetailsColumn: newDog.medicalDetails,
      crateNoColumn: newDog.crateNumber
    };
    // Insert some records
    await _database.insert(tableName, values);
  }

  @override
  Future<List<Dog>> getAllDogs() async {
    // Get the records
    final dogsFromDB = await _database.query(tableName);
    List<Dog> allDogs = [];

    for (var dogFromDB in dogsFromDB) {
      Dog dog = Dog(
          dogFromDB[nameColumn] as String,
          dogFromDB[breedColumn] as String,
          dogFromDB[yearOfBirthColumn] as int,
          dogFromDB[arrivalDateColumn] as String,
          dogFromDB[medicalDetailsColumn] as String,
          dogFromDB[crateNoColumn] as int);

      dog.id = dogFromDB[idColumn] as int;
      allDogs.add(dog);
    }
    return allDogs;
  }

  @override
  Future<void> removeDog(int id) async {
    // Delete a record
    await _database.delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
  }

  @override
  Future<Dog> returnDogById(int id) async {
    final maps = _database.query(tableName,
        columns: [
          nameColumn,
          breedColumn,
          yearOfBirthColumn,
          arrivalDateColumn,
          medicalDetailsColumn,
          crateNoColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    // Dog dog = Dog(maps![0][nameColumn] as String,
    //     dogFromDB[breedColumn] as String,
    //     dogFromDB[yearOfBirthColumn] as int,
    //     dogFromDB[arrivalDateColumn] as String,
    //     dogFromDB[medicalDetailsColumn] as String,
    //     dogFromDB[crateNoColumn] as int);

    return Dog("name", "breed", 0, "arrivalDate", "medicalDetails", 0);
  }

  @override
  Future<void> updateDog(int id, Dog newDog) async {
    Map<String, Object?> values = {
      nameColumn: newDog.name,
      breedColumn: newDog.breed,
      yearOfBirthColumn: newDog.yearOfBirth,
      arrivalDateColumn: newDog.arrivalDate,
      medicalDetailsColumn: newDog.medicalDetails,
      crateNoColumn: newDog.crateNumber
    };

    await _database
        .update(tableName, values, where: "$idColumn = ?", whereArgs: [id]);
  }
}
