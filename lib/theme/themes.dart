import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/theme/constants.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    primaryColorDark: kPrimaryColor,
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
            .copyWith(color: kPrimaryColor),
    scaffoldBackgroundColor: kWhite,
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: kDefaultPadding * 0.8,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: kLightGrey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
      ),
      prefixIconColor: kPrimaryColor,
      labelStyle: TextStyle(color: kLightGrey),
    ),
    cardColor: kWhite,
    toggleableActiveColor: kWhite,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: kPrimaryColor),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryColor,
      inactiveTrackColor: kLightGrey.withOpacity(0.4),
      activeTrackColor: kPrimaryColor.withOpacity(0.8),
      overlayColor: kPrimaryColor.withOpacity(0.4),
      thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: kDefaultPadding * 0.75),
      overlayShape:
          const RoundSliderOverlayShape(overlayRadius: kDefaultPadding * 1.25),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: kGrey,
    primaryColorDark: kPrimaryLightColor,
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
            .copyWith(color: kGrey),
    scaffoldBackgroundColor: kBlack,
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: kDefaultPadding * 0.8,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: kWhite, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: kPrimaryLightColor, width: 2.0),
      ),
      prefixIconColor: kPrimaryColor,
      labelStyle: TextStyle(color: kWhite),
    ),
    cardColor: kBlack,
    toggleableActiveColor: kWhite,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: kWhite),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: kWhite, backgroundColor: kPrimaryLightColor),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryLightColor,
      inactiveTrackColor: kLightGrey,
      activeTrackColor: kPrimaryLightColor.withOpacity(0.8),
      overlayColor: kPrimaryLightColor.withOpacity(0.3),
      thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: kDefaultPadding * 0.75),
      overlayShape:
          const RoundSliderOverlayShape(overlayRadius: kDefaultPadding * 1.25),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryLightColor),
    ),
  );
}
