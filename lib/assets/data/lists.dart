class Songs {
  late int id;
  late String title;

  Songs(this.id, this.title);

  Songs.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.title = obj['title'];
  }
}

class Macrocategories {
  late int id;
  late String name;

  Macrocategories(this.id, this.name);

  Macrocategories.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
  }
}

class Categories {
  late int id;
  late String name;
  late int macro_id;

  Categories(this.id, this.name, this.macro_id);

  Categories.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.macro_id = obj['macro_id'];
  }
}

class Authors {
  late int id;
  late String name;
  late String surname;

  Authors(this.id, this.name, this.surname);

  Authors.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.surname = obj['surname'];
  }
}

class View_Canti {
  late int songID;
  late String songTitle;
  late String songText;
  late int macroId;
  late String macroName;
  late int catId;
  late String catName;
  late String autName;

  View_Canti(this.songID, this.songTitle, this.songText, this.macroId,
      this.macroName, this.catId, this.catName, this.autName);

  View_Canti.fromMap(dynamic obj) {
    this.songID = obj['songID'];
    this.songTitle = obj['songTitle'];
    this.songText = obj['songText'];
    this.macroId = obj['macroId'];
    this.macroName = obj['macroName'];
    this.catId = obj['catId'];
    this.catName = obj['catName'];
    this.autName = obj['autName'];
  }
}
