import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/aut_dialog.dart';
import '../components/cat_dialog.dart';
import '../screens/editor/editor.dart';
import '../utilities/constants.dart';
import '../utilities/error_codes.dart';
import '../utilities/theme_provider.dart';
import 'random_song.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({
    Key? key,
    required this.notFoundMessage,
  }) : super(key: key);

  final String notFoundMessage;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          notFoundMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        notFoundMessage == ErrorCodes.favoritesNotFound
            ? TextButton.icon(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: themeProvider.isDarkMode
                          ? kPrimaryLightColor
                          : kPrimaryColor,
                    ),
                    Icon(
                      Icons.shuffle,
                      size: 15,
                      color: themeProvider.isDarkMode ? kBlack : kWhite,
                    ),
                  ],
                ),
                label: Text(
                  'Scopri un cantico casuale',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? kWhite : kBlack,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RandomSong();
                      },
                    ),
                  );
                },
              )
            : TextButton.icon(
                icon: Icon(
                  Icons.add_circle,
                  color: themeProvider.isDarkMode
                      ? kPrimaryLightColor
                      : kPrimaryColor,
                ),
                label: Text(
                  'Aggiungi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? kWhite : kBlack,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (notFoundMessage != ErrorCodes.categoriesNotFound &&
                      notFoundMessage != ErrorCodes.authorsNotFound &&
                      notFoundMessage != ErrorCodes.macroCategoriesNotFound) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Editor();
                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (notFoundMessage == ErrorCodes.categoriesNotFound) {
                          return CatDialog();
                        } else if (notFoundMessage ==
                            ErrorCodes.authorsNotFound) {
                          return AutDialog();
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  }
                },
              ),
      ],
    );
  }
}
