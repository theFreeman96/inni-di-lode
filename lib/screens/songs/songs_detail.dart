import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import '../categories/cat_detail.dart';
import '../authors/aut_detail.dart';

import 'songs_pdf.dart';
import 'songs_player.dart';

class SongsDetail extends StatefulWidget {
  int songId;
  String from;
  SongsDetail({Key? key, required this.songId, required this.from})
      : super(key: key);

  @override
  State<SongsDetail> createState() => _SongsDetailState();
}

class _SongsDetailState extends State<SongsDetail> {
  late PageController pageController;
  final QueryCtr query = QueryCtr();

  late double textScaleFactor = MediaQuery.of(context).textScaleFactor;

  late double fontSize = 18.0 * textScaleFactor;
  late double fontSizeMin = 16.0 * textScaleFactor;
  late double fontSizeMax = 20.0 * textScaleFactor;

  late double lineHeight = 1.5 * textScaleFactor;
  late double lineHeightMin = 1.0 * textScaleFactor;
  late double lineHeightMax = 2.0 * textScaleFactor;

  @override
  initState() {
    pageController = PageController(initialPage: widget.songId - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List?>(
        future: /*widget.from == 'Songs'
            ? query.getAllSongs()
            : widget.from == 'Category'
                ? query.getSongsByCat(widget.id!)
                : widget.from == 'Author'
                    ? query.getSongsByAut(widget.id!)
                    : widget.from == 'Favorites'
                        ? query.getAllFav()
                        :*/
            query.getAllSongs(),
        initialData: const [],
        builder: (context, snapshot) {
          return PageView.builder(
            controller: pageController,
            itemBuilder: (context, i) {
              return buildPage(snapshot.data![i]);
            },
          );
        },
      ),
    );
  }

  Widget buildPage(Raccolta get) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String text = get.songText;
    String parsedSongText = text.replaceAll('<li>', '<li><br>');
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          tooltip: 'Indietro',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
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
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        controller: pageController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
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
                  style: TextStyle(fontSize: 22.0 * textScaleFactor),
                  textAlign: TextAlign.center,
                ),
              ),
              Html(
                data: parsedSongText,
                style: {
                  'ol': Style(
                    textAlign: TextAlign.center,
                    fontSize: FontSize(fontSize),
                    lineHeight: LineHeight(lineHeight),
                    listStylePosition: ListStylePosition.inside,
                    padding: const EdgeInsets.only(bottom: kDefaultPadding),
                  ),
                  'li': Style(
                      padding:
                          const EdgeInsets.only(right: kDefaultPadding / 2)),
                },
              ),
              const Divider(),
              FutureBuilder<List?>(
                future: query.getCatBySongId(widget.songId),
                initialData: const [],
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              bottom: kDefaultPadding * 0.4),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                buildCatInfo(snapshot.data![i]),
                              ],
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: kDefaultPadding),
                          child: Center(
                            child: Text(
                              'Nessuna Categoria trovata',
                              style:
                                  TextStyle(fontSize: 20.0 * textScaleFactor),
                            ),
                          ),
                        );
                },
              ),
              FutureBuilder<List?>(
                future: query.getAutBySongId(widget.songId),
                initialData: const [],
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                buildAutInfo(snapshot.data![i]),
                              ],
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: kDefaultPadding),
                          child: Center(
                            child: Text(
                              'Nessun Autore trovato',
                              style:
                                  TextStyle(fontSize: 20.0 * textScaleFactor),
                            ),
                          ),
                        );
                },
              ),
              const SizedBox(height: kDefaultPadding * 3)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Preferito',
        child: Icon(get.isFav == 1 ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          if (get.isFav == 0) {
            query.updateFav(1, get.songId);
            setState(() {});
          } else {
            query.updateFav(0, get.songId);
            setState(() {});
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                                    if (fontSize > fontSizeMin) {
                                      fontSize = fontSize - 2.0;
                                    } else {
                                      log('Dimensione minima del testo: $fontSize');
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.replay),
                                  tooltip: 'Ripristina dimensione testo',
                                  onPressed: () {
                                    fontSize = 18.0 * textScaleFactor;
                                    log('Dimensione default del testo: $fontSize');
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.text_increase),
                                  tooltip: 'Testo più Grande',
                                  onPressed: () {
                                    if (fontSize < fontSizeMax) {
                                      fontSize = fontSize + 2.0;
                                    } else {
                                      log('Dimensione massima del testo: $fontSize');
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
                                    if (lineHeight > lineHeightMin) {
                                      lineHeight = lineHeight - 0.5;
                                    } else {
                                      log('Interlinea minima: $lineHeight');
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.replay),
                                  tooltip: 'Ripristina dimensione testo',
                                  onPressed: () {
                                    lineHeight = 1.5 * textScaleFactor;
                                    log('Interlinea di default: $lineHeight');
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
                                    if (lineHeight < lineHeightMax) {
                                      lineHeight = lineHeight + 0.5;
                                    } else {
                                      log('Interlinea massima: $lineHeight');
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
                icon: const Icon(Icons.play_circle_fill),
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
                      return const SongsPlayer();
                    },
                  );
                },
              ),
              IconButton(
                tooltip: 'Condividi',
                icon: const Icon(Icons.share),
                onPressed: () async {
                  await buildPDF(get.songId, get.songTitle, get.songText);
                },
              ),
              Visibility(
                visible: get.songId > 700 ? true : false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      tooltip: 'Modifica Cantico',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Elimina Cantico',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text('Conferma eliminazione'),
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? kWhite
                                        : kBlack,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Il cantico '),
                                    TextSpan(
                                      text: '${get.songId}. ${get.songTitle} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                        text:
                                            'sarà eliminato definitivamente.\nConfermi?')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Annulla');
                                  },
                                  child: const Text(
                                    'Annulla',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kLightGrey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    query.deleteSong(get.songId);
                                    setState(() {});
                                    Navigator.pop(context, 'Elimina');
                                  },
                                  child: Text(
                                    'Elimina',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkMode
                                            ? Colors.redAccent
                                            : Colors.red),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCatInfo(Raccolta get) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton.icon(
      icon: const Icon(Icons.sell, color: kLightGrey),
      label: Text(
        get.catName,
        style: TextStyle(color: themeProvider.isDarkMode ? kWhite : kBlack),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        int catId = get.catId;
        String catName = get.catName;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CatDetail(catId, catName);
            },
          ),
        );
      },
    );
  }

  Widget buildAutInfo(Raccolta get) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton.icon(
      icon: const Icon(Icons.person, color: kLightGrey),
      label: Text(
        get.autName,
        style: TextStyle(color: themeProvider.isDarkMode ? kWhite : kBlack),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        int autId = get.autId;
        String autName = get.autName;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail(autId, autName);
            },
          ),
        );
      },
    );
  }
}
