import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/editor/editor.dart';
import '../utilities/constants.dart';
import '../utilities/theme_provider.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
          ),
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
            'Aggiungi',
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
