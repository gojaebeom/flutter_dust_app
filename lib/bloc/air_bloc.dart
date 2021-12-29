import 'package:flutter/material.dart';
import 'package:flutter_dust/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class AirBloc {
  AirResult? _result;

  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  Future<AirResult> fetchData() async {
    Uri url = Uri.parse(
        'http://api.airvisual.com/v2/nearest_city?key=2fb60669-c444-484f-8308-598895c8ea90');
    var response = await http.get(url);

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;

  Color getColor(AirResult? result) {
    var aqius = result?.data?.current?.pollution?.aqius;
    if (aqius! <= 30) {
      return Colors.greenAccent;
    } else if (aqius <= 80) {
      return Colors.yellow;
    } else if (aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getStatus(AirResult? result) {
    var aqius = result?.data?.current?.pollution?.aqius;
    if (aqius! <= 30) {
      return '좋음';
    } else if (aqius <= 80) {
      return '보통';
    } else if (aqius <= 150) {
      return '나쁨';
    } else {
      return '매우나쁨';
    }
  }
}
