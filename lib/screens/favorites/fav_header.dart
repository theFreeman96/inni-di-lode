import 'package:flutter/material.dart';

import '/theme/constants.dart';

class FavHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/images/fav_header.png'),
          alignment: Alignment.center,
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
