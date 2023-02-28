import 'dart:developer';

import 'package:flutter/material.dart';

import '/utilities/constants.dart';
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
    return FutureBuilder(
      future: query.getAllCat(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? DropdownButtonFormField<String>(
                key: widget.key,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: kDefaultPadding / 3),
                  child: Icon(Icons.arrow_drop_down),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                hint: Text(catHint),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: const Icon(
                    Icons.sell,
                    color: kLightGrey,
                  ),
                  labelText: EditorState.additionalCatFieldList.isEmpty
                      ? 'Categoria'
                      : 'Categoria #${widget.index + 1}',
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return DropdownMenuItem<String>(
                    value: get.name,
                    onTap: () {
                      EditorState.catList[widget.index] = get.id;
                      EditorState.macroList[widget.index] = get.macro_id;
                    },
                    child: Text(get.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    catHint = value!;
                    log('catList: ${EditorState.catList.toString()}');
                    log('macroList: ${EditorState.macroList.toString()}');
                  });
                },
                validator: (value) {
                  if (widget.index != 0 && value == null) {
                    return 'Seleziona anche la categoria #${widget.index + 1} o rimuovila!';
                  } else if (value == null || value.isEmpty) {
                    return 'Seleziona una categoria!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessuna categoria trovata',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
