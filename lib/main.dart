import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';
import '/theme/themes.dart';

import '/screens/home.dart';

Future main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  runApp(const Innario());
}

class Innario extends StatelessWidget {
  const Innario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.isDarkMode ? AppTheme.dark : AppTheme.light,
              title: 'Inni di Lode',
              scaffoldMessengerKey: snackBarKey,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: MyScrollBehavior(),
                  child: SizedBox(child: child),
                );
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('it', ''),
                Locale('en', ''),
              ],
              home: const Home(),
            ),
          );
        },
      ),
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
    };
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
