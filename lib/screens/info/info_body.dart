import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '/utilities/constants.dart';

class InfoBody extends StatefulWidget {
  const InfoBody({Key? key}) : super(key: key);

  @override
  State<InfoBody> createState() => _InfoBodyState();
}

class _InfoBodyState extends State<InfoBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.only(
        top: kDefaultPadding * 0.5,
        bottom: kDefaultPadding * 0.5,
      ),
      children: <Widget>[
        Link(
          uri: Uri.parse('https://www.adimedia.it/'),
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.language),
              ),
              title: const Text('Sito web:'),
              subtitle: const Text('adimedia.it'),
              onTap: followLink,
            );
          },
        ),
        Link(
          uri: Uri.parse('mailto:adi@adi-media.it'),
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.email),
              ),
              title: const Text('Email:'),
              subtitle: const Text('adi@adi-media.it'),
              onTap: followLink,
            );
          },
        ),
        Link(
          uri: Uri.parse('tel:+39062251825'),
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.call),
              ),
              title: const Text('Telefono:'),
              subtitle: const Text('(+39) 06 22 51 825'),
              onTap: followLink,
            );
          },
        ),
        Link(
          uri: Uri.parse('tel:+39062284970'),
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.call),
              ),
              title: const Text('Telefono:'),
              subtitle: const Text('(+39) 06 22 84 970'),
              onTap: followLink,
            );
          },
        ),
      ],
    );
  }
}
