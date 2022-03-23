import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/assets/theme/constants.dart';

class MyTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      primaryColorDark: kPrimaryColor,
      appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
          .copyWith(color: kPrimaryColor),
      scaffoldBackgroundColor: kWhite,
      cardColor: kWhite,
      toggleableActiveColor: kWhite,
      accentColor: kPrimaryColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: kPrimaryColor)
      // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
      );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: kGrey,
    primaryColorDark: kPrimaryLightColor,
    appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
        .copyWith(color: kGrey),
    scaffoldBackgroundColor: kBlack,
    cardColor: kBlack,
    toggleableActiveColor: kWhite,
    accentColor: kWhite,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: kWhite),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: kPrimaryLightColor, backgroundColor: kWhite),
  );
}
