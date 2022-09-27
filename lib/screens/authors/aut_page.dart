import 'package:flutter/material.dart';

import 'aut_header.dart';
import 'aut_body.dart';

class AutPage extends StatelessWidget {
  const AutPage({Key? key}) : super(key: key);

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
                background: AutHeader(),
              ),
            ),
          ];
        },
        body: const AutBody(),
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: mediaQuery.size.width * 0.35,
            height: mediaQuery.size.height,
            child: const AutHeader(),
          ),
          const Expanded(
            child: AutBody(),
          ),
        ],
      );
    }
  }
}
