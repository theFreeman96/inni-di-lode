import 'package:flutter/material.dart';

import 'cat_header.dart';
import 'cat_body.dart';

class CatPage extends StatelessWidget {
  const CatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    if (orientation == Orientation.portrait) {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: mediaQuery.size.height * 0.25,
              floating: false,
              pinned: false,
              toolbarHeight: 0.0,
              collapsedHeight: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: const FlexibleSpaceBar(
                background: CatHeader(),
              ),
            ),
          ];
        },
        body: const CatBody(),
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: mediaQuery.size.width * 0.35,
            height: mediaQuery.size.height,
            child: const CatHeader(),
          ),
          const Expanded(
            child: CatBody(),
          ),
        ],
      );
    }
  }
}
