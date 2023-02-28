import 'package:flutter/material.dart';

import '/data/queries.dart';

import 'drop_list.dart';
import '../editor.dart';

class AutFields extends StatefulWidget {
  const AutFields({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  AutFieldsState createState() => AutFieldsState();
}

class AutFieldsState extends State<AutFields> {
  late String autHint;

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    autHint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return DropList(
      future: query.getAllAut(),
      hint: autHint,
      icon: Icons.person,
      label: EditorState.additionalAutFieldList.isEmpty
          ? 'Autore'
          : 'Autore #${widget.index + 1}',
      index: widget.index,
      from: 'Autore',
      state: setState,
      mylog: 'autList: ${EditorState.autList.toString()}',
      validator1: 'Seleziona anche l\'autore #${widget.index + 1} o rimuovilo!',
      validator2: 'Seleziona un autore!',
      message: 'Nessun autore trovato',
    );
  }
}
