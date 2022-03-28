class Songs {
  late int id;
  late String title;

  Songs.fromMap(dynamic obj) {
    id = obj['id'];
    title = obj['title'];
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
