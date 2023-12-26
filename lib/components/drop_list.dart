import 'dart:developer';

import 'package:flutter/material.dart';

import '/utilities/constants.dart';

import '../screens/editor/editor.dart';

class DropList extends StatefulWidget {
  const DropList({
    Key? key,
    required this.future,
    required this.icon,
    required this.label,
    required this.from,
    required this.message,
    this.index,
    this.myLog,
    this.multipleFieldsValidator,
    this.singleFieldValidator,
  }) : super(key: key);

  final Future<List?> future;
  final IconData icon;
  final String label;
  final String from;
  final String message;
  final int? index;
  final String? myLog;
  final String? multipleFieldsValidator;
  final String? singleFieldValidator;

  @override
  State<DropList> createState() => DropListState();
}

class DropListState extends State<DropList> {
  late String hint;

  @override
  void initState() {
    hint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? DropdownButtonFormField<String>(
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: kDefaultPadding / 3),
                  child: Icon(Icons.arrow_drop_down),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                hint: Text(hint),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: Icon(
                    widget.icon,
                    color: kLightGrey,
                  ),
                  labelText: widget.label,
                  alignLabelWithHint: true,
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return widget.from == 'Categoria'
                      ? DropdownMenuItem<String>(
                          value: get.name,
                          onTap: () {
                            if (widget.index != null) {
                              EditorState.catList[widget.index!] = get.id;
                              EditorState.macroList[widget.index!] =
                                  get.macro_id;
                            }
                          },
                          child: Text(get.name),
                        )
                      : DropdownMenuItem<String>(
                          value:
                              '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                          onTap: () {
                            if (widget.index != null) {
                              EditorState.autList[widget.index!] = get.id;
                            }
                          },
                          child: Text(
                              '${get.name} ${get.surname.isEmpty ? '' : get.surname}'),
                        );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    hint = value!;
                    if (widget.myLog != null) {
                      log(widget.myLog!);
                    }
                  });
                },
                validator: (value) {
                  if (widget.index != 0 && value == null) {
                    return widget.multipleFieldsValidator;
                  } else if (value == null || value.isEmpty) {
                    return widget.singleFieldValidator;
                  }
                  return null;
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
