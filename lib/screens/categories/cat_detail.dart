import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/constants.dart';
import '../../theme/theme_provider.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import '/screens/songs/songs_detail.dart';
import '../editor/new_song_page.dart';

class CatDetail extends StatefulWidget {
  final int catId;
  final String catName;
  final int macroId;
  const CatDetail(this.catId, this.catName, this.macroId, {Key? key})
      : super(key: key);
  @override
  State<CatDetail> createState() => _CatDetailState();
}

late int mac;
late String macHint;

class _CatDetailState extends State<CatDetail> {
  final ScrollController scrollController = ScrollController();
  final QueryCtr query = QueryCtr();

  final editCatKey = GlobalKey<FormState>();
  late TextEditingController catController;

  get id => widget.catId;

  @override
  void initState() {
    catController = TextEditingController(text: widget.catName);
    mac = widget.macroId;
    macHint = 'Seleziona una Categoria';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.catName),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Visibility(
              visible: id > 32 ? true : false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note),
                    tooltip: 'Modifica Categoria',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: InputDecorationTheme(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkMode
                                          ? kWhite
                                          : kLightGrey,
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkMode
                                          ? kPrimaryLightColor
                                          : kPrimaryColor,
                                      width: 2.0),
                                ),
                                errorStyle: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? Colors.redAccent
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkMode
                                          ? Colors.redAccent
                                          : Colors.red,
                                      width: 1.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkMode
                                          ? Colors.redAccent
                                          : Colors.red,
                                      width: 2.0),
                                ),
                                labelStyle: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? kWhite
                                        : kLightGrey),
                              ),
                            ),
                            child: AlertDialog(
                              scrollable: true,
                              title: const Text('Modifica Categoria'),
                              content: Form(
                                key: editCatKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: kDefaultPadding),
                                      child: TextFormField(
                                        controller: catController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: const InputDecoration(
                                          labelText: 'Nome Categoria',
                                          prefixIcon: Icon(
                                            Icons.edit,
                                            color: kLightGrey,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Inserisci il Nome!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: query.getAllMacroCat(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        return snapshot.hasData
                                            ? DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                icon: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          kDefaultPadding / 3),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(25.0),
                                                ),
                                                hint: Text(macHint),
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: kDefaultPadding,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.sell,
                                                    color: kLightGrey,
                                                  ),
                                                  labelText: 'Macrocategoria',
                                                ),
                                                items: snapshot.data!.map<
                                                    DropdownMenuItem<
                                                        String>>((get) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: get.macroName,
                                                    onTap: () {
                                                      mac = get.macroId;
                                                    },
                                                    child: Text(get.macroName),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    macHint = value!;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Seleziona una Macrocategoria!';
                                                  }
                                                  return null;
                                                },
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.only(
                                                    top: kDefaultPadding),
                                                child: Text(
                                                  'Nessuna Macrocategoria trovata',
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Annulla');
                                    catController.clear();
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
                                    if (editCatKey.currentState!.validate()) {
                                      query.insertCat(catController.text, mac);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Categoria modificata!'),
                                        ),
                                      );
                                      Navigator.pop(context, 'Conferma');
                                      catController.clear();
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    'Conferma',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkMode
                                            ? Colors.greenAccent
                                            : Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Elimina Categoria',
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
                                  const TextSpan(text: 'La categoria '),
                                  TextSpan(
                                    text: widget.catName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                      text:
                                          ' sarà eliminata definitivamente.\nConfermi?')
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
                                  query.deleteCat(id);
                                  setState(() {});
                                  Navigator.pop(context, 'Elimina');
                                  Navigator.of(context).pop();
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
        body: FutureBuilder<List?>(
          future: query.getSongsByCat(id),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        top: kDefaultPadding * 0.4,
                        bottom: kDefaultPadding,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return buildRow(snapshot.data![i]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  Widget buildRow(Raccolta get) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          get.songId.toString(),
        ),
      ),
      title: Text(get.songTitle),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SongsDetail(songId: get.songId, from: 'Category', id: id);
            },
          ),
        );
      },
    );
  }
}
