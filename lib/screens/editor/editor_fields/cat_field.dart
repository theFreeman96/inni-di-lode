import 'package:flutter/material.dart';

import '/data/queries.dart';

import 'drop_list.dart';
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
  late String catHint;

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    catHint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return DropList(
      future: query.getAllCat(),
      hint: catHint,
      icon: Icons.sell,
      label: EditorState.additionalCatFieldList.isEmpty
          ? 'Categoria'
          : 'Categoria #${widget.index + 1}',
      index: widget.index,
      from: 'Categoria',
      state: setState,
      mylog:
          'catList: ${EditorState.catList.toString()}\nmacroList: ${EditorState.macroList.toString()}',
      validator1:
          'Seleziona anche la categoria #${widget.index + 1} o rimuovila!',
      validator2: 'Seleziona una categoria!',
      message: 'Nessuna categoria trovata',
    );
  }
}
