import 'dart:io';
import 'package:passengerapp/models/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

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

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE LocationHistory (
                placeId TEXT PRIMARY KEY,
                mainText TEXT NOT NULL,
                secondaryText TEXT
              )
              ''');
  }

  Future<int> insert(LocationPrediction location) async {
    Database db = await database;
    int id = await db.insert("LocationHistory", location.toMap());
    return id;
  }

  Future<List<LocationPrediction>> queryLocation() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      "LocationHistory",
      columns: ["placeId", "mainText", "secondaryText"],
    );
    if (maps.length > 0) {
      return maps.map((e) => LocationPrediction.fromMap(e)).toList();
      // LocationPrediction.fromMap(maps.first);
    } else {
      throw "";
    }
  }
}
