import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? apiKey;
  String? weatherQuery;
  Map<String, dynamic>? weatherResponse;

  // http://api.weatherapi.com/v1/forecast.json?key=${this.apiKey}&q=${locationName}&days=1&aqi=no&alerts=yes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Weather API key'),
              ),
              TextField(onChanged: (String value) {
                setState(() {
                  apiKey = value.isEmpty ? null : value;
                  weatherResponse = null;
                });
              }),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Location'),
              ),
              TextField(onChanged: (String value) {
                setState(() {
                  weatherQuery = value.isEmpty ? null : value;
                  weatherResponse = null;
                });
              }),
              TextButton(
                onPressed: () {
                  getForecast();
                },
                child: const Text('Give me a forecast'),
              ),
              if (weatherResponse != null)
                Text('Today will be around ' + (weatherResponse!['current']['temp_c'] as double).toString() + '°C'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getForecast() async {
    if (apiKey == null || apiKey!.isEmpty || weatherQuery == null || weatherQuery!.isEmpty) {
      return;
    }

    final Uri url = Uri(
        scheme: 'http',
        host: 'api.weatherapi.com',
        pathSegments: <String>['v1', 'forecast.json'],
        queryParameters: <String, String>{'key': apiKey!, 'q': weatherQuery!, 'days': '1', 'aqi': 'no'});

    final Response response = await get(url);
    setState(() {
      weatherResponse = jsonDecode(response.body) as Map<String, dynamic>;
    });
  }
}
