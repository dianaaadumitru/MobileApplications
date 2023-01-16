import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:crud_operations/domain/Dog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ServerRepository {
  final Database _database;
  static const String tableName = "Dogs";

  List<Dog> dogs;
  late List<Dog> dogsLocal;
  bool _isOnline;

  static const String ipAddress = '192.168.1.4';

  static const String idColumn = "id";
  static const String nameColumn = "name";
  static const String breedColumn = "breed";
  static const String yearOfBirthColumn = "yearOfBirth";
  static const String arrivalDateColumn = "arrivalDate";
  static const String medicalDetailsColumn = "medicalDetails";
  static const String crateNoColumn = "crateNumber";

  ServerRepository(this._database, this.dogs, this._isOnline) {
    dogsLocal = [];
    syncDatabases();
  }

  static Future<ServerRepository> initDB() async {
    // Get a location using getDatabasesPath
    final dbPath = await getDatabasesPath();
    var path = join(dbPath, "dog_shelter.db");

    // Delete the database
    // await deleteDatabase(path);

    var database = await openDatabase(path, version: 1, onCreate: createDB);

    return ServerRepository(database, [], false);
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

  Future<void> addDog(Dog newDog) async {
    await checkOnline();
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .post(Uri.parse("http://$ipAddress:8080/dogs"),
          headers: headers,
          body: jsonEncode({
            'id': newDog.id,
            'name': newDog.name,
            'breed': newDog.breed,
            'yearOfBirth': newDog.yearOfBirth,
            'arrivalDate': newDog.arrivalDate,
            'medicalDetails': newDog.medicalDetails,
            'crateNumber': newDog.crateNumber
          }),
          encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Added dog ${newDog.name}');
      }
    } on TimeoutException {
      _isOnline = false;
      dogsLocal.add(newDog);
      return addDogLocally(newDog.name, newDog.breed, newDog.yearOfBirth, newDog.arrivalDate, newDog.medicalDetails, newDog.crateNumber);
    } on Error {
      _isOnline = false;
      dogsLocal.add(newDog);
      return addDogLocally(newDog.name, newDog.breed, newDog.yearOfBirth, newDog.arrivalDate, newDog.medicalDetails, newDog.crateNumber);
    }
  }

  Future<List<Dog>> getAllDogs() async {
    await checkOnline();
    log('log: is online? $_isOnline');

    if (! _isOnline) {
      return getAllDogsLocally();
    }

    try {
      var response = await http.get(Uri.parse("http://$ipAddress:8080/dogs"))
          .timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        var dogsJson = res as List;
        dogs = dogsJson.map((dogJson) => Dog.fromJson(dogJson)).toList();
        log("log: retrieved dogs from server: ${dogs.length}");

        return dogs;
      } else {
        return getAllDogsLocally();
      }
    } on TimeoutException {
      _isOnline = false;
      return getAllDogsLocally();
    } on Error {
      _isOnline = false;
      return getAllDogsLocally();
    }
  }

  Future<String> removeDog(int id) async {
    await checkOnline();
    try {
      var response = await http.delete(Uri.parse("http://$ipAddress:8080/dogs/$id"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Removed dog with id $id');
        return "SUCCESS";
      } else {
        return "ERROR";
      }
    } on TimeoutException {
      _isOnline = false;
      return "OFFLINE";
    } on Error {
      _isOnline = false;
      return "OFFLINE";
    }
  }

  Future<String> updateDog(int id, Dog dog) async {
    await checkOnline();
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .put(Uri.parse("http://$ipAddress:8080/dogs/$id"),
          headers: headers,
          body: jsonEncode({
            'id': id,
            'name': dog.name,
            'breed': dog.breed,
            'yearOfBirth': dog.yearOfBirth,
            'arrivalDate': dog.arrivalDate,
            'medicalDetails': dog.medicalDetails,
            'crateNumber': dog.crateNumber
          }),
          encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Updated dog ${dog.name}');
        return "SUCCESS";
      } else {
        return "ERROR";
      }
    } on TimeoutException {
      _isOnline = false;
      return "OFFLINE";
    } on Error {
      _isOnline = false;
      return "OFFLINE";
    }
  }

  Future<List<Dog>> getAllDogsLocally() async {
    // Get the records
    final dogsFromDB = await _database.query(tableName);
    // List<Dog> allDogs = [];
    dogs.clear();

    for (var dogFromDB in dogsFromDB) {
      Dog dog = Dog(
          dogFromDB[nameColumn] as String,
          dogFromDB[breedColumn] as String,
          dogFromDB[yearOfBirthColumn] as int,
          dogFromDB[arrivalDateColumn] as String,
          dogFromDB[medicalDetailsColumn] as String,
          dogFromDB[crateNoColumn] as int);

      dog.id = dogFromDB[idColumn] as int;
      dogs.add(dog);
    }
    log("log: retrieved dogs locally: ${dogs.length}");
    return dogs;
  }

  Future<void> addDogLocally(String name, String breed, int yearOfBirth, String arrivalDate, String medicalDetails, int crateNumber) async {
    Dog dog = Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);
    // Insert some records
    await _database.insert(tableName, dog.toMap());
    log('log: Added dog locally ${dog.name}');

  }

  Future<void> removeDogLocally(int id) async {
    // Delete a record
    await _database.delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
    log('log: Removed dog locally with id $id');
  }

  Future<void> updateDogLocally(int id, String name, String breed, int yearOfBirth, String arrivalDate, String medicalDetails, int crateNumber) async {
    Dog newDog = Dog(name, breed, yearOfBirth, arrivalDate, medicalDetails, crateNumber);

    await _database.update(tableName, newDog.toMap(), where: "$idColumn = ?", whereArgs: [id]);
    log('log: Updated dog locally ${newDog.name}');
  }

  Future<void> checkOnline() async {
    log("started...");
    try {
      var response = await http.get(Uri.parse("http://$ipAddress:8080/dogs/isOnline"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        if (_isOnline == false) {
          await syncDatabases();
          _isOnline = true;
        }
      }
    } on TimeoutException {
      _isOnline = false;
    } on Error {
      _isOnline = false;
    }
  }

  Future<void> syncDatabases() async {
    log("dogs added locally: ${dogsLocal.isNotEmpty}");
    if (dogsLocal.isNotEmpty) {
      log("here");
      for (var dog in dogsLocal) {
        addDog(dog);
      }
    }

    log("dogs:");
    log("dogs: $dogs");

    await _database.execute("DELETE FROM $tableName");

    for (var dog in dogs) {
      await _database.insert(tableName, dog.toMapWithId());
    }
  }
}