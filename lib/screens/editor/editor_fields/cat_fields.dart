import 'package:flutter/material.dart';

import '../editor.dart';
import '/components/drop_list.dart';
import '/data/queries.dart';
import '/utilities/error_codes.dart';

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
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    return FutureBuilder(
      future: query.getAllCat(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Errore: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              ErrorCodes.categoriesNotFound,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return DropList(
            selectedValue: selectedValue,
            icon: Icons.sell,
            label: EditorState.additionalCatFieldList.isEmpty
                ? 'Categoria'
                : 'Categoria #${widget.index + 1}',
            items: snapshot.data!.map<DropdownMenuItem<String>>(
              (get) {
                return DropdownMenuItem<String>(
                  value: get.name,
                  onTap: () {
                    if (selectedValue == null) {
                      EditorState.catList[widget.index] = 0;
                      EditorState.macroList[widget.index] = 0;
                    } else {
                      EditorState.catList[widget.index] = get.id;
                      EditorState.macroList[widget.index] = get.macro_id;
                    }
                  },
                  child: Text(get.name),
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
                return 'Seleziona anche la categoria #${widget.index + 1} o rimuovila!';
              } else if (selectedValue == null || selectedValue!.isEmpty) {
                return 'Seleziona una categoria!';
              }
              return null;
            },
          );
        }
      },
    );
  }
}
