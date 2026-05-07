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
      surface: kWhite,
      onSurface: kLightGrey.withValues(alpha: 0.5),
      surfaceTint: kWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryColor,
      foregroundColor: kWhite,
    ),
    scaffoldBackgroundColor: kWhite,
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const IconThemeData(color: kLightGrey);
        }
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kWhite);
        }
        return IconThemeData(color: kWhite.withValues(alpha: 0.6));
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const TextStyle(
            color: kLightGrey,
            fontSize: 10,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: kWhite,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: kWhite.withValues(alpha: 0.6),
          fontSize: 10,
        );
      }),
    ),
    cardColor: kWhite,
    dividerTheme: DividerThemeData(color: kLightGrey.withValues(alpha: 0.2)),
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
      selectionColor: kPrimaryColor.withValues(alpha: 0.3),
      selectionHandleColor: kPrimaryColor,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryColor,
      inactiveTrackColor: kLightGrey.withValues(alpha: 0.4),
      activeTrackColor: kPrimaryColor.withValues(alpha: 0.8),
      overlayColor: kPrimaryColor.withValues(alpha: 0.4),
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
      thumbColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kLightGrey;
        }
        return Colors.blue;
      }),
      trackOutlineColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      thumbIcon:
          WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const Icon(
            Icons.light_mode,
            color: kTertiaryColor,
            size: 20,
          );
        }
        if (states.contains(WidgetState.selected)) {
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
      surface: kBlack,
      onSurface: kLightGrey.withValues(alpha: 0.5),
      surfaceTint: kGrey,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: kGrey),
    scaffoldBackgroundColor: kBlack,
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const IconThemeData(color: kLightGrey);
        }
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kWhite);
        }
        return IconThemeData(color: kWhite.withValues(alpha: 0.6));
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const TextStyle(
            color: kLightGrey,
            fontSize: 10,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: kWhite,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: kWhite.withValues(alpha: 0.6),
          fontSize: 10,
        );
      }),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: kGrey),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kGrey),
    cardColor: kBlack,
    dividerTheme: DividerThemeData(color: kLightGrey.withValues(alpha: 0.2)),
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
      selectionColor: kPrimaryLightColor.withValues(alpha: 0.3),
      selectionHandleColor: kPrimaryLightColor,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryLightColor,
      inactiveTrackColor: kLightGrey,
      activeTrackColor: kPrimaryLightColor.withValues(alpha: 0.8),
      overlayColor: kPrimaryLightColor.withValues(alpha: 0.3),
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
      thumbColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kLightGrey;
        }
        return Colors.blue;
      }),
      trackOutlineColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return kWhite;
        }
        if (states.contains(WidgetState.selected)) {
          return kWhite;
        }
        return kWhite;
      }),
      thumbIcon:
          WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const Icon(
            Icons.dark_mode,
            color: kLightGrey,
          );
        }
        if (states.contains(WidgetState.selected)) {
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
