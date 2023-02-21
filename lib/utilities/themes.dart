import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

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
      labelStyle: TextStyle(color: kLightGrey),
      errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      errorMaxLines: 3,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kPrimaryColor,
      selectionColor: kPrimaryColor.withOpacity(0.3),
      selectionHandleColor: kPrimaryColor,
    ),
    cardColor: kWhite,
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
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: kBlack),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kLightGrey),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kPrimaryColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kPrimaryColor;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kLightGrey;
        }
        return null;
      }),
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
      labelStyle: TextStyle(color: kWhite),
      errorStyle:
          TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      errorMaxLines: 3,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kPrimaryLightColor,
      selectionColor: kPrimaryLightColor.withOpacity(0.3),
      selectionHandleColor: kPrimaryLightColor,
    ),
    cardColor: kBlack,
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
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: kWhite),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kWhite),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kPrimaryLightColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kPrimaryLightColor;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kLightGrey;
        }
        return null;
      }),
    ),
  );
}
