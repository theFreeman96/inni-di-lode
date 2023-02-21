import 'package:flutter/material.dart';

import '/utilities/constants.dart';

Widget buildHeader(headerImages) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(headerImages),
        alignment: Alignment.center,
      ),
      color: kPrimaryColor,
    ),
  );
}
