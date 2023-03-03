import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import '/components/theme_switch.dart';
import '/data/queries.dart';

import '../home/home.dart';
import 'editor_fields/title_field.dart';
import 'editor_dialogs/verse_tag.dart';
import 'editor_fields/lyrics_field.dart';
import 'editor_fields/cat_field.dart';
import 'editor_dialogs/cat_dialog.dart';
import 'editor_fields/aut_fields.dart';
import 'editor_dialogs/aut_dialog.dart';
import 'submit.dart';

class Editor extends StatefulWidget {
  const Editor({
    Key? key,
    this.songId,
    this.songTitle,
    this.songText,
  }) : super(key: key);

  final int? songId;
  final String? songTitle;
  final String? songText;

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  final editorKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController textController;
  late FocusNode textFocusNode;

  static List<int> additionalCatFieldList = [];
  static List<int> macroList = [0, 0, 0];
  static List<int> catList = [0, 0, 0];

  final newCatKey = GlobalKey<FormState>();
  final catController = TextEditingController();

  static List<int> additionalAutFieldList = [];
  static List<int> autList = [0, 0, 0];

  final newAutKey = GlobalKey<FormState>();
  final autNameController = TextEditingController();
  final autSurnameController = TextEditingController();

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.songTitle);
    textController = TextEditingController(
      text: widget.songText != null
          ? widget.songText!
              .replaceAll('<ol>', '')
              .replaceAll('</ol>', '')
              .replaceAll('<li>', '---Strofa---\n')
              .replaceAll('<b>Coro:</b>', '---Coro---')
              .replaceAll('<b>Bridge:</b>', '---Bridge---')
              .replaceAll('<b>Finale:</b>', '---Finale---')
              .replaceAll('<br>', '\n')
          : '',
    );
    textFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    titleController.dispose();
    textController.dispose();
    additionalCatFieldList.clear();
    additionalAutFieldList.clear();
    macroList.clear();
    catList.clear();
    autList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: query.getAllSongs(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
              actions: const [
                ThemeSwitch(),
              ],
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final newSongId = snapshot.data.length + 1;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              widget.songId != null ? 'Modifica Cantico' : 'Nuovo cantico',
            ),
            leading: IconButton(
              tooltip: 'Indietro',
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Home();
                    },
                  ),
                );
                additionalCatFieldList.clear();
                additionalAutFieldList.clear();
                macroList = [0, 0, 0];
                catList = [0, 0, 0];
                autList = [0, 0, 0];
              },
            ),
            actions: const [
              ThemeSwitch(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Conferma',
            onPressed: () {
              submit(
                context: context,
                widget: widget,
                editorKey: editorKey,
                query: query,
                newSongId: newSongId,
                titleController: titleController,
                textController: textController,
                macroList: macroList,
                catList: catList,
                autList: autList,
                additionalCatFieldList: additionalCatFieldList,
                additionalAutFieldList: additionalAutFieldList,
              );
            },
            child: const Icon(Icons.send),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Form(
                key: editorKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: kDefaultPadding),
                          child: CircleAvatar(
                            child: Text(widget.songId != null
                                ? widget.songId.toString()
                                : newSongId.toString()),
                          ),
                        ),
                        TitleField(
                          controller: titleController,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Column(
                        children: [
                          VerseTag(
                            focus: textFocusNode,
                            controller: textController,
                          ),
                          LyricsField(
                            controller: textController,
                            focus: textFocusNode,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kLightGrey, width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          children: [
                            ...getCatFields(),
                            CatDialog(
                              newKey: newCatKey,
                              controller: catController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kLightGrey, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Column(
                            children: [
                              ...getAutFields(),
                              AutDialog(
                                newKey: newAutKey,
                                nameController: autNameController,
                                surController: autSurnameController,
                                state: setState,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding * 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> getCatFields() {
    List<Widget> catFieldsList = [];
    for (int i = 0; i <= additionalCatFieldList.length; i++) {
      catFieldsList.add(
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          child: Row(
            children: [
              Expanded(child: CatFields(index: i)),
              additionalCatFieldList.isEmpty
                  ? catRemoveButton(i == 0, i)
                  : i == 0
                      ? const SizedBox()
                      : i != 0 && additionalCatFieldList.length == 1
                          ? Row(
                              children: [
                                catRemoveButton(true, i),
                                catRemoveButton(false, 0)
                              ],
                            )
                          : i == 2 && additionalCatFieldList.length == 2
                              ? catRemoveButton(false, 0)
                              : const SizedBox(),
            ],
          ),
        ),
      );
    }
    return catFieldsList;
  }

  Widget catRemoveButton(bool add, int index) {
    return IconButton(
      icon: Icon((add) ? Icons.add_circle : Icons.remove_circle),
      color: (add) ? Colors.green : Colors.red,
      tooltip: (add) ? 'Aggiungi categoria' : 'Rimuovi categoria',
      onPressed: () {
        if (add) {
          additionalCatFieldList.insert(index, index);
        } else {
          additionalCatFieldList.removeAt(index);
          if (additionalCatFieldList.isEmpty) {
            catList[1] = 0;
          }
          if (additionalCatFieldList.length == 1) {
            catList[2] = 0;
          }
        }
        setState(() {});
      },
    );
  }

  List<Widget> getAutFields() {
    List<Widget> autFieldsList = [];
    for (int i = 0; i <= additionalAutFieldList.length; i++) {
      autFieldsList.add(
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          child: Row(
            children: [
              Expanded(child: AutFields(index: i)),
              additionalAutFieldList.isEmpty
                  ? autRemoveButton(i == 0, i)
                  : i == 0
                      ? const SizedBox()
                      : i != 0 && additionalAutFieldList.length == 1
                          ? Row(
                              children: [
                                autRemoveButton(true, i),
                                autRemoveButton(false, 0)
                              ],
                            )
                          : i == 2 && additionalAutFieldList.length == 2
                              ? autRemoveButton(false, 0)
                              : const SizedBox(),
            ],
          ),
        ),
      );
    }
    return autFieldsList;
  }

  Widget autRemoveButton(bool add, int index) {
    return IconButton(
      icon: Icon((add) ? Icons.add_circle : Icons.remove_circle),
      color: (add) ? Colors.green : Colors.red,
      tooltip: (add) ? 'Aggiungi autore' : 'Rimuovi autore',
      onPressed: () {
        if (add) {
          additionalAutFieldList.insert(index, index);
        } else {
          additionalAutFieldList.removeAt(index);
          if (additionalAutFieldList.isEmpty) {
            autList[1] = 0;
          }
          if (additionalAutFieldList.length == 1) {
            autList[2] = 0;
          }
        }
        setState(() {});
      },
    );
  }
}
