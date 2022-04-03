import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';

import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import '../authors/aut_detail.dart';

class FavBody extends StatefulWidget {
  const FavBody({Key? key}) : super(key: key);

  @override
  _FavBodyState createState() => _FavBodyState();
}

class _FavBodyState extends State<FavBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();

  late Future<List?> future;

  @override
  void initState() {
    super.initState();
    future = QueryCtr().getAllAut();
  }

  void _runFilter(String keyword) {
    Future<List<Autori>?>? results;
    if (keyword.isEmpty) {
      results = future as Future<List<Autori>?>?;
    } else {
      results = QueryCtr().searchAut(keyword);
    }

    setState(() {
      future = results!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: TextField(
              onChanged: (value) => _runFilter(value),
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
          Expanded(
            child: FutureBuilder<List?>(
              future: future,
              initialData: const [],
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return _buildRow(snapshot.data![i]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      )
                    : const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Text(
                          'Nessun risultato', style: TextStyle(fontSize: 20.0),
                        ),
                    );
              },
            ),
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
