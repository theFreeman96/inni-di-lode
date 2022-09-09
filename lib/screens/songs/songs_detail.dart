import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../assets/data/models.dart';
import '/theme/constants.dart';
import '/theme/provider.dart';
import '/assets/data/queries.dart';

import 'songs_pdf.dart';

class SongsDetail extends StatefulWidget {
  final int songId;
  final String songTitle;
  final String songText;
  const SongsDetail(this.songId, this.songTitle, this.songText);

  @override
  _SongsDetailState createState() =>
      _SongsDetailState(songId, songTitle, songText);
}

class _SongsDetailState extends State<SongsDetail> {
  final int songId;
  final String songTitle;
  final String songText;

  _SongsDetailState(this.songId, this.songTitle, this.songText);

  late PageController pageController = PageController(initialPage: songId - 1);

  double textSize = 16.0;
  double textSizeMin = 16.0;
  double textSizeMax = 20.0;

  double textHeight = 1.5;
  double textHeightMin = 1.0;
  double textHeightMax = 2.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List?>(
        future: QueryCtr().getAllSongs(),
        initialData: const [],
        builder: (context, snapshot) {
          return PageView.builder(
            controller: pageController,
            itemBuilder: (context, i) {
              return _buildPage(snapshot.data![i % snapshot.data!.length]);
            },
          );
        },
      ),
    );
  }

  Widget _buildPage(Raccolta get) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Indietro',
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.isDarkMode ? kWhite : kGrey,
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: kDefaultPadding, right: kDefaultPadding / 2),
            child: IconButton(
              tooltip: 'Condividi',
              icon: Icon(
                Icons.share,
                color: themeProvider.isDarkMode ? kWhite : kGrey,
              ),
              onPressed: () async {
                await buildPDF(get.songId, get.songTitle, get.songText);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Preferito',
        child: const Icon(Icons.favorite_border),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Scrollbar(
        thumbVisibility: true,
        controller: pageController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: CircleAvatar(
                  child: Text(
                    get.songId.toString(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: kDefaultPadding),
                child: Text(
                  get.songTitle,
                  style: const TextStyle(fontSize: 22.0),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding * 2,
                  right: kDefaultPadding * 2,
                  bottom: kDefaultPadding * 7,
                ),
                child: HtmlWidget(
                  get.songText,
                  textStyle: TextStyle(
                    fontSize: textSize,
                    height: textHeight,
                  ),
                ),
              ),
            ],
          ),
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
                icon: const Icon(Icons.settings),
                tooltip: 'Impostazioni',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SwitchListTile(
                            secondary: Icon(
                              themeProvider.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                            ),
                            title: const Text('Tema'),
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              final themeProvider = Provider.of<ThemeProvider>(
                                  context,
                                  listen: false);
                              themeProvider.toggleTheme(value);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.format_size),
                            title: const Text('Carattere'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.text_decrease),
                                  tooltip: 'Testo più Piccolo',
                                  onPressed: () {
                                    if (textSize > textSizeMin) {
                                      textSize = textSize - 2.0;
                                    } else {
                                      log('Dimensione minima del testo: $textSize');
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.text_increase),
                                  tooltip: 'Testo più Grande',
                                  onPressed: () {
                                    if (textSize < textSizeMax) {
                                      textSize = textSize + 2.0;
                                    } else {
                                      log('Dimensione massima del testo: $textSize');
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
                            leading: const Icon(Icons.format_line_spacing),
                            title: const Text('Interlinea'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.density_small,
                                  ),
                                  tooltip: 'Diminuisci Interlinea',
                                  onPressed: () {
                                    if (textHeight > textHeightMin) {
                                      textHeight = textHeight - 0.5;
                                    } else {
                                      log('Interlinea minima: $textHeight');
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.density_medium,
                                  ),
                                  tooltip: 'Aumenta Interlinea',
                                  onPressed: () {
                                    if (textHeight < textHeightMax) {
                                      textHeight = textHeight + 0.5;
                                    } else {
                                      log('Interlinea massima: $textHeight');
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Center(
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
                icon: const Icon(
                  Icons.play_circle_fill,
                ),
                tooltip: 'Riproduci',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Divider(),
                          ListTile(
                            title: const Center(
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
            ],
          ),
        ),
      ),
    );
  }
}
