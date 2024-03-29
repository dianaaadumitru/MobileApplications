import 'package:exam_5a/view/GenreMoviesPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import '../utils/Pair.dart';

class GenresListWidget extends StatefulWidget {
  const GenresListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _GenresListWidget();
}

class _GenresListWidget extends State<GenresListWidget> {
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
    var genresFuture =
        Provider.of<DbRepository>(context, listen: true).getAllGenres();

    return FutureBuilder<Pair>(
        future: genresFuture,
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

          var genres = snapshot.data;
          if (genres?.left?.left.length == 0) {
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
              itemCount: genres?.left.left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var genre = genres?.left.left[index];

                if (genres?.left.left != [] && genre == null) {
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
                          genre.name,
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
                        return GenreMoviesPage(genre.name);
                      }))
                    },
                  ),
                );

                if (genres?.right == false && index == 0) {
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
