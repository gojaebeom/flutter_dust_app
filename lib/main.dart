import 'package:flutter/material.dart';
import 'package:flutter_dust/bloc/air_bloc.dart';
import 'package:flutter_dust/models/air_result.dart';


void main() {
  runApp(const MyApp());
}

final AirBloc airBloc = AirBloc();

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


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<AirResult>(
            stream: airBloc.airResult,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? buildBody(snapshot.data)
                  : const CircularProgressIndicator();
            }
        ));
  }

  Widget buildBody(AirResult? _result) {
    return Padding(
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
                          Text(airBloc.getStatus(_result),
                              style: const TextStyle(fontSize: 20))
                        ],
                      ),
                      color: airBloc.getColor(_result),
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
                        Text('풍속 ${_result?.data?.current?.weather?.ws}/m')
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
                onPressed: airBloc.fetchData,
                child: const Icon(Icons.refresh),
              ),
            )
          ],
        ),
      ),
    );
  }
}
