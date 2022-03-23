import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/theme/provider.dart';
import '/assets/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import 'aut_detail.dart';

class AutBody extends StatefulWidget {
  @override
  _AutBodyState createState() => _AutBodyState();
}

class _AutBodyState extends State<AutBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  QueryCtr _query = new QueryCtr();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: TextField(
            focusNode: myFocusNode,
            autofocus: false,
            controller: editingController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: kLightGrey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode
                        ? kPrimaryLightColor
                        : kPrimaryColor,
                    width: 2.0),
              ),
              prefixIconColor: kPrimaryColor,
              labelText: 'Cerca un Autore',
              labelStyle: TextStyle(color: kLightGrey),
              hintText: 'Cerca',
            ),
          ),
        ),
        Divider(height: 0.0),
        FutureBuilder<List?>(
          future: _query.getAllAut(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: new ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data![i]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildRow(Authors aut) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Icon(
          Icons.person,
        ),
      ),
      title: new Text(aut.surname + ' ' + aut.name),
      trailing: Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail();
            },
          ),
        );
      },
    );
  }
}
