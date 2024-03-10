import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '/components/data_not_found.dart';
import '/components/delete_dialog.dart';
import '/components/error_dialog.dart';
import '/components/filter_bar.dart';
import '/components/macrocat_dialog.dart';
import '/components/main_list.dart';
import '/data/models.dart';
import '/data/queries.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';
import '/utilities/theme_provider.dart';
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

  final editMacroKey = GlobalKey<FormState>();
  late TextEditingController macroController;

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
        FilterBar(
          focusNode: myFocusNode,
          filter: runFilter,
          label: 'Cerca una categoria',
          hint: 'Cerca',
        ),
        const Divider(height: 0.0),
        MainList(
          future: future,
          padding: EdgeInsets.zero,
          row: buildRow,
          notFoundMessage: ErrorCodes.categoriesNotFound,
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
          body: Column(
            children: [
              FutureBuilder<List?>(
                future: query.getCatByMacro(get.macroId),
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Errore: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: DataNotFound(
                        notFoundMessage: ErrorCodes.categoriesNotFound,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        bottom: kDefaultPadding,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return buildCatRow(snapshot.data![i]);
                      },
                    );
                  }
                },
              ),
              Visibility(
                visible: get.macroId > 11 ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      tooltip: 'Modifica macrocategoria',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MacroCatDialog(
                              macroDialogFormKey: editMacroKey,
                              macroController: macroController =
                                  TextEditingController(text: get.macroName),
                              initialMacroId: get.macroId,
                              state: setState,
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Elimina macrocategoria',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder<List?>(
                              future: query.getCatByMacro(get.macroId),
                              initialData: const [],
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Errore: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return DeleteDialog(
                                    itemType: 'La macrocategoria',
                                    itemToDelete: get.macroName,
                                    onPressed: () {
                                      query.deleteMacroCat(get.macroId);
                                      setState(() {});
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const Home();
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return ErrorDialog(
                                    itemType: 'la macrocategoria',
                                    itemToDelete: get.macroName,
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
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
        child: Icon(
          Icons.sell,
          color: kLightGrey,
        ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CatDetail(
                catId: get.id,
                catName: get.name,
                macroId: get.macro_id,
                macroName: get.macro_name,
              );
            },
          ),
        );
      },
    );
  }
}
