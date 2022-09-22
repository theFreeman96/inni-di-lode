import 'database_helper.dart';
import 'models.dart';

class QueryCtr {
  DatabaseHelper con = DatabaseHelper.privateConstructor();

  Future<List<Raccolta>?> getAllSongs() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFromRange(firstId, secondId) async {
    final dbClient = await con.db;
    final res = await dbClient!.rawQuery(
        'SELECT * FROM View_Raccolta WHERE songId BETWEEN "$firstId" and "$secondId" GROUP BY songId');

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

  Future<List<Raccolta>?> getAllFav() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'isFav = ?', whereArgs: [1], groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

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
