import 'package:exam_2a/view/CategoryTipsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import '../utils/Pair.dart';

class CategoriesListWidget extends StatefulWidget {
  const CategoriesListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CategoriesListWidget();
}

class _CategoriesListWidget extends State<CategoriesListWidget> {
  void showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildListView() {
    var entitiesFuture =
        Provider.of<DbRepository>(context, listen: true).getAllCategories();

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
          if (entities?.left?.left.length == 0) {
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
              itemCount: entities?.left.left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var entity = entities?.left.left[index];

                if (entities?.left.left != [] && entity == null) {
                  return const Card();
                } else if (entity == null && index == 0) {
                  return const Card(
                    child: Text("offline"),
                  );
                } else if (entity == null) {
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
                          entity.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute<void>(builder: (context) {
                        return CategoryTipsPage(entity.name);
                      }))
                    },
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
