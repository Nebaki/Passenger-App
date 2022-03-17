import 'dart:convert';
import 'dart:io';
import 'package:passengerapp/models/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<List<Trip>> loadSavedLocations() async {
    Database db = await database;
    List<Map<String, Object?>> result;
    result = await db.query("SavedLocation");
    return result.map((e) =>  Trip.fromMap(e)).toList();
  }

  Future<int> insertLocation(Trip trip) async {
    var data = trip.toMap();
    Database db = await database;
    int id = await db.insert("SavedLocation", data);
    return id;
  }

  Future _createSavedLocations(Database db, int version) async{
    await db.execute('''
              CREATE TABLE SavedLocation (
                locationId INTEGER PRIMARY KEY AUTOINCREMENT ,
                mainText TEXT NOT NULL
              )
              ''');
  }

  Future _createTripHistory(Database db, int version) async{
    await db.execute('''
              CREATE TABLE TripHistory (
                placeId TEXT PRIMARY KEY,
                mainText TEXT NOT NULL,
                secondaryText TEXT
              )
              ''');
  }
  Future _createLocalHistory(Database db, int version) async{
    await db.execute('''
              CREATE TABLE LocationHistory (
                placeId TEXT PRIMARY KEY,
                mainText TEXT NOT NULL,
                secondaryText TEXT
              )
              ''');
  }

  Future _onCreate(Database db, int version) async {
    _createSavedLocations(db, version);
    _createTripHistory(db, version);
    _createLocalHistory(db, version);

  }

  Future<int> insert(LocationPrediction location) async {
    Database db = await database;
    int id = await db.insert("LocationHistory", location.toMap());
    return id;
  }

  Future<List<LocationPrediction>> queryLocation() async {
    print("yow yow yow");
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query("LocationHistory",
        columns: ["placeId", "mainText", "secondaryText"]);
    if (maps.length > 0) {
      return maps.reversed.map((e) => LocationPrediction.fromMap(e)).toList();
      // LocationPrediction.fromMap(maps.first);
    } else {
      throw "";
    }
  }

}
