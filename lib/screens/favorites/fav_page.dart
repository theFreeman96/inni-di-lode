import 'package:flutter/material.dart';

import 'fav_header.dart';
import 'fav_body.dart';

class FavPage extends StatelessWidget {
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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: FavHeader(),
              ),
            ),
          ];
        },
        body: FavBody(),
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height,
            child: FavHeader(),
          ),
          Expanded(
            child: FavBody(),
          ),
        ],
      );
    }
  }
}
