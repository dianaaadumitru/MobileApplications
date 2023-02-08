import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:exam_7b/domain/Date.dart';
import 'package:exam_7b/domain/HealthData.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/Pair.dart';

class DbRepository extends ChangeNotifier {
  final WebSocketChannel _channel;

  bool _online = false;

  List<Date> _days = [];
  Map<String, List<HealthData>> _healthDataByDate = {};
  List<HealthData> _entries = [];

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

  Future<Pair> getAllDates() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/days"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var rawRes = json.decode(response.body);
        _days = rawRes.map((str) => Date(str)).toList().cast<Date>();

        return Pair(Pair(_days, "ok"), _online);
      } else {
        return Pair(Pair(_days, response.body), _online);
      }
    } on Exception {
      _online = false;
    }

    return Pair(Pair(_days, "ok"), _online);
  }

  Future<Pair> getAllEntries() async {
    _online = false;

    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/entries"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;

        var res = json.decode(response.body);
        var entriesJson = res as List;
        _entries =
            entriesJson.map((movie) => HealthData.fromJson(movie)).toList();

        log("retrieved all entries having length ${_entries.length}");
        return Pair(Pair(_entries, "ok"), _online);
      } else {
        log("retrieved all entries having length ${_entries.length}");
        return Pair(Pair(_entries, response.body), _online);
      }
    } on Exception {
      _online = false;
    }
    log("retrieved all entries having length ${_entries.length}");
    return Pair(Pair(_entries, "ok"), _online);
  }

  Future<Pair> getHealthDataByDate(String givenDate) async {
    _online = false;
    try {
      var response = await http
          .get(Uri.parse("http://$ipAddress:$httpPort/symptoms/$givenDate"))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        _online = true;
        var res = json.decode(response.body);
        var tipsJson = res as List;
        _healthDataByDate[givenDate] =
            tipsJson.map((movie) => HealthData.fromJson(movie)).toList();
        log("retrieved list for $givenDate");
        return Pair(Pair(_healthDataByDate[givenDate], "ok"), _online);
      } else {
        log("retrieved list for $givenDate");
        return Pair(Pair(_healthDataByDate[givenDate], response.body), _online);
      }
    } on Exception {
      _online = false;
    }
    log("retrieved list for $givenDate");
    return Pair(Pair(_healthDataByDate[givenDate], "ok"), _online);
  }

  Future<Pair> addHealthData(String date, String symptom, String medication,
      String dosage, String doctor, String notes) async {
    try {
      Map<String, String> headers = HashMap();
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';

      var response = await http
          .post(Uri.parse("http://$ipAddress:$httpPort/symptom"),
              headers: headers,
              body: jsonEncode({
                'date': date,
                'symptom': symptom,
                'medication': medication,
                'dosage': dosage,
                'doctor': doctor,
                'notes': notes
              }),
              encoding: Encoding.getByName('utf-8'))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        log('log: Added health data with date $date');
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

  Future<Pair> deleteHealthData(int id) async {
    try {
      var response = await http
          .delete(Uri.parse("http://$ipAddress:$httpPort/symptom/$id"))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        log('log: Removed symptom with id $id');
      }
    } on Exception {
      _online = false;
    }

    notifyListeners();
    return Pair("ok", _online);
  }

  Future<Pair> getNoSymptomsByMonth() async {
    var pairRepoRes = await getAllEntries();
    var allEntries = pairRepoRes.left.left as List<HealthData>;
    var isOnline = pairRepoRes.right;

    final Map<String, int> monthsNo = {};
    for (var i = 0; i < allEntries.length; ++i) {
      var month = allEntries[i].date.split("-");
      monthsNo.update(
        month[2],
            (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    var months = monthsNo.keys.toList();
    months.sort(
            (a, b) => ((monthsNo[a] ?? 0) < (monthsNo[b] ?? 0)) ? 1 : 0);
    var listRes =
    months.map((year) => Pair(year, monthsNo[year] ?? 0)).toList();

    log("retrieved no of symptoms by month");

    return Pair(listRes, isOnline);
  }

  Future<Pair> getTop3Doctors() async {
    var pairRepoRes = await getAllEntries();
    var allEntries = pairRepoRes.left.left as List<HealthData>;
    var isOnline = pairRepoRes.right;

    final Map<String, int> doctorsNo = {};
    for (var i = 0; i < allEntries.length; ++i) {
      doctorsNo.update(
        allEntries[i].doctor,
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    var doctors = doctorsNo.keys.toList();
    doctors.sort(
        (a, b) => ((doctorsNo[a] ?? 0) < (doctorsNo[b] ?? 0)) ? 1 : 0);
    var listRes =
        doctors.map((year) => Pair(year, doctorsNo[year] ?? 0)).toList();

    log("top 3 doctors");

    if (listRes.length < 3) {
      return Pair(listRes, isOnline);
    }

    return Pair(listRes.sublist(0, 3), isOnline);
  }
}
