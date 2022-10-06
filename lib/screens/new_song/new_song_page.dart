import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';

class ListFieldFormBloc extends FormBloc<String, String> {
  final newSongTitle = TextFieldBloc(name: 'Titolo');
  final newVerses = ListFieldBloc<VerseFieldBloc, dynamic>(name: 'Testo');

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [newSongTitle, newVerses],
    );
  }

  void addVerse() {
    newVerses.addFieldBloc(VerseFieldBloc(
      name: 'Testo',
      text: TextFieldBloc(name: 'Strofa'),
    ));
  }

  void removeVerse(int index) {
    newVerses.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    final output = NewSong(
      newSongTitle: newSongTitle.value,
      newVerses: newVerses.value.map<Verse>((verseField) {
        return Verse(
          text: verseField.text.value,
        );
      }).toList(),
    );

    debugPrint('output');
    debugPrint(output.toMap().toString());
  }
}

class VerseFieldBloc extends GroupFieldBloc {
  final TextFieldBloc text;

  VerseFieldBloc({
    required this.text,
    String? name,
  }) : super(name: name, fieldBlocs: [text]);
}

class NewSong {
  String? newSongTitle;
  List<Verse>? newVerses;

  NewSong({this.newSongTitle, this.newVerses});

  NewSong.fromJson(Map<String, dynamic> json) {
    newSongTitle = json['Titolo'];
    if (json['Testo'] != null) {
      newVerses = <Verse>[];
      json['Testo'].forEach((v) {
        newVerses!.add(Verse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Titolo'] = newSongTitle;
    if (newVerses != null) {
      data['Testo'] = newVerses!.map((v) => v).toList();
    }
    return data;
  }
}

class Verse {
  String? text;

  Verse({this.text});

  Verse.fromJson(Map<String, dynamic> json) {
    text = json['Strofa'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Strofa'] = text;
    return data;
  }
}

class NewSongPage extends StatelessWidget {
  const NewSongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
                          textFieldBloc: formBloc.newSongTitle,
                          decoration: const InputDecoration(
                            labelText: 'Titolo del Cantico',
                          ),
                        ),
                        BlocBuilder<ListFieldBloc<VerseFieldBloc, dynamic>,
                            ListFieldBlocState<VerseFieldBloc, dynamic>>(
                          bloc: formBloc.newVerses,
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
              textFieldBloc: verseField.text,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 20,
              decoration: const InputDecoration(
                labelText: 'Testo',
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
