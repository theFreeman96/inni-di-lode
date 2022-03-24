import 'package:flutter/material.dart';

import '/theme/constants.dart';

class InfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/images/info_header.png'),
          alignment: Alignment.center,
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
