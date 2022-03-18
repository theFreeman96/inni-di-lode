import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/assets/theme/provider.dart';
import '/assets/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import 'cat_detail.dart';

class CatBody extends StatefulWidget {
  @override
  _CatBodyState createState() => _CatBodyState();
}

class _CatBodyState extends State<CatBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  QueryCtr _query = new QueryCtr();
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
              labelText: 'Cerca una Categoria',
              labelStyle: TextStyle(color: kLightGrey),
              hintText: 'Cerca',
            ),
          ),
        ),
        Divider(height: 0.0),
        FutureBuilder<List?>(
          future: _query.getAllMacroCat(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: new ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data![i], i);
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

  Widget _buildRow(Macrocategories macrocat, i) {
    return new ExpansionPanelList(
      elevation: 0.0,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: new CircleAvatar(
                child: new FaIcon(
                  FontAwesomeIcons.tags,
                  size: 15,
                ),
              ),
              title: new Text(
                macrocat.name.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
            );
          },
          canTapOnHeader: true,
          isExpanded: _activeMeterIndex == i,
          body: FutureBuilder<List?>(
            future: _query.getCatByMacro(macrocat.id),
            initialData: [],
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildCatRow(snapshot.data![i]);
                      },
                    )
                  : Center(
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
    return new ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: kDefaultPadding),
        child: new FaIcon(
          FontAwesomeIcons.tag,
        ),
      ),
      title: new Text(
        cat.name,
        style: TextStyle(fontSize: 16.0),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: kDefaultPadding),
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
              return CatDetail();
            },
          ),
        );
      },
    );
  }
}
