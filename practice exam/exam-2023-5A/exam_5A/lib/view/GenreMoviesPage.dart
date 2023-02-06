import 'package:exam_5a/view/MovieListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/Genre.dart';
import '../repository/DbRepository.dart';

class GenreMoviesPage extends StatefulWidget {
  final String _genre;
  const GenreMoviesPage(this._genre, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GenreMoviesPage();
}

class _GenreMoviesPage extends State<GenreMoviesPage> {
  @override
  Widget build(BuildContext context) {
    var genre = widget._genre;
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies for ${widget._genre}"),
      ),
      body: MoviesListWidget(widget._genre),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Provider.of<DbRepository>(context, listen: false).checkOnline();
                },
                child: const Text("Refresh")
            ),
          ],
        ),
      ),
    );
  }

}