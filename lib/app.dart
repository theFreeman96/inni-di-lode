import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '/utilities//themes.dart';
import '/utilities/constants.dart';
import '/utilities/globals.dart';
import '/utilities/scroll_behavior.dart';
import '/utilities/text_options_provider.dart';
import '/utilities/theme_provider.dart';
import 'screens/home/home.dart';

class Innario extends StatelessWidget {
  const Innario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TextOptionsProvider()),
      ],
      child: Consumer2<ThemeProvider, TextOptionsProvider>(
        builder: (context, themeProvider, textOptionsProvider, child) {
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
              home: AnnotatedRegion(
                value: SystemUiOverlayStyle(
                  statusBarColor:
                      themeProvider.isDarkMode ? kGrey : kPrimaryColor,
                ),
                child: const Home(),
              ),
            ),
          );
        },
      ),
    );
  }
}
