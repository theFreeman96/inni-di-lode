import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '/theme/themes.dart';
import '/theme/provider.dart';

import '/screens/home.dart';

void main() {
  runApp(Innario());
}

class Innario extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider provider, child) {
            final provider = Provider.of<ThemeProvider>(context);
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: provider.isDarkMode
                    ? MyTheme.darkTheme
                    : MyTheme.lightTheme,
                title: 'Inni di Lode',
                home: SafeArea(
                  child: Home(),
                ),
              ),
            );
          },
        ),
      );
}
