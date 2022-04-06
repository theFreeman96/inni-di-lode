import 'database_helper.dart';
import 'models.dart';

class QueryCtr {
  DatabaseHelper con = DatabaseHelper();

  Future<List<Raccolta>?> getAllSongs() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom1To100() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 1 and 100 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom101To200() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 101 and 200 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom201To300() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 201 and 300 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom301To400() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 301 and 400 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom401To500() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 401 and 500 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom501To600() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 501 and 600 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFrom601To700() async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN 601 and 700 GROUP BY songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getAllMacroCat() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'macroId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getAllCat() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'catId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getCatByMacro(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'macroId = ?', whereArgs: [id], groupBy: 'catId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsByCat(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'catId = ?', whereArgs: [id], groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Autori>?> getAllAut() async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('view_autori', orderBy: 'autName', groupBy: 'autId');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Autori>?> getSongsByAut(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_autori',
        where: 'autId = ?', whereArgs: [id], groupBy: 'songId');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchSong(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId LIKE "%$keyword%" OR  songTitle LIKE "%$keyword%" OR songText LIKE "%$keyword%" group by songId order by songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchMacroCat(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE macroName LIKE "%$keyword%" OR catName LIKE "%$keyword%" group by macroId order by macroName');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Autori>?> searchAut(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Autori WHERE autName LIKE "%$keyword%" group by autId order by autName');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }
}
