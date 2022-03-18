import 'package:flutter/material.dart';

import '/assets/theme/constants.dart';

class InfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: orientation == Orientation.portrait
              ? BoxFit.fitWidth
              : BoxFit.fitHeight,
          image: AssetImage('lib/assets/images/info.png'),
          alignment: Alignment.center,
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
