import 'package:flutter/material.dart';

import 'info_header.dart';
import 'info_body.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Contatti'),
            leading: IconButton(
              tooltip: 'Indietro',
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: InfoHeader(),
              ),
              Expanded(
                child: InfoBody(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Contatti'),
          ),
          body: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height,
                child: new InfoHeader(),
              ),
              Expanded(
                child: new InfoBody(),
              ),
            ],
          ),
        ),
      );
    }
  }
}
