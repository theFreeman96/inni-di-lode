import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import 'aut_detail.dart';

class AutBody extends StatefulWidget {
  @override
  _AutBodyState createState() => _AutBodyState();
}

class _AutBodyState extends State<AutBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();

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
              prefixIcon: const Icon(
                Icons.search,
                color: kLightGrey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
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
              labelStyle: const TextStyle(color: kLightGrey),
              hintText: 'Cerca',
            ),
          ),
        ),
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: query.getAllAut(),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data![i]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(kDefaultPadding * 2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildRow(Autori get) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(
          Icons.person,
        ),
      ),
      title: Text(get.autName),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        int autId = get.autId;
        String autName = get.autName;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail(autId, autName);
            },
          ),
        );
      },
    );
  }
}
