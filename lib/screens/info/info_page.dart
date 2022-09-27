import 'package:flutter/material.dart';

import 'info_header.dart';
import 'info_body.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Contatti'),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: orientation == Orientation.portrait
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: mediaQuery.size.height * 0.25,
                    child: const InfoHeader(),
                  ),
                  const Expanded(
                    child: InfoBody(),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    width: mediaQuery.size.width * 0.35,
                    height: mediaQuery.size.height,
                    child: const InfoHeader(),
                  ),
                  const Expanded(
                    child: InfoBody(),
                  ),
                ],
              ),
      ),
    );
  }
}
