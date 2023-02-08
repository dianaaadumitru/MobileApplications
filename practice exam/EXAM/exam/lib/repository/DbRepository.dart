import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class DbRepository extends ChangeNotifier{
  final WebSocketChannel _channel;

  bool _online = false;


  static const String ipAddress = '192.168.1.5';
  static const String wsPort = '2307';
  static const String httpPort = '2307';

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
          .get(Uri.parse("http://$ipAddress:$httpPort/days"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        if (_online == false) {
          _online = true;
        }
        log("is online");
      }
    } on TimeoutException {
      _online = false;
    } on Error {
      _online = false;
    }

    notifyListeners();
    return _online;
  }

}