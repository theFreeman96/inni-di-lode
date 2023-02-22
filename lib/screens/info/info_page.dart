import 'package:flutter/material.dart';

import '/components/page_header.dart';

import 'info_body.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Contatti'),
        leading: IconButton(
          tooltip: 'Indietro',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: orientation == Orientation.portrait
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: mediaQuery.size.height * 0.25,
                    floating: false,
                    pinned: false,
                    toolbarHeight: 0.0,
                    collapsedHeight: 0.0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: const FlexibleSpaceBar(
                      background: PageHeader(
                        image: 'lib/assets/images/info_header.png',
                      ),
                    ),
                  ),
                ];
              },
              body: const InfoBody(),
            )
          : Row(
              children: <Widget>[
                SizedBox(
                  width: mediaQuery.size.width * 0.35,
                  height: mediaQuery.size.height,
                  child: const PageHeader(
                    image: 'lib/assets/images/info_header.png',
                  ),
                ),
                const Expanded(
                  child: InfoBody(),
                ),
              ],
            ),
    );
  }
}
