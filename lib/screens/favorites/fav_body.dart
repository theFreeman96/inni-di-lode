import 'package:flutter/material.dart';

class FavBody extends StatefulWidget {
  @override
  _FavBodyState createState() => _FavBodyState();
}

class _FavBodyState extends State<FavBody> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('Elenco Cantici Preferiti'),
      ),
    );
  }
}
