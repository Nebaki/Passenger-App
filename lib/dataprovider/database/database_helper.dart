import 'dart:io';
import 'package:passengerapp/models/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyNewDatabase.db";
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
    await db.execute('''
              CREATE TABLE SavedLocations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                placeId TEXT UNIQUE,
                name TEXT NOT NULL,
                address TEXT NOT NULL
              )
              ''');
  }

  Future<List<LocationPrediction>> insert(LocationPrediction location) async {
    Database db = await database;
    try {
      final res = await db
          .insert("LocationHistory", location.toMap())
          .catchError((err) {
        db.delete("LocationHistory",
            where: 'placeId = ?', whereArgs: [location.placeId]);
        db.insert("LocationHistory", location.toMap());
      });
      return queryLocation();
    } catch (_) {
      return queryLocation();
    }
  }

  Future<List<LocationPrediction>> queryLocation() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query("LocationHistory",
        columns: ["placeId", "mainText", "secondaryText"]);
    if (maps.isNotEmpty) {
      return maps.reversed.map((e) => LocationPrediction.fromMap(e)).toList();
      // LocationPrediction.fromMap(maps.first);
    } else {
      throw "";
    }
  }

  Future clearLocations() async {
    Database db = await database;
    await db.delete("LocationHistory");
  }

  Future<List<SavedLocation?>> insertFavoriteLocation(
      SavedLocation location) async {
    Database db = await database;
    try {
      final res =
          await db.insert("SavedLocations", location.toMap()).catchError((err) {
        db.delete("SavedLocations",
            where: 'placeId = ?', whereArgs: [location.placeId]);
        db.insert("SavedLocations", location.toMap());
      });
      return queryFavoriteLocation();
    } catch (_) {
      return queryFavoriteLocation();
    }
  }

  Future<List<SavedLocation?>> queryFavoriteLocation() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db
        .query("SavedLocations", columns: ["id", "placeId", "name", "address"]);
    if (maps.isNotEmpty) {
      return maps.reversed.map((e) => SavedLocation.fromJson(e)).toList();
      // LocationPrediction.fromMap(maps.first);
    } else {
      return [];
    }
  }

  Future clearFavoriteLocations() async {
    Database db = await database;
    await db.delete("SavedLocations");
  }

  Future deleteFavoriteLocation(int id) async {
    Database db = await database;
    await db.delete("SavedLocations", where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SavedLocation?>> deleteFavoriteLocationByPLaceId(
      String placeId) async {
    Database db = await database;
    await db
        .delete("SavedLocations", where: 'placeId = ?', whereArgs: [placeId]);

    return queryFavoriteLocation();
  }

  Future updateFavoriteLocation(SavedLocation location) async {
    Database db = await database;
    await db.update("SavedLocations", location.toMap(),
        where: 'id = ?', whereArgs: [location.id]);
  }
}
