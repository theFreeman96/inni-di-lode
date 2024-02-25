import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '/components/aut_dialog.dart';
import '/components/detail_list.dart';
import '/components/theme_switch.dart';
import '/data/models.dart';
import '/data/queries.dart';
import '/screens/songs/songs_detail.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';
import '/utilities/theme_provider.dart';

class AutDetail extends StatefulWidget {
  const AutDetail({
    Key? key,
    required this.autId,
    required this.autName,
    required this.autSurname,
  }) : super(key: key);

  final int autId;
  final String autName;
  final String autSurname;

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
            'Testi di ${widget.autName} ${widget.autSurname.isEmpty ? '' : widget.autSurname}'),
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
                        return AutDialog(
                          autDialogFormKey: editAutKey,
                          autNameController: autNameController,
                          autSurnameController: autSurnameController,
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
                                                  'Prima di eliminare l\'autore '),
                                          TextSpan(
                                            text:
                                                '${widget.autName} ${widget.autSurname.isEmpty ? '' : '${widget.autSurname} '}',
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
                                      FilledButton(
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
                                          const TextSpan(text: 'L\'autore '),
                                          TextSpan(
                                            text:
                                                '${widget.autName} ${widget.autSurname.isEmpty ? '' : '${widget.autSurname} '}',
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
                                      FilledButton(
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
          const ThemeSwitch(),
        ],
      ),
      body: DetailList(
        context: context,
        future: query.getSongsByAut(id),
        controller: scrollController,
        row: buildRow,
        message: ErrorCodes.songsNotFound,
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
              return SongsDetail(
                index: i,
                from: 'Author',
                id: id,
              );
            },
          ),
        );
      },
    );
  }
}
