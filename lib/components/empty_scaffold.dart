import 'package:flutter/material.dart';
import 'package:inni_di_lode/components/theme_switch.dart';

class EmptyScaffold extends StatelessWidget {
  const EmptyScaffold({
    Key? key,
    required this.body,
  }) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          tooltip: 'Indietro',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        actions: const [
          ThemeSwitch(),
        ],
      ),
      body: Center(
        child: body,
      ),
    );
  }
}
