import 'package:flutter/material.dart';

class AdditionalFieldsButtons extends StatelessWidget {
  const AdditionalFieldsButtons(
      {Key? key,
      required this.add,
      required this.index,
      required this.tooltip,
      required this.additionalFieldsList,
      required this.list,
      required this.state,
      required})
      : super(key: key);

  final bool add;
  final int index;
  final String tooltip;
  final List<int> additionalFieldsList;
  final List<int> list;
  final dynamic state;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(add ? Icons.add_circle : Icons.remove_circle),
      color: add ? Colors.green : Colors.red,
      tooltip: add ? 'Aggiungi $tooltip' : 'Rimuovi $tooltip',
      onPressed: () {
        if (add) {
          additionalFieldsList.insert(index, index);
        } else {
          additionalFieldsList.removeAt(index);
          if (additionalFieldsList.isEmpty) {
            list[1] = 0;
          }
          if (additionalFieldsList.length == 1) {
            list[2] = 0;
          }
        }
        state(() {});
      },
    );
  }
}
