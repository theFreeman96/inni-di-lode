import 'package:flutter/material.dart';

import 'cat_header.dart';
import 'cat_body.dart';

class CatPage extends StatelessWidget {
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
                background: CatHeader(),
              ),
            ),
          ];
        },
        body: CatBody(),
      );
    } else {
      return new Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height,
            child: new CatHeader(),
          ),
          Expanded(
            child: new CatBody(),
          ),
        ],
      );
    }
  }
}
