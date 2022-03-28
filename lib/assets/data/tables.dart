class Raccolta {
  late int songId;
  late String songTitle;
  late String songText;
  late int macroId;
  late String macroName;
  late int catId;
  late String catName;
  late int autId;
  late String autName;

  Raccolta(this.songId, this.songTitle, this.songText, this.macroId,
      this.macroName, this.catId, this.catName, this.autId, this.autName);

  Raccolta.fromMap(dynamic obj) {
    songId = obj['songId'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
    macroId = obj['macroId'];
    macroName = obj['macroName'];
    catId = obj['catId'];
    catName = obj['catName'];
    autId = obj['autId'];
    autName = obj['autName'];
  }
}

class Songs {
  late int id;
  late String title;

  Songs(this.id, this.title);

  Songs.fromMap(dynamic obj) {
    id = obj['id'];
    title = obj['title'];
  }
}

class Macrocategories {
  late int id;
  late String name;

  Macrocategories(this.id, this.name);

  Macrocategories.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
  }
}

class Categories {
  late int id;
  late String name;
  late int macro_id;

  Categories(this.id, this.name, this.macro_id);

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

  Authors(this.id, this.name, this.surname);

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

  Songs_Authors(this.song_id, this.aut_id, this.song_title);

  Songs_Authors.fromMap(dynamic obj) {
    song_id = obj['song_id'];
    aut_id = obj['aut_id'];
    song_title = obj['song_title'];
  }
}
