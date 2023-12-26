import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,

      //Primary
      primary: kPrimaryColor,
      onPrimary: kWhite,
      primaryContainer: kPrimaryColor,
      onPrimaryContainer: kWhite,

      //Backgrounds
      background: kWhite,
      onBackground: kLightGrey.withOpacity(0.5),
      surfaceTint: kWhite,
    ),
    appBarTheme: const AppBarTheme(
      color: kPrimaryColor,
      foregroundColor: kWhite,
    ),
    scaffoldBackgroundColor: kWhite,
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const IconThemeData(color: kLightGrey);
        }
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: kWhite);
        }
        return IconThemeData(color: kWhite.withOpacity(0.6));
      }),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const TextStyle(
            color: kLightGrey,
            fontSize: 10,
          );
        }
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: kWhite,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: kWhite.withOpacity(0.6),
          fontSize: 10,
        );
      }),
    ),
    cardColor: kWhite,
    dividerTheme: DividerThemeData(color: kLightGrey.withOpacity(0.2)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: kWhite,
      backgroundColor: kPrimaryColor,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: kDefaultPadding * 0.8,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: kLightGrey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: kPrimaryColor,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(color: kLightGrey),
      errorStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      errorMaxLines: 3,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kPrimaryColor,
      selectionColor: kPrimaryColor.withOpacity(0.3),
      selectionHandleColor: kPrimaryColor,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryColor,
      inactiveTrackColor: kLightGrey.withOpacity(0.4),
      activeTrackColor: kPrimaryColor.withOpacity(0.8),
      overlayColor: kPrimaryColor.withOpacity(0.4),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: kDefaultPadding * 0.75,
      ),
      overlayShape: const RoundSliderOverlayShape(
        overlayRadius: kDefaultPadding * 1.25,
      ),
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
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kLightGrey;
        }
        return Colors.blue;
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      thumbIcon:
          MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Icon(
            Icons.light_mode,
            color: kTertiaryColor,
            size: 20,
          );
        }
        if (states.contains(MaterialState.selected)) {
          return const Icon(
            Icons.dark_mode,
            color: kLightGrey,
          );
        }
        return const Icon(
          Icons.light_mode,
          color: kTertiaryColor,
          size: 20,
        );
      }),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,

      //Primary
      primary: kPrimaryLightColor,
      onPrimary: kWhite,
      primaryContainer: kPrimaryLightColor,
      onPrimaryContainer: kWhite,

      //Backgrounds
      background: kBlack,
      onBackground: kLightGrey.withOpacity(0.5),
      surfaceTint: kGrey,
    ),
    appBarTheme: const AppBarTheme(color: kGrey),
    scaffoldBackgroundColor: kBlack,
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const IconThemeData(color: kLightGrey);
        }
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: kWhite);
        }
        return IconThemeData(color: kWhite.withOpacity(0.6));
      }),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const TextStyle(
            color: kLightGrey,
            fontSize: 10,
          );
        }
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: kWhite,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: kWhite.withOpacity(0.6),
          fontSize: 10,
        );
      }),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: kGrey),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kGrey),
    cardColor: kBlack,
    dividerTheme: DividerThemeData(color: kLightGrey.withOpacity(0.2)),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: kWhite),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: kWhite,
      backgroundColor: kPrimaryLightColor,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: kDefaultPadding * 0.8,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: kWhite,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: kPrimaryLightColor,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(color: kWhite),
      errorStyle: TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
      errorMaxLines: 3,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2.0,
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kPrimaryLightColor,
      selectionColor: kPrimaryLightColor.withOpacity(0.3),
      selectionHandleColor: kPrimaryLightColor,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryLightColor,
      inactiveTrackColor: kLightGrey,
      activeTrackColor: kPrimaryLightColor.withOpacity(0.8),
      overlayColor: kPrimaryLightColor.withOpacity(0.3),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: kDefaultPadding * 0.75,
      ),
      overlayShape: const RoundSliderOverlayShape(
        overlayRadius: kDefaultPadding * 1.25,
      ),
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
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kLightGrey;
        }
        return Colors.blue;
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return kWhite;
        }
        if (states.contains(MaterialState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      thumbIcon:
          MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Icon(
            Icons.dark_mode,
            color: kLightGrey,
          );
        }
        if (states.contains(MaterialState.selected)) {
          return const Icon(
            Icons.dark_mode,
            color: kLightGrey,
          );
        }
        return const Icon(
          Icons.light_mode,
          color: kTertiaryColor,
          size: 20,
        );
      }),
    ),
  );
}
