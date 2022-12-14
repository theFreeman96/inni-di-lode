import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/constants.dart';
import '../../theme/theme_provider.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import '/screens/songs/songs_detail.dart';
import '../editor/new_song_page.dart';

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
    aut = widget.autId;
    autHint = widget.autName;
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
                    tooltip: 'Modifica Autore',
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
                              title: const Text('Modifica Autore'),
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
                                            return 'Inserisci il Nome!';
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
                                        labelText: 'Nome',
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
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Annulla');
                                    autNameController.clear();
                                    autSurnameController.clear();
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
                                    if (editAutKey.currentState!.validate()) {
                                      query.updateAut(
                                          autNameController.text,
                                          autSurnameController.text,
                                          widget.autId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Autore aggiunto!'),
                                        ),
                                      );
                                      Navigator.pop(context, 'Conferma');
                                      autNameController.clear();
                                      autSurnameController.clear();
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
                    tooltip: 'Elimina Autore',
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
                                  const TextSpan(text: 'L\'Autore '),
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
                                  query.deleteAut(id);
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
              return SongsDetail(songId: get.songId, from: 'Author', id: id);
            },
          ),
        );
      },
    );
  }
}
