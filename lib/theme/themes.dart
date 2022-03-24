import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/theme/constants.dart';

class MyTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      primaryColorDark: kPrimaryColor,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
              .copyWith(color: kPrimaryColor),
      scaffoldBackgroundColor: kWhite,
      cardColor: kWhite,
      toggleableActiveColor: kWhite,
      accentColor: kPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: kPrimaryColor)
      // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
      );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: kGrey,
    primaryColorDark: kPrimaryLightColor,
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
            .copyWith(color: kGrey),
    scaffoldBackgroundColor: kBlack,
    cardColor: kBlack,
    toggleableActiveColor: kWhite,
    accentColor: kWhite,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: kWhite),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: kPrimaryLightColor, backgroundColor: kWhite),
  );
}
