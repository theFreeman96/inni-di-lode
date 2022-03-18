import 'package:flutter/material.dart';

class FavBody extends StatefulWidget {
  @override
  FavBodyState createState() => FavBodyState();
}

class FavBodyState extends State<FavBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text('Elenco Cantici Preferiti'),
      ),
    );
  }
}
