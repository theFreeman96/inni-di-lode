import 'dart:developer';

import 'package:flutter/material.dart';

import '/utilities/constants.dart';
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
    return FutureBuilder(
      future: query.getAllAut(),
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
                hint: Text(autHint),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: kLightGrey,
                  ),
                  labelText: EditorState.additionalAutFieldList.isEmpty
                      ? 'Autore'
                      : 'Autore #${widget.index + 1}',
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return DropdownMenuItem<String>(
                    value:
                        '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                    onTap: () {
                      EditorState.autList[widget.index] = get.id;
                    },
                    child: Text(
                        '${get.name} ${get.surname.isEmpty ? '' : get.surname}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    autHint = value!;
                    log('autList: ${EditorState.autList.toString()}');
                  });
                },
                validator: (value) {
                  if (widget.index != 0 && value == null) {
                    return 'Seleziona anche l\'autore #${widget.index + 1} o rimuovilo!';
                  } else if (value == null || value.isEmpty) {
                    return 'Seleziona un autore!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessun autore trovato',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
