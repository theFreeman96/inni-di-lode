import 'package:flutter/material.dart';

import '/assets/theme/constants.dart';

class SongsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: orientation == Orientation.portrait
              ? BoxFit.fitWidth
              : BoxFit.fitHeight,
          image: AssetImage('lib/assets/images/header.png'),
          alignment: Alignment.center,
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
