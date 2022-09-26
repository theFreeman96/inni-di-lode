import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/theme_provider.dart';
import '/theme/constants.dart';
import '/assets/data/queries.dart';
import '/assets/data/models.dart';

import 'aut_detail.dart';

class AutBody extends StatefulWidget {
  const AutBody({Key? key}) : super(key: key);

  @override
  State<AutBody> createState() => _AutBodyState();
}

class _AutBodyState extends State<AutBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();

  late Future<List?> future;

  @override
  void initState() {
    future = QueryCtr().getAllAut();
    super.initState();
  }

  void runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        future = QueryCtr().getAllAut();
      });
    } else {
      results = QueryCtr().searchAut(keyword);

      setState(() {
        future = results;
      });
    }
  }

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
            onChanged: (value) {
              runFilter(value);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: kLightGrey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding * 0.8,
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
          future: future,
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
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
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: kDefaultPadding),
                    child: Center(
                      child: Text(
                        'Nessun Autore trovato',
                        style: TextStyle(fontSize: 20.0),
                      ),
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
