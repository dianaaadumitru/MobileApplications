import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import '../utils/Pair.dart';

class ActiveYearsListWidget extends StatefulWidget {
  const ActiveYearsListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ActiveYearsListWidget();
}

class _ActiveYearsListWidget extends State<ActiveYearsListWidget> {
  Widget _buildListView() {
    var entitiesFuture =
        Provider.of<DbRepository>(context, listen: true).getActiveYearsList();

    return FutureBuilder<Pair>(
        future: entitiesFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("none");
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text("active");
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              }
          }

          var entities = snapshot.data;
          if (entities?.left.length == 0) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue.shade300,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Text("offline"),
            );
          }

          return ListView.builder(
              itemCount: entities?.left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var genre = entities?.left[index];

                if (entities?.left != [] && genre == null) {
                  return const Card();
                } else if (genre == null && index == 0) {
                  return const Card(
                    child: Text("offline"),
                  );
                } else if (genre == null) {
                  return const Card();
                }

                var card = Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.blue.shade300,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          genre.left.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          genre.right.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () => {},
                  ),
                );

                if (entities?.right == false && index == 0) {
                  return Card(
                    child: Column(children: [const Text("Offline"), card]),
                  );
                }

                return card;
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<DbRepository>(context);
    final infoMessage = storage.getInfoMessage();

    if (infoMessage != '') {
      return AlertDialog(
        title: const Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(infoMessage)],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              storage.setInfoMessage('');
            },
          )
        ],
      );
    }
    return _buildListView();
  }
}
