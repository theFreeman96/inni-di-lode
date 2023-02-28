import 'dart:developer';

import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class DropList extends StatelessWidget {
  DropList({
    Key? key,
    required this.future,
    required this.hint,
    required this.icon,
    required this.label,
    required this.index,
    required this.from,
    required this.classState,
    required this.state,
    required this.mylog,
    required this.validator1,
    required this.validator2,
    required this.message,
  }) : super(key: key);

  final Future<List?> future;
  late String hint;
  final IconData icon;
  final String label;
  final String from;
  final dynamic classState;
  final int index;
  final dynamic state;
  final String mylog;
  final String validator1;
  final String validator2;
  final String message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
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
                    icon,
                    color: kLightGrey,
                  ),
                  labelText: label,
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return from == 'Categoria'
                      ? DropdownMenuItem<String>(
                          value: get.name,
                          onTap: () {
                            classState.catList[index] = get.id;
                            classState.macroList[index] = get.macro_id;
                          },
                          child: Text(get.name),
                        )
                      : DropdownMenuItem<String>(
                          value:
                              '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                          onTap: () {
                            classState.autList[index] = get.id;
                          },
                          child: Text(
                              '${get.name} ${get.surname.isEmpty ? '' : get.surname}'),
                        );
                }).toList(),
                onChanged: (value) {
                  state(() {
                    hint = value!;
                    log(mylog);
                  });
                },
                validator: (value) {
                  if (index != 0 && value == null) {
                    return validator1;
                  } else if (value == null || value.isEmpty) {
                    return validator2;
                  }
                  return null;
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
