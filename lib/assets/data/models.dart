import '../../screens/new_song/new_song_page.dart';

class Raccolta {
  late int songId;
  late String songTitle;
  late String songText;
  late int isFav;
  late int macroId;
  late String macroName;
  late int catId;
  late String catName;

  Raccolta.fromMap(dynamic obj) {
    songId = obj['songId'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
    isFav = obj['isFav'];
    macroId = obj['macroId'];
    macroName = obj['macroName'];
    catId = obj['catId'];
    catName = obj['catName'];
  }
}

class Autori {
  late int autId;
  late String autName;
  late int songId;
  late String songTitle;
  late String songText;

  Autori.fromMap(dynamic obj) {
    autId = obj['autId'];
    autName = obj['autName'];
    songId = obj['songId'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
  }
}

class Songs {
  late int id;
  late String title;
  late String text;
  late int cat_id;
  late int fav;

  Songs.fromMap(dynamic obj) {
    id = obj['id'];
    title = obj['title'];
    text = obj['text'];
    cat_id = obj['cat_id'];
    fav = obj['fav'];
  }
}

class NewSongs {
  String? title;
  List<Verse>? text;

  NewSongs({this.title, this.text});

  NewSongs.fromMap(Map<String, dynamic> map) {
    title = map['Titolo'];
    if (map['Testo'] != null) {
      text = <Verse>[];
      map['Testo'].forEach((v) {
        text!.add(Verse.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['Titolo'] = title;
    if (text != null) {
      data['Testo'] = text!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}
