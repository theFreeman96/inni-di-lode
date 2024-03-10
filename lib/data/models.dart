class Raccolta {
  late int songId;
  late String songTitle;
  late String songText;
  late int isFav;
  late int macroId;
  late String macroName;
  late int catId;
  late String catName;
  late int autId;
  late String autName;
  late String autSurname;

  Raccolta.fromMap(dynamic obj) {
    songId = obj['songId'];
    songTitle = obj['songTitle'];
    songText = obj['songText'];
    isFav = obj['isFav'];
    macroId = obj['macroId'];
    macroName = obj['macroName'];
    catId = obj['catId'];
    catName = obj['catName'];
    autId = obj['autId'];
    autName = obj['autName'];
    autSurname = obj['autSurname'];
  }
}

class Macrocategorie {
  late int id;
  late String name;

  Macrocategorie.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
  }
}

class Categorie {
  late int id;
  late String name;
  late int macro_id;
  late String macro_name;

  Categorie.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    macro_id = obj['macro_id'];
    macro_name = obj['macro_name'];
  }
}

class Autori {
  late int id;
  late String surname;
  late String name;

  Autori.fromMap(dynamic obj) {
    id = obj['id'];
    surname = obj['surname'];
    name = obj['name'];
  }
}
