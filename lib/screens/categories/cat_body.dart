import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/tables.dart';

import 'cat_detail.dart';

class CatBody extends StatefulWidget {
  @override
  _CatBodyState createState() => _CatBodyState();
}

class _CatBodyState extends State<CatBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final QueryCtr _query = QueryCtr();
  int? _activeMeterIndex;

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
              labelText: 'Cerca una Categoria',
              labelStyle: const TextStyle(color: kLightGrey),
              hintText: 'Cerca',
            ),
          ),
        ),
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: _query.getAllMacroCat(),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data![i], i);
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

  Widget _buildRow(Macrocategories macrocat, i) {
    return ExpansionPanelList(
      elevation: 0.0,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: const CircleAvatar(
                child: FaIcon(
                  FontAwesomeIcons.tags,
                  size: 15,
                ),
              ),
              title: Text(
                macrocat.name.toString(),
                style: const TextStyle(fontSize: 16.0),
              ),
            );
          },
          canTapOnHeader: true,
          isExpanded: _activeMeterIndex == i,
          body: FutureBuilder<List?>(
            future: _query.getCatByMacro(macrocat.id),
            initialData: const [],
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildCatRow(snapshot.data![i]);
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
        setState(
          () {
            _activeMeterIndex = _activeMeterIndex == i ? null : i;
          },
        );
      },
    );
  }

  Widget _buildCatRow(Categories cat) {
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.only(left: kDefaultPadding),
        child: FaIcon(
          FontAwesomeIcons.tag,
        ),
      ),
      title: Text(
        cat.name,
        style: const TextStyle(fontSize: 16.0),
      ),
      trailing: const Padding(
        padding: EdgeInsets.only(right: kDefaultPadding),
        child: Icon(
          Icons.navigate_next,
          color: kLightGrey,
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        int catId = cat.id;
        String catName = cat.name;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CatDetail(catId, catName);
            },
          ),
        );
      },
    );
  }
}
