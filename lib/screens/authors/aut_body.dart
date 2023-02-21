import 'package:flutter/material.dart';

import '/components/constants.dart';
import '/components/searchbar.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

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
        buildSearchBar(myFocusNode, runFilter, from: 'Autori'),
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
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return buildRow(snapshot.data![i]);
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
                        'Nessun autore trovato',
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

  Widget buildRow(Autori get) {
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
        int autId = get.id;
        String autName = get.name;
        String autSurname = get.surname;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AutDetail(autId, autName, autSurname);
            },
          ),
        );
      },
    );
  }
}
