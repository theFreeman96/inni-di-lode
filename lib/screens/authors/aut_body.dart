import 'package:flutter/material.dart';

import '/components/filter_bar.dart';
import '/components/main_list.dart';
import '/data/models.dart';
import '/data/queries.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';
import 'aut_detail.dart';

class AutBody extends StatefulWidget {
  const AutBody({Key? key}) : super(key: key);

  @override
  State<AutBody> createState() => _AutBodyState();
}

class _AutBodyState extends State<AutBody> {
  final FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();

  late Future<List?> future;

  @override
  void initState() {
    future = query.getAllAut();
    super.initState();
  }

  void runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        future = query.getAllAut();
      });
    } else {
      results = query.searchAut(keyword);

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
          label: 'Cerca un autore',
          hint: 'Cerca',
        ),
        const Divider(height: 0.0),
        MainList(
          future: future,
          padding: EdgeInsets.zero,
          row: buildRow,
          message: ErrorCodes.authorsNotFound,
        ),
      ],
    );
  }

  Widget buildRow(Autori get, i) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(
          Icons.person,
        ),
      ),
      title: Text('${get.name} ${get.surname.isEmpty ? '' : get.surname}'),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail(
                autId: get.id,
                autName: get.name,
                autSurname: get.surname,
              );
            },
          ),
        );
      },
    );
  }
}
