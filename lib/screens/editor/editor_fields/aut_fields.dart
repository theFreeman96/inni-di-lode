import 'package:flutter/material.dart';

import '../editor.dart';
import '/components/drop_list.dart';
import '/data/queries.dart';

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
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    return FutureBuilder(
      future: query.getAllAut(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Nessun autore trovato'),
          );
        } else {
          return DropList(
            selectedValue: selectedValue,
            icon: Icons.person,
            label: EditorState.additionalAutFieldList.isEmpty
                ? 'Autore'
                : 'Autore #${widget.index + 1}',
            items: snapshot.data!.map<DropdownMenuItem<String>>(
              (get) {
                return DropdownMenuItem<String>(
                  value:
                      '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                  onTap: () {
                    EditorState.autList[widget.index] = get.id;
                  },
                  child: Text(
                    '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            validator: (value) {
              if (widget.index != 0 && selectedValue == null) {
                return 'Seleziona anche l\'autore #${widget.index + 1} o rimuovilo!';
              } else if (selectedValue == null || selectedValue!.isEmpty) {
                return 'Seleziona un autore!';
              }
              return null;
            },
          );
        }
      },
    );
  }
}
