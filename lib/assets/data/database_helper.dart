import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  final dbName = "innario.db";
  final dbVersion = 1;

  // Make this a singleton class
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // Search database
    Directory dbDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDir.path, dbName);

    // Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load("lib/assets/data/$dbName");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // Save copied asset to documents
    var db = await openDatabase(dbPath, version: dbVersion);
    return db;
  }
}
