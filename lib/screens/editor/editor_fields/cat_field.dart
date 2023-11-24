import 'package:flutter/material.dart';

import '/components/drop_list.dart';
import '/data/queries.dart';

import '../editor.dart';

class CatFields extends StatefulWidget {
  const CatFields({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  CatFieldsState createState() => CatFieldsState();
}

class CatFieldsState extends State<CatFields> {
  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return DropList(
      future: query.getAllCat(),
      icon: Icons.sell,
      label: EditorState.additionalCatFieldList.isEmpty
          ? 'Categoria'
          : 'Categoria #${widget.index + 1}',
      from: 'Categoria',
      message: 'Nessuna categoria trovata',
      index: widget.index,
      myLog:
          'catList: ${EditorState.catList.toString()}\nmacroList: ${EditorState.macroList.toString()}',
      multipleFieldsValidator:
          'Seleziona anche la categoria #${widget.index + 1} o rimuovila!',
      singleFieldValidator: 'Seleziona una categoria!',
    );
  }
}
