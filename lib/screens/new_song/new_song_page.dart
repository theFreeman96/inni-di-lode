import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inni_di_lode/assets/data/queries.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '/assets/data/models.dart';
import '/theme/constants.dart';
import '/theme/theme_provider.dart';

class ListFieldFormBloc extends FormBloc<String, String> {
  final title = TextFieldBloc(name: 'Titolo');
  final text = ListFieldBloc<VerseFieldBloc, dynamic>(name: 'Testo');
  final cat = SelectFieldBloc(
    items: [
      'Categoria 1',
      'Categoria 2',
      'Categoria 3',
    ],
  );
  final aut = SelectFieldBloc(
    items: [
      'Autore 1',
      'Autore 2',
      'Autore 3',
    ],
  );

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        title,
        text,
        cat,
        aut,
      ],
    );
  }

  void addVerse() {
    text.addFieldBloc(VerseFieldBloc(
      name: 'Testo',
      newText: TextFieldBloc(name: 'Strofa'),
    ));
  }

  void removeVerse(int index) {
    text.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    // Insert into database
    QueryCtr().insertSong(
        title.value,
        '<ol>${text.value.map<Verse>((memberField) {
              return Verse(
                text: memberField.newText.value,
              );
            }).map((e) => e.text).toList().join('<br><br>').replaceAll('\n', '<br>')}</ol>',
        1,
        0);

    // Without serialization
    final newSongsV1 = NewSongs(
      title: title.value,
      text: text.value.map<Verse>((memberField) {
        return Verse(
          text: memberField.newText.value,
        );
      }).toList(),
    );

    debugPrint('newSongsV1');
    debugPrint(newSongsV1.toMap().toString());

    // With Serialization
    final newSongsV2 = NewSongs.fromMap(state.toJson());

    debugPrint('newSongsV2');
    debugPrint(newSongsV2.toMap().toString());

    emitSuccess(
      canSubmitAgain: true,
      successResponse: const JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class VerseFieldBloc extends GroupFieldBloc {
  final TextFieldBloc newText;

  VerseFieldBloc({
    required this.newText,
    String? name,
  }) : super(name: name, fieldBlocs: [newText]);
}

class Verse {
  String? text;

  Verse({this.text});

  Verse.fromMap(Map<String, dynamic> map) {
    text = map['Strofa'];
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['Strofa'] = text;
    return data;
  }
}

class NewSongPage extends StatelessWidget {
  const NewSongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  borderSide: BorderSide(
                      color: themeProvider.isDarkMode ? kWhite : kLightGrey,
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
                labelStyle: TextStyle(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey),
              ),
            ),
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  elevation: 0.0,
                  title: const Text('Nuovo Cantico'),
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
                floatingActionButton: FloatingActionButton(
                  onPressed: formBloc.submit,
                  child: const Icon(Icons.send),
                ),
                body: FormBlocListener<ListFieldFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: SingleChildScrollView(
                          child: Text(state.successResponse!)),
                      duration: const Duration(milliseconds: 1500),
                    ));
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse!)));
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          textFieldBloc: formBloc.title,
                          decoration: const InputDecoration(
                            labelText: 'Titolo del Cantico',
                            prefixIcon: Icon(
                              Icons.edit,
                              color: kLightGrey,
                            ),
                          ),
                        ),
                        BlocBuilder<ListFieldBloc<VerseFieldBloc, dynamic>,
                            ListFieldBlocState<VerseFieldBloc, dynamic>>(
                          bloc: formBloc.text,
                          builder: (context, state) {
                            if (state.fieldBlocs.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.fieldBlocs.length,
                                itemBuilder: (context, i) {
                                  return VerseCard(
                                    verseIndex: i,
                                    verseField: state.fieldBlocs[i],
                                    onRemoveVerse: () =>
                                        formBloc.removeVerse(i),
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle),
                            label: const Text('Aggiungi Testo'),
                            onPressed: formBloc.addVerse,
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          selectFieldBloc: formBloc.cat,
                          decoration: const InputDecoration(
                            labelText: 'Categoria',
                            prefixIcon: Icon(
                              Icons.sell,
                              color: kLightGrey,
                            ),
                          ),
                          itemBuilder: (context, value) => FieldItem(
                            child: Text(value),
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          selectFieldBloc: formBloc.aut,
                          decoration: const InputDecoration(
                            labelText: 'Autore',
                            prefixIcon: Icon(
                              Icons.person,
                              color: kLightGrey,
                            ),
                          ),
                          itemBuilder: (context, value) => FieldItem(
                            child: Text(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerseCard extends StatelessWidget {
  final int verseIndex;
  final VerseFieldBloc verseField;

  final VoidCallback onRemoveVerse;

  const VerseCard({
    Key? key,
    required this.verseIndex,
    required this.verseField,
    required this.onRemoveVerse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 3, horizontal: kDefaultPadding),
      child: Padding(
        padding: const EdgeInsets.only(
            right: kDefaultPadding, left: kDefaultPadding),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Strofa #${verseIndex + 1}',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveVerse,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: verseField.newText,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Testo',
                prefixIcon: Icon(
                  Icons.notes,
                  color: kLightGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
