import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/editor/editor.dart';
import '../utilities/constants.dart';
import '../utilities/theme_provider.dart';

class SongNotFound extends StatelessWidget {
  const SongNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Nessun cantico trovato',
          style: TextStyle(fontSize: 20.0),
        ),
        TextButton.icon(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Editor();
                },
              ),
            );
          },
          icon: Icon(
            Icons.add_circle,
            color:
                themeProvider.isDarkMode ? kPrimaryLightColor : kPrimaryColor,
          ),
          label: Text(
            'Aggiungi cantico',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? kWhite : kBlack,
            ),
          ),
        ),
      ],
    );
  }
}
