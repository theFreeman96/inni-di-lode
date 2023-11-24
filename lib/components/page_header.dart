import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
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
}
