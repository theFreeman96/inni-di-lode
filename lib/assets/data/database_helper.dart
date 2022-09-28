import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  final dbName = "innario.db";
  final dbVersion = 1;

  // Make this a singleton class
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      await Lock().synchronized(() async {
        _db ??= await initDb();
      });
      return _db;
    }
  }

  initDb() async {
    // Search database
    Directory dbDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDir.path, dbName);

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load("lib/assets/data/$dbName");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await File(dbPath).writeAsBytes(bytes);
    }
    // Access database
    var db = await openDatabase(dbPath, version: dbVersion);
    return db;
  }
}
