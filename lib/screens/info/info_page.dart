import 'package:flutter/material.dart';

import 'info_header.dart';
import 'info_body.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
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
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: InfoHeader(),
                  ),
                  Expanded(
                    child: InfoBody(),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height,
                    child: InfoHeader(),
                  ),
                  Expanded(
                    child: InfoBody(),
                  ),
                ],
              ),
      ),
    );
  }
}
