import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';
import '/components/list_detail.dart';
import '/data/models.dart';
import '/data/queries.dart';

import '/screens/songs/songs_detail.dart';
import '../home.dart';

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
    macHint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
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
                  tooltip: 'Modifica categoria',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Modifica categoria'),
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
                                      labelText: 'Nome categoria',
                                      prefixIcon: Icon(
                                        Icons.edit,
                                        color: kLightGrey,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Inserisci il nome!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                FutureBuilder(
                                  future: query.getAllMacroCat(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    return snapshot.hasData
                                        ? DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            icon: const Padding(
                                              padding: EdgeInsets.only(
                                                  right: kDefaultPadding / 3),
                                              child:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(25.0),
                                            ),
                                            hint: Text(macHint),
                                            decoration: const InputDecoration(
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
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<String>>(
                                                    (get) {
                                              return DropdownMenuItem<String>(
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
                                                return 'Seleziona una macrocategoria!';
                                              }
                                              return null;
                                            },
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(
                                                top: kDefaultPadding),
                                            child: Text(
                                              'Nessuna macrocategoria trovata',
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
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context, 'Annulla');
                                catController.clear();
                              },
                              child: const Text('Annulla'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (editCatKey.currentState!.validate()) {
                                  query.updateCat(
                                      catController.text, mac, widget.catId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Categoria modificata!'),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const Home();
                                      },
                                    ),
                                  );
                                  catController.clear();
                                  setState(() {});
                                }
                              },
                              child: const Text('Conferma'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Elimina categoria',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder<List?>(
                          future: query.getSongsByCat(id),
                          initialData: const [],
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? AlertDialog(
                                    scrollable: true,
                                    title: const Text('Errore!'),
                                    content: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: themeProvider.isDarkMode
                                              ? kWhite
                                              : kBlack,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text:
                                                  'Prima di eliminare la categoria '),
                                          TextSpan(
                                            text: '${widget.catName} ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(
                                              text:
                                                  'è necessario dissociare o eliminare i cantici ancora associati.\n\n'),
                                          const TextSpan(
                                              text:
                                                  'Nel fondo della pagina di ciascun cantico selezionare una delle seguenti opzioni:\n'),
                                          const WidgetSpan(
                                            child: Icon(Icons.edit_note),
                                          ),
                                          const TextSpan(
                                              text: 'Modifica cantico\n'),
                                          const WidgetSpan(
                                            child: Icon(Icons.delete),
                                          ),
                                          const TextSpan(
                                              text: 'Elimina cantico'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Ho capito');
                                        },
                                        child: const Text('Ho capito'),
                                      ),
                                    ],
                                  )
                                : AlertDialog(
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
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Annulla');
                                        },
                                        child: const Text('Annulla'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          query.deleteCat(id);
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
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: buildDetailList(
        context: context,
        future: query.getSongsByCat(id),
        controller: scrollController,
        row: buildRow,
        condition: id > 32,
      ),
    );
  }

  Widget buildRow(Raccolta get, int i) {
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
              return SongsDetail(index: i, from: 'Category', id: id);
            },
          ),
        );
      },
    );
  }
}
