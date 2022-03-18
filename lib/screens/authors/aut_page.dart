import 'package:flutter/material.dart';

import 'aut_header.dart';
import 'aut_body.dart';

class AutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              floating: false,
              pinned: false,
              toolbarHeight: 0.0,
              collapsedHeight: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: AutHeader(),
              ),
            ),
          ];
        },
        body: AutBody(),
      );
    } else {
      return new Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height,
            child: new AutHeader(),
          ),
          Expanded(
            child: new AutBody(),
          ),
        ],
      );
    }
  }
}
