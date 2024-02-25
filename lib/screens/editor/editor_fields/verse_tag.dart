import 'package:flutter/material.dart';

class VerseTag extends StatefulWidget {
  const VerseTag({
    Key? key,
    required this.focus,
    required this.controller,
  }) : super(key: key);

  final FocusNode focus;
  final TextEditingController controller;

  @override
  State<VerseTag> createState() => _VerseTagState();
}

class _VerseTagState extends State<VerseTag> {
  late String verseTagHint;
  final List verseTagList = ['Strofa', 'Coro', 'Bridge', 'Finale'];

  @override
  void initState() {
    verseTagHint = 'Strofa';
    super.initState();
  }

  @override
  void dispose() {
    verseTagHint;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Aggiungi     '),
        DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
          hint: Text(verseTagHint),
          items: verseTagList.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
              onTap: () {
                widget.focus.requestFocus();
              },
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              verseTagHint = value!;
              final text = widget.controller.text;
              final selection = widget.controller.selection;
              final cursorPos = widget.controller.selection.base.offset;
              final dashedValue = '---$value---';

              if (cursorPos == 0) {
                final newText = text.replaceRange(
                  selection.start,
                  selection.end,
                  '$dashedValue\n',
                );
                widget.controller.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                    offset: cursorPos + '$dashedValue\n'.length,
                  ),
                );
              } else {
                final newText = text.replaceRange(
                  selection.start,
                  selection.end,
                  '\n\n$dashedValue\n',
                );
                widget.controller.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                    offset: cursorPos + '\n\n$dashedValue\n'.length,
                  ),
                );
              }
            });
          },
        ),
      ],
    );
  }
}
