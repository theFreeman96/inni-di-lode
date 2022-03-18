import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/theme/constants.dart';
import '/assets/theme/provider.dart';

class SongsDetail extends StatefulWidget {
  @override
  State<SongsDetail> createState() => _SongsDetailState();
}

class _SongsDetailState extends State<SongsDetail> {
  double textSize = 18.0;
  double textSizeMin = 15.0;
  double textSizeMax = 24.0;

  double textHeight = 1.5;
  double textHeightMin = 1.0;
  double textHeightMax = 2.0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dettaglio'),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding, right: kDefaultPadding),
              child: Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Preferito',
          child: Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: CircleAvatar(
                        child: Text('1'),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Text(
                        'Titolo del Cantico',
                        style: TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: kDefaultPadding * 2, right: kDefaultPadding * 2),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SelectableText(
                        '''Testo del Cantico:\nTesto del Cantico,\nTesto del Cantico.\n\nTesto del Cantico:\nTesto del Cantico,\nTesto del Cantico.\n\nTesto del Cantico:\nTesto del Cantico,\nTesto del Cantico.\n\n''',
                        style:
                            TextStyle(fontSize: textSize, height: textHeight),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: 'Impostazioni',
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.format_size),
                              title: Text('Dimensione Testo'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.text_decrease),
                                    tooltip: 'Testo più Piccolo',
                                    onPressed: () {
                                      if (textSize > textSizeMin) {
                                        textSize = textSize - 3.0;
                                      } else {
                                        print(
                                            'Dimensione minima del testo: $textSize');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.text_increase),
                                    tooltip: 'Testo più Grande',
                                    onPressed: () {
                                      if (textSize < textSizeMax) {
                                        textSize = textSize + 3.0;
                                      } else {
                                        print(
                                            'Dimensione massima del testo: $textSize');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.format_line_spacing),
                              title: Text('Interlinea'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.density_small,
                                    ),
                                    tooltip: 'Diminuisci Interlinea',
                                    onPressed: () {
                                      if (textHeight > textHeightMin) {
                                        textHeight = textHeight - 0.5;
                                      } else {
                                        print('Interlinea minima: $textHeight');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.density_medium,
                                    ),
                                    tooltip: 'Aumenta Interlinea',
                                    onPressed: () {
                                      if (textHeight < textHeightMax) {
                                        textHeight = textHeight + 0.5;
                                      } else {
                                        print(
                                            'Interlinea massima: $textHeight');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Center(
                                child: Text('Chiudi'),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_fill,
                  ),
                  tooltip: 'Riproduci',
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: 'Condividi',
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
