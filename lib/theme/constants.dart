import 'package:flutter/material.dart';

// Costanti
const kPrimaryColor = Color(0xFF800011);
const kPrimaryLightColor = Color(0xFF9E2726);
const kBlack = Color(0xFF1C1D1F);
const kGrey = Color(0xFF303030);
const kLightGrey = Color(0xFF7E7E7E);
const kWhite = Color(0xFFE5E5E5);
const double kDefaultPadding = 20.0;

// Color Swatch
Map<int, Color> kSwatch = {
  50: const Color.fromRGBO(128, 0, 17, .1),
  100: const Color.fromRGBO(128, 0, 17, .2),
  200: const Color.fromRGBO(128, 0, 17, .3),
  300: const Color.fromRGBO(128, 0, 17, .4),
  400: const Color.fromRGBO(128, 0, 17, .5),
  500: const Color.fromRGBO(128, 0, 17, .6),
  600: const Color.fromRGBO(128, 0, 17, .7),
  700: const Color.fromRGBO(128, 0, 17, .8),
  800: const Color.fromRGBO(128, 0, 17, .9),
  900: const Color.fromRGBO(128, 0, 17, 1),
};

MaterialColor colorSwatch = MaterialColor(0xFF800011, kSwatch);
final kPrimarySwatch = colorSwatch;

// Light Color Swatch
Map<int, Color> kLightSwatch = {
  50: const Color.fromRGBO(158, 39, 38, .1),
  100: const Color.fromRGBO(158, 39, 38, .2),
  200: const Color.fromRGBO(158, 39, 38, .3),
  300: const Color.fromRGBO(158, 39, 38, .4),
  400: const Color.fromRGBO(158, 39, 38, .5),
  500: const Color.fromRGBO(158, 39, 38, .6),
  600: const Color.fromRGBO(158, 39, 38, .7),
  700: const Color.fromRGBO(158, 39, 38, .8),
  800: const Color.fromRGBO(158, 39, 38, .9),
  900: const Color.fromRGBO(158, 39, 38, 1),
};

MaterialColor colorLightSwatch = MaterialColor(0xFFBC433C, kLightSwatch);
final kPrimaryLightSwatch = kLightSwatch;
