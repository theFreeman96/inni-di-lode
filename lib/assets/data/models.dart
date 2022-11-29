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
  }
}
