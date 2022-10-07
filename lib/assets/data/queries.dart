import 'database_helper.dart';
import 'models.dart';

class QueryCtr {
  DatabaseHelper con = DatabaseHelper.privateConstructor();

  // Song list queries
  Future<List<Raccolta>?> getAllSongs() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFromRange(firstId, secondId) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'songId BETWEEN ? AND ?',
        whereArgs: ['$firstId', '$secondId'],
        groupBy: 'songId',
        orderBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchSong(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'songId LIKE ? OR songTitle LIKE ? OR songText LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
        groupBy: 'songId',
        orderBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  // Category related queries
  Future<List<Raccolta>?> getAllMacroCat() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta', groupBy: 'macroId');

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

  Future<List<Raccolta>?> searchCat(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'macroName LIKE ? OR catName LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        groupBy: 'macroId',
        orderBy: 'macroName');

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

  // Author related queries
  Future<List<Autori>?> getAllAut() async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('view_autori', orderBy: 'autName', groupBy: 'autId');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Autori>?> searchAut(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_autori',
        where: 'autName LIKE ?',
        whereArgs: ['%$keyword%'],
        groupBy: 'autId',
        orderBy: 'autName');

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

  // Favorite related queries
  Future<List<Raccolta>?> updateFav(value, id) async {
    final dbClient = await con.db;
    await dbClient!.update(
      'Songs',
      {'fav': value},
      where: 'id = ?',
      whereArgs: [id],
    );
    return null;
  }

  Future<List<Raccolta>?> getAllFav() async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where: 'isFav = ?', whereArgs: [1], groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchFav(int value, String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('view_raccolta',
        where:
            'isFav = ? AND (songId LIKE ? OR songTitle LIKE ? OR songText LIKE ?)',
        whereArgs: ['$value', '%$keyword%', '%$keyword%', '%$keyword%'],
        groupBy: 'songId',
        orderBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  // New Songs
  Future<List<NewSongs>?> insertSong(title, text) async {
    final dbClient = await con.db;
    await dbClient!.rawInsert(
        'INSERT INTO Songs(id, title, text, cat_id, fav) VALUES("701", $title, $text, "1", "1")');
    return null;
  }

  Future<List<NewSongs>?> updateSong(title, text, id) async {
    final dbClient = await con.db;
    await dbClient!.update(
      'Songs',
      {'title': title, 'text': text},
      where: 'id = ?',
      whereArgs: [id],
    );
    return null;
  }

  Future<List<NewSongs>?> deleteSong(id) async {
    final dbClient = await con.db;
    await dbClient!.delete('Songs', where: 'songId = ?', whereArgs: [id]);
    return null;
  }
}
