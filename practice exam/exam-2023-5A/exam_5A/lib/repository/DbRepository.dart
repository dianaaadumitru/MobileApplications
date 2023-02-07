import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/Genre.dart';
import '../domain/Movie.dart';
import '../utils/Pair.dart';

class DbRepository extends ChangeNotifier {
  final WebSocketChannel _channel;

  bool _online = false;

  List<Genre> _genres = [];
  List<Movie> _movies = [];
  Map<String, List<Movie>> _moviesByGenre = {};

  static const String ipAddress = '192.168.1.5';
  static const String wsPort = '2305';
  static const String httpPort = '2305';

  String _infoMessage = '';

  DbRepository(this._channel) {
    _channel.stream.listen((data) {
      _listenToServerHandler(data);
    });
  }

  static Future<DbRepository> init() async {
    final channel =
        WebSocketChannel.connect(Uri.parse("ws://$ipAddress:$wsPort"));
    return DbRepository(channel);
  }

  void _listenToServerHandler(dynamic data) {
    data = jsonDecode(data);
    _infoMessage = data.toString();
    notifyListeners();
  }

  String getInfoMessage() => _infoMessage;

  void setInfoMessage(String message) {
    _infoMessage = message;
    notifyListeners();
  }

  Future<bool> checkOnline() async {
    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/genres"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        if (_online == false) {
          _online = true;
        }
      }
    } on TimeoutException {
      _online = false;
    } on Error {
      _online = false;
    }

    notifyListeners();
    return _online;
  }

  Future<Pair> getAllGenres() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/genres"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var rawRes = json.decode(response.body);
        _genres = rawRes.map((str) => Genre(str)).toList().cast<Genre>();

        return Pair(Pair(_genres, "ok"), _online);
      } else {
        return Pair(Pair(_genres, response.body), _online);
      }
    } on Exception {
      _online = false;
    }

    return Pair(Pair(_genres, "ok"), _online);
  }

  Future<Pair> getAllMovies() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/all"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var res = json.decode(response.body);
        var moviesJson = res as List;
        _movies = moviesJson.map((movie) => Movie.fromJson(movie)).toList();

        return Pair(Pair(_movies, "ok"), _online);
      } else {
        return Pair(Pair(_movies, response.body), _online);
      }
    } on Exception {
      _online = false;
    }

    return Pair(Pair(_movies, "ok"), _online);
  }

  Future<Pair> getMoviesByGenre(String givenGenre) async {
    _online = false;
    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/movies/$givenGenre"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;
        var res = json.decode(response.body);
        var moviesJson = res as List;
        _moviesByGenre[givenGenre] =
            moviesJson.map((movie) => Movie.fromJson(movie)).toList();
        return Pair(Pair(_moviesByGenre[givenGenre], "ok"), _online);
      } else {
        return Pair(Pair(_moviesByGenre[givenGenre], response.body), _online);
      }
    } on Exception {
      _online = false;
    }
    return Pair(Pair(_moviesByGenre[givenGenre], "ok"), _online);
  }

  Future<Pair> addMovie(String name, String description, String genre,
      String director, int year) async {
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .post(Uri.parse("http://$ipAddress:$httpPort/movie"),
              headers: headers,
              body: jsonEncode({
                'name': name,
                'description': description,
                'genre': genre,
                'director': director,
                'year': year
              }),
              encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Added dog $name');
      } else {
        notifyListeners();
        return Pair(response.body, _online);
      }
    } on Exception {
      _online = false;
    }
    notifyListeners();
    return Pair("ok", _online);
  }

  Future<Pair> deleteMovie(int id) async {
    try {
      var response = await http
          .delete(Uri.parse("http://$ipAddress:$httpPort/movie/$id"))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        log('log: Removed movie with id $id');
      }
    } on Exception {
      _online = false;
    }

    notifyListeners();
    return Pair("ok", _online);
  }

  Future<Pair> getActiveYearsList() async {
    var pairRepoRes = await getAllMovies();
    var allMovies = pairRepoRes.left.left as List<Movie>;
    var isOnline = pairRepoRes.right;

    final Map<int, int> yearToMoviesNo = {};
    for (var i = 0; i < allMovies.length; ++i) {
      yearToMoviesNo.update(
        allMovies[i].year,
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    var years = yearToMoviesNo.keys.toList();
    years.sort((y1, y2) =>
        ((yearToMoviesNo[y1] ?? 0) < (yearToMoviesNo[y2] ?? 0)) ? 1 : 0);
    var listRes =
        years.map((year) => Pair(year, yearToMoviesNo[year] ?? 0)).toList();

    return Pair(listRes, isOnline);
  }

  Future<Pair> getTop3GenresList() async {
    var pairRepoRes = await getAllMovies();
    var allMovies = pairRepoRes.left.left as List<Movie>;
    var isOnline = pairRepoRes.right;

    final Map<String, int> genreToMoviesNo = {};
    for (var i = 0; i < allMovies.length; ++i) {
      genreToMoviesNo.update(
        allMovies[i].genre,
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    var years = genreToMoviesNo.keys.toList();
    years.sort((y1, y2) =>
        ((genreToMoviesNo[y1] ?? 0) < (genreToMoviesNo[y2] ?? 0)) ? 1 : 0);
    var listRes =
        years.map((year) => Pair(year, genreToMoviesNo[year] ?? 0)).toList();

    return Pair(listRes.sublist(0, 3), isOnline);
  }
}
