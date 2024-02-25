import 'package:flutter/material.dart';

import '../home/home.dart';
import '/components/cat_dialog.dart';
import '/components/delete_dialog.dart';
import '/components/detail_list.dart';
import '/components/error_dialog.dart';
import '/components/theme_switch.dart';
import '/data/models.dart';
import '/data/queries.dart';
import '/screens/songs/songs_detail.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';

class CatDetail extends StatefulWidget {
  const CatDetail({
    Key? key,
    required this.catId,
    required this.catName,
    required this.macroId,
    required this.macroName,
  }) : super(key: key);

  final int catId;
  final String catName;
  final int macroId;
  final String macroName;

  @override
  State<CatDetail> createState() => _CatDetailState();
}

late int macroId;
late String macroName;

class _CatDetailState extends State<CatDetail> {
  final ScrollController scrollController = ScrollController();
  final QueryCtr query = QueryCtr();

  final editCatKey = GlobalKey<FormState>();
  late TextEditingController catController;

  get id => widget.catId;

  @override
  void initState() {
    catController = TextEditingController(text: widget.catName);
    macroId = widget.macroId;
    macroName = widget.macroName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        return CatDialog(
                          catDialogFormKey: editCatKey,
                          catController: catController,
                          catId: widget.catId,
                          state: setState,
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
                                itemType: 'La categoria',
                                itemToDelete: widget.catName,
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
                              );
                            } else {
                              return ErrorDialog(
                                itemType: 'la categoria',
                                itemToDelete: widget.catName,
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
        future: query.getSongsByCat(id),
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
                from: 'Category',
                id: id,
              );
            },
          ),
        );
      },
    );
  }
}
