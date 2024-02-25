import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/images/drawer_header.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: kWhite,
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
                tooltip: 'Chiudi',
              );
            },
          ),
          const Positioned(
            bottom: kDefaultPadding - 8.0,
            left: kDefaultPadding - 4.0,
            child: Text(
              'Menu',
              style: TextStyle(
                color: kWhite,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
