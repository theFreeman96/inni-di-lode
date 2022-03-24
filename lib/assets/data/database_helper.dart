import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  DatabaseHelper.internal();

  initDb() async {
    // Search database
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "innario.db");

    // Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load("lib/assets/data/innario.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // Save copied asset to documents
    var db = await openDatabase(dbPath);
    return db;
  }
}
