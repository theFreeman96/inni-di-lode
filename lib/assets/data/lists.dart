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
    songID = obj['songID'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
    macroId = obj['macroId'];
    macroName = obj['macroName'];
    catId = obj['catId'];
    catName = obj['catName'];
    autName = obj['autName'];
  }
}
