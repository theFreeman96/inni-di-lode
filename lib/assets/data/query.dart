import 'database_helper.dart';
import 'lists.dart';

class QueryCtr {
  DatabaseHelper con = DatabaseHelper();

  Future<List<Songs>?> getAllSongs() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('songs');

    List<Songs>? list =
        res.isNotEmpty ? res.map((c) => Songs.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Macrocategories>?> getAllMacroCat() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('macrocategories');

    List<Macrocategories>? list = res.isNotEmpty
        ? res.map((c) => Macrocategories.fromMap(c)).toList()
        : null;

    return list;
  }

  Future<List<Categories>?> getAllCat() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('categories');

    List<Categories>? list =
        res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Authors>?> getAllAut() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('authors');

    List<Authors>? list =
        res.isNotEmpty ? res.map((c) => Authors.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Categories>?> getCatByMacro(id) async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('categories', where: 'macro_id = ?', whereArgs: [id]);

    List<Categories>? list =
        res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : null;

    return list;
  }
}
