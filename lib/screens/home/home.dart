import 'package:flutter/material.dart';

import 'home_pages.dart';
import 'home_bottom.dart';
import 'home_drawer.dart';

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
      drawer: Drawer(
        child: buildDrawer(context),
      ),
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
      bottomNavigationBar: buildBottom(context, currentIndex, onTabTapped),
    );
  }
}
