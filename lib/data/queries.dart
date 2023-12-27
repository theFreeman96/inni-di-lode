import 'database_helper.dart';
import 'models.dart';

class QueryCtr {
  DatabaseHelper con = DatabaseHelper.privateConstructor();

  // Song list queries
  Future<List<Raccolta>?> getAllSongs() async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('View_Raccolta', orderBy: 'songId', groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsFromRange(firstId, secondId) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
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
    final res = await dbClient!.query('View_Raccolta',
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
    final res = await dbClient!
        .query('View_Raccolta', orderBy: 'macroId', groupBy: 'macroId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Categorie>?> getCatByMacro(macroId) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('Categories',
        where: 'macro_id = ?',
        whereArgs: [macroId],
        orderBy: 'id',
        groupBy: 'id');

    List<Categorie>? list =
        res.isNotEmpty ? res.map((c) => Categorie.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Categorie>?> getAllCat() async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('Categories', orderBy: 'macro_id, id', groupBy: 'id');

    List<Categorie>? list =
        res.isNotEmpty ? res.map((c) => Categorie.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchCat(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query(
        'View_Raccolta INNER JOIN Categories ON View_Raccolta.macroId = Categories.macro_id',
        where: 'macroName LIKE ? OR catName LIKE ? OR name LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
        groupBy: 'macroId',
        orderBy: 'macroName');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsByCat(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
        where: 'catId = ?',
        whereArgs: [id],
        orderBy: 'songId',
        groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getCatBySongId(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
        where: 'songId = ?',
        whereArgs: [id],
        groupBy: 'catId',
        orderBy: 'catName');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  // Author related queries
  Future<List<Autori>?> getAllAut() async {
    final dbClient = await con.db;
    final res = await dbClient!
        .query('Authors', orderBy: 'name, surname', groupBy: 'id');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Autori>?> searchAut(String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('Authors',
        where: 'name LIKE ? OR surname LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        groupBy: 'id',
        orderBy: 'name, surname');

    List<Autori>? list =
        res.isNotEmpty ? res.map((c) => Autori.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getSongsByAut(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
        where: 'autId = ?',
        whereArgs: [id],
        orderBy: 'songId',
        groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> getAutBySongId(id) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
        where: 'songId = ?',
        whereArgs: [id],
        groupBy: 'autId',
        orderBy: 'autName');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

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
    final res = await dbClient!.query('View_Raccolta',
        where: 'isFav = ?',
        whereArgs: [1],
        orderBy: 'songId',
        groupBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  Future<List<Raccolta>?> searchFav(int value, String keyword) async {
    final dbClient = await con.db;
    final res = await dbClient!.query('View_Raccolta',
        where:
            'isFav = ? AND (songId LIKE ? OR songTitle LIKE ? OR songText LIKE ?)',
        whereArgs: ['$value', '%$keyword%', '%$keyword%', '%$keyword%'],
        groupBy: 'songId',
        orderBy: 'songId');

    List<Raccolta>? list =
        res.isNotEmpty ? res.map((c) => Raccolta.fromMap(c)).toList() : null;

    return list;
  }

  // Insert queries
  Future<List<Raccolta>?> insertSongs(title, text, fav) async {
    final dbClient = await con.db;
    await dbClient!.insert(
      'Songs',
      {'title': title, 'text': text, 'fav': fav},
    );
    return null;
  }

  Future<List<Raccolta>?> insertSongsCategories(
      songId, macroId, catId, songTitle) async {
    final dbClient = await con.db;
    await dbClient!.insert(
      'Songs_Categories',
      {
        'song_id': songId,
        'macro_id': macroId,
        'cat_id': catId,
        'song_title': songTitle
      },
    );
    return null;
  }

  Future<List<Raccolta>?> insertSongsAuthors(songId, autId, songTitle) async {
    final dbClient = await con.db;
    await dbClient!.insert(
      'Songs_Authors',
      {'song_id': songId, 'aut_id': autId, 'song_title': songTitle},
    );
    return null;
  }

  Future<List<Raccolta>?> insertCat(name, macroId, macroName) async {
    final dbClient = await con.db;
    await dbClient!.insert(
      'Categories',
      {'name': name, 'macro_id': macroId, 'macro_name': macroName},
    );
    return null;
  }

  Future<List<Raccolta>?> insertAut(name, surname) async {
    final dbClient = await con.db;
    await dbClient!.insert(
      'Authors',
      {'name': name, 'surname': surname},
    );
    return null;
  }

  //Update queries
  Future<List<Raccolta>?> updateSongs(title, text, id) async {
    final dbClient = await con.db;
    await dbClient!.update(
      'Songs',
      {'title': title, 'text': text},
      where: 'id = ?',
      whereArgs: [id],
    );
    return null;
  }

  Future<List<Raccolta>?> updateSongsCategories(
      id, macroIdList, catIdList, songTitle) async {
    final dbClient = await con.db;

    // Get all existing category records for the specified song
    final List<Map<String, dynamic>> existingCategories = await dbClient!.query(
      'Songs_Categories',
      where: 'song_id = ?',
      whereArgs: [id],
    ).then((records) => records);

    // Create a new list of category records to be inserted
    final List<Map<String, dynamic>> newCategories = [];
    for (int i = 0; i < macroIdList.length; i++) {
      int macroId = macroIdList[i];
      int catId = catIdList[i];
      newCategories.add({
        'song_id': id,
        'macro_id': macroId,
        'cat_id': catId,
        'song_title': songTitle,
      });
    }

    // Insert the new category records
    for (int i = 0; i < newCategories.length; i++) {
      await dbClient.insert(
        'Songs_Categories',
        newCategories[i],
      );
    }

    // Delete any existing category records that are not in the new list
    for (int i = 0; i < existingCategories.length; i++) {
      Map<String, dynamic> existingCategory = existingCategories[i];
      bool existsInNewList = false;
      for (int j = 0; j < newCategories.length; j++) {
        if (existingCategory['macro_id'] == newCategories[j]['macro_id'] &&
            existingCategory['cat_id'] == newCategories[j]['cat_id']) {
          existsInNewList = true;
          break;
        }
      }
      if (!existsInNewList) {
        await dbClient.delete(
          'Songs_Categories',
          where: 'song_id = ? AND macro_id = ? AND cat_id = ?',
          whereArgs: [
            id,
            existingCategory['macro_id'],
            existingCategory['cat_id']
          ],
        );
      }
    }

    return null;
  }

  Future<List<Raccolta>?> updateSongsAuthors(id, autIdList, songTitle) async {
    final dbClient = await con.db;

    // Get all existing author records for the specified song
    final List<Map<String, dynamic>> existingAuthors = await dbClient!.query(
      'Songs_Authors',
      where: 'song_id = ?',
      whereArgs: [id],
    ).then((records) => records);

    // Create a new list of author records to be inserted
    final List<Map<String, dynamic>> newAuthors = [];
    for (int i = 0; i < autIdList.length; i++) {
      int autId = autIdList[i];
      newAuthors.add({
        'song_id': id,
        'aut_id': autId,
        'song_title': songTitle,
      });
    }

    // Insert the new author records
    for (int i = 0; i < newAuthors.length; i++) {
      await dbClient.insert(
        'Songs_Authors',
        newAuthors[i],
      );
    }

    // Delete any existing author records that are not in the new list
    for (int i = 0; i < existingAuthors.length; i++) {
      Map<String, dynamic> existingAuthor = existingAuthors[i];
      bool existsInNewList = false;
      for (int j = 0; j < newAuthors.length; j++) {
        if (existingAuthor['aut_id'] == newAuthors[j]['aut_id']) {
          existsInNewList = true;
          break;
        }
      }
      if (!existsInNewList) {
        await dbClient.delete(
          'Songs_Authors',
          where: 'song_id = ? AND aut_id = ?',
          whereArgs: [id, existingAuthor['aut_id']],
        );
      }
    }

    return null;
  }

  Future<List<Raccolta>?> updateCat(name, macroId, macroName, id) async {
    final dbClient = await con.db;
    await dbClient!.update(
      'Categories',
      {'name': name, 'macro_id': macroId, 'macro_name': macroName},
      where: 'id = ?',
      whereArgs: [id],
    );
    return null;
  }

  Future<List<Raccolta>?> updateAut(name, surname, id) async {
    final dbClient = await con.db;
    await dbClient!.update(
      'Authors',
      {'name': name, 'surname': surname},
      where: 'id = ?',
      whereArgs: [id],
    );
    return null;
  }

  //Delete queries
  Future<List<Raccolta>?> deleteSong(id) async {
    final dbClient = await con.db;
    await dbClient!.delete('Songs', where: 'id = ?', whereArgs: [id]);
    return null;
  }

  Future<List<Raccolta>?> deleteCat(id) async {
    final dbClient = await con.db;
    await dbClient!.delete('Categories', where: 'id = ?', whereArgs: [id]);
    return null;
  }

  Future<List<Raccolta>?> deleteAut(id) async {
    final dbClient = await con.db;
    await dbClient!.delete('Authors', where: 'id = ?', whereArgs: [id]);
    return null;
  }
}
