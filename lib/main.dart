import 'package:flutter/material.dart';
import 'package:flutter_dust/models/AirResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult? _result;

  @override
  void initState() {
    super.initState();
    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '현재 위치 미세먼지',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('얼굴사진'),
                          Text('${_result?.data?.current?.pollution?.aqius}',
                              style: const TextStyle(fontSize: 40)),
                          Text(getStatus(_result),
                              style: const TextStyle(fontSize: 20))
                        ],
                      ),
                      color: getColor(_result),
                      padding: const EdgeInsets.all(8.0)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              'https://airvisual.com/images/${_result?.data?.current?.weather?.ic}.png',
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(width: 16),
                            Text('${_result?.data?.current?.weather?.tp}',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Text('습도 ${_result?.data?.current?.weather?.hu}%'),
                        Text('풍속 ${_result?.data?.current?.weather?.ws}s/m')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: fetchData,
                child: const Icon(Icons.refresh),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<AirResult> fetchData() async {
    Uri url = Uri.parse(
        'http://api.airvisual.com/v2/nearest_city?key=2fb60669-c444-484f-8308-598895c8ea90');
    var response = await http.get(url);

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  Color getColor(AirResult? result) {
    var aqius = _result?.data?.current?.pollution?.aqius;
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
    var aqius = _result?.data?.current?.pollution?.aqius;
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
