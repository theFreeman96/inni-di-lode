import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '/components/aut_dialog.dart';
import '/components/cat_dialog.dart';
import '/components/empty_scaffold.dart';
import '/components/theme_switch.dart';
import '/data/queries.dart';
import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';
import 'editor_fields/additional_fields_buttons.dart';
import 'editor_fields/aut_fields.dart';
import 'editor_fields/cat_fields.dart';
import 'editor_fields/lyrics_field.dart';
import 'editor_fields/title_field.dart';
import 'editor_fields/verse_tag.dart';
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

  static List<int> additionalAutFieldList = [];
  static List<int> autList = [0, 0, 0];

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
      future: query.getAllSongs(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return EmptyScaffold(
            body: Text(
              'Errore: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        } else {
          final newSongId = !snapshot.hasData || snapshot.data!.isEmpty
              ? 1
              : snapshot.data.length + 1;
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
                              child: Text(
                                widget.songId != null
                                    ? widget.songId.toString()
                                    : newSongId.toString(),
                              ),
                            ),
                          ),
                          TitleField(
                            controller: titleController,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding,
                        ),
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
                          border: Border.all(
                            color: kLightGrey,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            kDefaultPadding,
                          ),
                          child: Column(
                            children: [
                              ...buildFieldRow(
                                additionalCatFieldList,
                                'categoria',
                                catList,
                              ),
                              TextButton.icon(
                                icon: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 15,
                                      color: themeProvider.isDarkMode
                                          ? kWhite
                                          : kBlack,
                                    ),
                                    Icon(
                                      Icons.sell,
                                      color: themeProvider.isDarkMode
                                          ? kWhite
                                          : kBlack,
                                    ),
                                  ],
                                ),
                                label: Text(
                                  'Crea nuova categoria',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.isDarkMode
                                        ? kWhite
                                        : kBlack,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CatDialog(
                                        state: setState,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kLightGrey,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              kDefaultPadding,
                            ),
                            child: Column(
                              children: [
                                ...buildFieldRow(
                                  additionalAutFieldList,
                                  'autore',
                                  autList,
                                ),
                                TextButton.icon(
                                  icon: Icon(
                                    Icons.person_add,
                                    color: themeProvider.isDarkMode
                                        ? kWhite
                                        : kBlack,
                                  ),
                                  label: Text(
                                    'Crea nuovo autore',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.isDarkMode
                                          ? kWhite
                                          : kBlack,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AutDialog(
                                          state: setState,
                                        );
                                      },
                                    );
                                  },
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
        }
      },
    );
  }

  List<Widget> buildFieldRow(
    List<int> additionalFieldsList,
    String tooltip,
    List<int> list,
  ) {
    List<Widget> fieldsList = [];
    for (int i = 0; i <= additionalFieldsList.length; i++) {
      fieldsList.add(
        Padding(
          padding: const EdgeInsets.only(
            bottom: kDefaultPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: tooltip == 'categoria'
                    ? CatFields(index: i)
                    : AutFields(index: i),
              ),
              additionalFieldsList.isEmpty
                  ? AdditionalFieldsButtons(
                      add: i == 0,
                      index: i,
                      tooltip: tooltip,
                      additionalFieldsList: additionalFieldsList,
                      list: list,
                      state: setState,
                    )
                  : i == 0
                      ? const SizedBox()
                      : i != 0 && additionalFieldsList.length == 1
                          ? Row(
                              children: [
                                AdditionalFieldsButtons(
                                  add: true,
                                  index: i,
                                  tooltip: tooltip,
                                  additionalFieldsList: additionalFieldsList,
                                  list: list,
                                  state: setState,
                                ),
                                AdditionalFieldsButtons(
                                  add: false,
                                  index: 0,
                                  tooltip: tooltip,
                                  additionalFieldsList: additionalFieldsList,
                                  list: list,
                                  state: setState,
                                )
                              ],
                            )
                          : i == 2 && additionalFieldsList.length == 2
                              ? AdditionalFieldsButtons(
                                  add: false,
                                  index: 0,
                                  tooltip: tooltip,
                                  additionalFieldsList: additionalFieldsList,
                                  list: list,
                                  state: setState,
                                )
                              : const SizedBox(),
            ],
          ),
        ),
      );
    }
    return fieldsList;
  }
}
