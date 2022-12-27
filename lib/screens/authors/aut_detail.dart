import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/constants.dart';
import '../../theme/theme_provider.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import '/screens/songs/songs_detail.dart';
import '../editor/new_song_page.dart';
import '../home.dart';

class AutDetail extends StatefulWidget {
  final int autId;
  final String autName;
  final String autSurname;
  const AutDetail(this.autId, this.autName, this.autSurname, {Key? key})
      : super(key: key);
  @override
  State<AutDetail> createState() => _AutDetailState();
}

class _AutDetailState extends State<AutDetail> {
  final ScrollController scrollController = ScrollController();
  final QueryCtr query = QueryCtr();

  final editAutKey = GlobalKey<FormState>();
  late TextEditingController autNameController;
  late TextEditingController autSurnameController;

  get id => widget.autId;

  @override
  void initState() {
    autNameController = TextEditingController(text: widget.autName);
    autSurnameController = TextEditingController(text: widget.autSurname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Testi di ${widget.autName} ${widget.autSurname}'),
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
              visible: id > 58 ? true : false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note),
                    tooltip: 'Modifica autore',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text('Modifica autore'),
                            content: Form(
                              key: editAutKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPadding),
                                    child: TextFormField(
                                      controller: autNameController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: const InputDecoration(
                                        labelText: 'Nome',
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
                                  TextFormField(
                                    controller: autSurnameController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                      labelText: 'Cognome (facoltativo)',
                                      prefixIcon: Icon(
                                        Icons.edit,
                                        color: kLightGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Annulla');
                                  autNameController.clear();
                                  autSurnameController.clear();
                                },
                                child: const Text('Annulla'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (editAutKey.currentState!.validate()) {
                                    query.updateAut(
                                        autNameController.text,
                                        autSurnameController.text,
                                        widget.autId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Autore modificato!'),
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
                                    autNameController.clear();
                                    autSurnameController.clear();
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
                    tooltip: 'Elimina autore',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FutureBuilder<List?>(
                            future: query.getSongsByAut(id),
                            initialData: const [],
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? AlertDialog(
                                      scrollable: true,
                                      title: const Text('Errore'),
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
                                                    'Prima di eliminare l\'autore '),
                                            TextSpan(
                                              text:
                                                  '${widget.autName} ${widget.autSurname} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const TextSpan(
                                                text:
                                                    'è necessario dissociare o eliminare i cantici ancora associati.\n\n'),
                                            const TextSpan(
                                              text: 'Come fare?\n',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
                                      title:
                                          const Text('Conferma eliminazione'),
                                      content: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: themeProvider.isDarkMode
                                                ? kWhite
                                                : kBlack,
                                          ),
                                          children: <TextSpan>[
                                            const TextSpan(text: 'L\'autore '),
                                            TextSpan(
                                              text:
                                                  '${widget.autName} ${widget.autSurname} ',
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
                                            query.deleteAut(id);
                                            setState(() {});
                                            Navigator.pop(context, 'Elimina');
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
        body: FutureBuilder<List?>(
          future: query.getSongsByAut(id),
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
                        return buildRow(snapshot.data![i], i);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  )
                : Center(
                    child: id > 58
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Nessun cantico trovato',
                                  style: TextStyle(fontSize: 20.0)),
                              TextButton.icon(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const NewSongPage();
                                      },
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_circle,
                                    color: themeProvider.isDarkMode
                                        ? kPrimaryLightColor
                                        : kPrimaryColor),
                                label: Text(
                                  'Aggiungi cantico',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.isDarkMode
                                          ? kWhite
                                          : kBlack),
                                ),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator(),
                  );
          },
        ),
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
              return SongsDetail(index: i, from: 'Author', id: id);
            },
          ),
        );
      },
    );
  }
}
