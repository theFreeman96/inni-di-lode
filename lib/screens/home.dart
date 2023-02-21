import 'package:flutter/material.dart';

import '/components/pages.dart';
import '/components/bottomNavBar.dart';
import '/components/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
      ),
      drawer: const HamburgerMenu(),
      body: buildPage(context, currentIndex),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            tooltip: 'Menu',
            child: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar:
          buildBottomNavBar(context, currentIndex, onTabTapped),
    );
  }
}
