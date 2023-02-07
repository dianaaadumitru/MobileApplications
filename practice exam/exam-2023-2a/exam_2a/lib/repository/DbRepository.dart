import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:exam_2a/domain/Tip.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/Category.dart';
import '../utils/Pair.dart';

class DbRepository extends ChangeNotifier {
  final WebSocketChannel _channel;

  bool _online = false;

  List<Category> _categories = [];
  Map<String, List<Tip>> _tipsByCategory = {};
  List<Tip> _tips = [];

  static const String ipAddress = '192.168.1.5';
  static const String wsPort = '2302';
  static const String httpPort = '2302';

  String _infoMessage = '';

  DbRepository(this._channel) {
    log("info message: $_infoMessage");
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
    log("info message: $_infoMessage");
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

  Future<Pair> getAllCategories() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/categories"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var rawRes = json.decode(response.body);
        _categories =
            rawRes.map((str) => Category(str)).toList().cast<Category>();

        return Pair(Pair(_categories, "ok"), _online);
      } else {
        return Pair(Pair(_categories, response.body), _online);
      }
    } on Exception {
      _online = false;
    }

    return Pair(Pair(_categories, "ok"), _online);
  }

  Future<Pair> getAllTips() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/easiest"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var res = json.decode(response.body);
        var moviesJson = res as List;
        _tips = moviesJson.map((movie) => Tip.fromJson(movie)).toList();

        return Pair(Pair(_tips, "ok"), _online);
      } else {
        return Pair(Pair(_tips, response.body), _online);
      }
    } on Exception {
      _online = false;
    }

    return Pair(Pair(_tips, "ok"), _online);
  }

  Future<Pair> getTipsByCategory(String givenCategory) async {
    _online = false;
    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/tips/$givenCategory"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;
        var res = json.decode(response.body);
        var tipsJson = res as List;
        _tipsByCategory[givenCategory] =
            tipsJson.map((movie) => Tip.fromJson(movie)).toList();
        return Pair(Pair(_tipsByCategory[givenCategory], "ok"), _online);
      } else {
        return Pair(
            Pair(_tipsByCategory[givenCategory], response.body), _online);
      }
    } on Exception {
      _online = false;
    }
    return Pair(Pair(_tipsByCategory[givenCategory], "ok"), _online);
  }

  Future<Pair> addTip(String name, String description, String materials,
      String steps, String category, String difficulty) async {
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .post(Uri.parse("http://$ipAddress:$httpPort/tip"),
              headers: headers,
              body: jsonEncode({
                'name': name,
                'description': description,
                'materials': materials,
                'steps': steps,
                'category': category,
                'difficulty': difficulty
              }),
              encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Added tip $name');
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

  Future<Pair> deleteTip(int id) async {
    try {
      var response = await http
          .delete(Uri.parse("http://$ipAddress:$httpPort/tip/$id"))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        log('log: Removed tip with id $id');
      }
    } on Exception {
      _online = false;
    }

    notifyListeners();
    return Pair("ok", _online);
  }

  Future<Pair> getTop10EasiestTips() async {
    var pairRepoRes = await getAllTips();
    var allTips = pairRepoRes.left.left as List<Tip>;
    var isOnline = pairRepoRes.right;

    allTips.sort((t1, t2) =>
        ((t1.difficulty == "easy" && t2.difficulty == 'medium') ||
                (t1.difficulty == "easy" && t2.difficulty == 'hard') ||
                (t1.difficulty == "medium" && t2.difficulty == 'hard'))
            ? 0
            : 1);
    var listRes = allTips.take(10).toList();

    return Pair(listRes, isOnline);
  }

  Future<Pair> changeCategory(int id, String difficulty) async {
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .post(Uri.parse("http://$ipAddress:$httpPort/difficulty"),
              headers: headers,
              body: jsonEncode({'id': id, 'difficulty': difficulty}),
              encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Updated $difficulty');
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
}
