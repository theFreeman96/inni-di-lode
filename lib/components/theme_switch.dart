import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding / 2),
          child: Switch(
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            value: themeProvider.isDarkMode,
          ),
        );
      },
    );
  }
}
