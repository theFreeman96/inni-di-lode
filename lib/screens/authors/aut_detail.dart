import 'package:flutter/material.dart';

import '../home/home.dart';
import '/components/aut_dialog.dart';
import '/components/delete_dialog.dart';
import '/components/detail_list.dart';
import '/components/error_dialog.dart';
import '/components/theme_switch.dart';
import '/data/models.dart';
import '/data/queries.dart';
import '/screens/songs/songs_detail.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';

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
                          autId: widget.autId,
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Errore: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return DeleteDialog(
                                itemType: 'L\'autore',
                                itemToDelete:
                                    '${widget.autName} ${widget.autSurname}',
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
                              );
                            } else {
                              return ErrorDialog(
                                itemType: 'l\'autore',
                                itemToDelete:
                                    '${widget.autName} ${widget.autSurname}',
                              );
                            }
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
        notFoundMessage: ErrorCodes.songsNotFound,
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
