import 'dart:developer';

import 'package:exam_5a/view/GenreMoviesPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/Genre.dart';
import '../repository/DbRepository.dart';
import '../utils/Pair.dart';
import 'MainSection.dart';

class MoviesListWidget extends StatefulWidget{
  final String _genre;

  const MoviesListWidget(this._genre, {super.key});

  @override
  State<StatefulWidget> createState() => _MovieListWidget();

}

class _MovieListWidget extends State<MoviesListWidget> {

  // void showAlertDialog(BuildContext context, String message) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: const Text("OK"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("Error"),
  //     content: Text(message),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  bool showAreYouSureDialog(int index) {
    bool isCancelled = false;

    // set up the button
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        var result =
        Provider.of<DbRepository>(context, listen: false).deleteMovie(index);
        result.then((value) => {
          if (value.right is bool  && value.right)
            {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (context) {
                return const MainSection();
              }))
            }
          else
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: const Text(
                          "You are offline or there is a problem, please try again later."),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (context) {
                                        return const MainSection();
                                      }));
                            },
                            child: const Text("OK"))
                      ],
                    );
                  })
            }
        });
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        isCancelled = true;
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: const Text('Are you sure you want to delete this movie?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return isCancelled;
  }

  Widget _buildListView() {
    var moviesFuture = Provider.of<DbRepository>(context, listen: true).getMoviesByGenre(widget._genre);
    return FutureBuilder<Pair>(
      future: moviesFuture,
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

          var movies = snapshot.data;
          if (movies?.left?.left.length == 0) {
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
              itemCount: movies?.left.left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var genre = movies?.left.left[index];

                if (movies?.left.left != [] && genre == null) {
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
                        ),
                        Text(
                          genre.description,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          genre.director,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${genre.year}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () => {
                      showAreYouSureDialog(genre.id)
                    },
                  ),
                );

                if (movies?.right == false && index == 0) {
                  return Card(
                    child: Column(
                        children: [
                          const Text("Offline"),
                          card
                        ]
                    ),
                  );
                }

                return card;
              }
          );
        }
    );
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
            children: <Widget>[
              Text(infoMessage)
            ],
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