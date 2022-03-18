import 'package:flutter/material.dart';

import '/assets/theme/constants.dart';

class InfoBody extends StatefulWidget {
  @override
  InfoBodyState createState() => InfoBodyState();
}

class InfoBodyState extends State<InfoBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
          top: kDefaultPadding * 0.5, bottom: kDefaultPadding * 0.5),
      children: const <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.email),
          ),
          title: Text('Email:'),
          subtitle: Text('adi@adi-media.it'),
        ),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.call),
          ),
          title: Text('Telefono:'),
          subtitle: Text('(+39) 06 22 51 825\n(+39) 06 22 84 970'),
        ),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.print),
          ),
          title: Text('Fax:'),
          subtitle: Text('(+39) 06 22 84 970'),
        ),
      ],
    );
  }
}
