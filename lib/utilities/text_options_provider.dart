import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextOptionsProvider extends ChangeNotifier {
  final String fontSizeKey = "fontSize";
  final String lineHeightKey = "lineHeight";
  late SharedPreferences prefs;
  late double fontSize;
  late double lineHeight;

  TextOptionsProvider() {
    fontSize = 18.0;
    lineHeight = 1.5;
    loadFromPrefs();
  }

  setFontSize(double size) {
    fontSize = size;
    saveToPrefs();
    notifyListeners();
  }

  setLineHeight(double height) {
    lineHeight = height;
    saveToPrefs();
    notifyListeners();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  loadFromPrefs() async {
    await initPrefs();
    fontSize = prefs.getDouble(fontSizeKey) ?? 18.0;
    lineHeight = prefs.getDouble(lineHeightKey) ?? 1.5;
    notifyListeners();
  }

  saveToPrefs() async {
    await initPrefs();
    prefs.setDouble(fontSizeKey, fontSize);
    prefs.setDouble(lineHeightKey, lineHeight);
  }
}
