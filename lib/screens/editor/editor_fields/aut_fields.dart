import 'package:flutter/material.dart';

import '/components/drop_list.dart';
import '/data/queries.dart';

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
  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return DropList(
      future: query.getAllAut(),
      icon: Icons.person,
      label: EditorState.additionalAutFieldList.isEmpty
          ? 'Autore'
          : 'Autore #${widget.index + 1}',
      from: 'Autore',
      message: 'Nessun autore trovato',
      index: widget.index,
      myLog: 'autList: ${EditorState.autList.toString()}',
      multipleFieldsValidator:
          'Seleziona anche l\'autore #${widget.index + 1} o rimuovilo!',
      singleFieldValidator: 'Seleziona un autore!',
    );
  }
}
