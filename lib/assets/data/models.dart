class Raccolta {
  late int songId;
  late String songTitle;
  late String songText;
  late int macroId;
  late String macroName;
  late int catId;
  late String catName;

  Raccolta.fromMap(dynamic obj) {
    songId = obj['songId'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
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

  Songs.fromMap(dynamic obj) {
    id = obj['id'];
    title = obj['title'];
    text = obj['text'];
  }
}

class Macrocategories {
  late int id;
  late String name;

  Macrocategories.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
  }
}

class Categories {
  late int id;
  late String name;
  late int macro_id;

  Categories.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    macro_id = obj['macro_id'];
  }
}

class Authors {
  late int id;
  late String name;
  late String surname;

  Authors.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    surname = obj['surname'];
  }
}

class Songs_Authors {
  late int song_id;
  late int aut_id;
  late String song_title;

  Songs_Authors.fromMap(dynamic obj) {
    song_id = obj['song_id'];
    aut_id = obj['aut_id'];
    song_title = obj['song_title'];
  }
}
