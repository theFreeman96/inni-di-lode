import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          children: [
            Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            Switch(
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              value: themeProvider.isDarkMode,
            ),
          ],
        );
      },
    );
  }
}
