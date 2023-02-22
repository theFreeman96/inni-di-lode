import 'package:flutter/material.dart';

import '/utilities/constants.dart';

Widget buildHeader({
  required String image,
}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(image),
        alignment: Alignment.center,
      ),
      color: kPrimaryColor,
    ),
  );
}
