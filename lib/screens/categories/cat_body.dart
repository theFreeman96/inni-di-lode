import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';
import '/theme/constants.dart';
import '/assets/data/queries.dart';
import '/assets/data/models.dart';

import 'cat_detail.dart';

class CatBody extends StatefulWidget {
  const CatBody({Key? key}) : super(key: key);

  @override
  State<CatBody> createState() => _CatBodyState();
}

class _CatBodyState extends State<CatBody> {
  final FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();
  int? expansionIndex;

  late Future<List?> future;
  @override
  void initState() {
    future = query.getAllMacroCat();
    super.initState();
  }

  void runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        future = query.getAllMacroCat();
      });
    } else {
      results = query.searchCat(keyword);

      setState(() {
        future = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: kLightGrey,
              ),
              labelText: 'Cerca una categoria',
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
                          return buildRow(snapshot.data![i], i);
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
                        'Nessuna categoria trovata',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget buildRow(Raccolta get, i) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ExpansionPanelList(
      elevation: 0.0,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: CircleAvatar(
                child: SizedBox(
                  width: kDefaultPadding * 1.25,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.sell, size: 20),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.sell,
                          size: 20,
                          color: themeProvider.isDarkMode
                              ? kPrimaryLightColor
                              : kPrimaryColor,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.sell, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(get.macroName),
            );
          },
          canTapOnHeader: true,
          isExpanded: expansionIndex == i,
          body: FutureBuilder<List?>(
            future: query.getCatByMacro(get.macroId),
            initialData: const [],
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        bottom: kDefaultPadding,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return buildCatRow(snapshot.data![i]);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ),
      ],
      expansionCallback: (int index, bool status) {
        setState(() {
          expansionIndex = expansionIndex == i ? null : i;
        });
      },
    );
  }

  Widget buildCatRow(Categorie get) {
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.only(left: kDefaultPadding),
        child: Icon(Icons.sell),
      ),
      title: Text(get.name),
      trailing: const Padding(
        padding: EdgeInsets.only(right: kDefaultPadding),
        child: Icon(
          Icons.navigate_next,
          color: kLightGrey,
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        int catId = get.id;
        String catName = get.name;
        int macroId = get.macro_id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CatDetail(catId, catName, macroId);
            },
          ),
        );
      },
    );
  }
}
