import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';
import '/components/player.dart';
import '/components/pdf.dart';
import '/data/models.dart';
import '/data/queries.dart';

import '../categories/cat_detail.dart';
import '../authors/aut_detail.dart';
import '../editor/edit_song_page.dart';
import '../home/home.dart';

class SongsDetail extends StatefulWidget {
  int index;
  String from;
  int? id;
  SongsDetail({Key? key, required this.index, required this.from, this.id})
      : super(key: key);

  @override
  State<SongsDetail> createState() => _SongsDetailState();
}

class _SongsDetailState extends State<SongsDetail> {
  late PageController pageController;
  final QueryCtr query = QueryCtr();

  late double fontSize = 18.0;
  final double fontSizeMin = 16.0;
  final double fontSizeMax = 20.0;

  late double lineHeight = 1.5;
  final double lineHeightMin = 1.0;
  final double lineHeightMax = 2.0;

  @override
  initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        if (widget.from == 'Songs' || widget.from == 'Drawer') {
          pageController.jumpToPage(widget.index - 1);
        } else {
          pageController.jumpToPage(widget.index);
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return Stack(
      children: [
        FutureBuilder<List?>(
          future: widget.from == 'Category'
              ? query.getSongsByCat(widget.id!)
              : widget.from == 'Author'
                  ? query.getSongsByAut(widget.id!)
                  : widget.from == 'Favorites'
                      ? query.getAllFav()
                      : query.getAllSongs(),
          initialData: const [],
          builder: (context, snapshot) {
            return PageView.builder(
              controller: pageController,
              itemBuilder: (context, i) {
                return buildPage(snapshot.data![i % snapshot.data!.length]);
              },
            );
          },
        ),
        Visibility(
          visible: orientation == Orientation.portrait ? false : true,
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (pageController.hasClients) {
                          pageController.animateToPage(
                            pageController.page!.toInt() - 1,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (pageController.hasClients) {
                          pageController.animateToPage(
                            pageController.page!.toInt() + 1,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPage(Raccolta get) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                  style: const TextStyle(fontSize: 22.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Html(
                data: get.songText,
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
                          const EdgeInsets.only(right: kDefaultPadding / 4)),
                },
              ),
              const Divider(),
              FutureBuilder<List?>(
                future: query.getCatBySongId(get.songId),
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
                      : const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding),
                          child: Center(
                            child: Text(
                              'Nessuna categoria trovata',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        );
                },
              ),
              FutureBuilder<List?>(
                future: query.getAutBySongId(get.songId),
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
                      : const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding),
                          child: Center(
                            child: Text(
                              'Nessun autore trovato',
                              style: TextStyle(fontSize: 20.0),
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
            if (widget.from == 'Favorites') {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            }
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
                                    fontSize = 18.0;
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
                                    lineHeight = 1.5;
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
                tooltip:
                    Platform.isWindows || Platform.isMacOS || Platform.isLinux
                        ? 'Scarica'
                        : 'Condividi',
                icon: Platform.isWindows || Platform.isMacOS || Platform.isLinux
                    ? const Icon(Icons.download)
                    : const Icon(Icons.share),
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
                      tooltip: 'Modifica cantico',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditSongPage(
                                songId: get.songId,
                                songTitle: get.songTitle,
                                songText: get.songText,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Elimina cantico',
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
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Annulla');
                                  },
                                  child: const Text('Annulla'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    query.deleteSong(get.songId);
                                    setState(() {});
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Home();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text('Elimina'),
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
        int macroId = get.macroId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CatDetail(catId, catName, macroId);
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
        '${get.autName} ${get.autSurname.isEmpty ? '' : get.autSurname}',
        style: TextStyle(color: themeProvider.isDarkMode ? kWhite : kBlack),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        int autId = get.autId;
        String autName = get.autName;
        String autSurname = get.autSurname;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail(autId, autName, autSurname);
            },
          ),
        );
      },
    );
  }
}
