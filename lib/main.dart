import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_flutter/repository/weather_repository.dart';
import 'package:web_flutter/state/weather_store.dart';

import 'pages/weather_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Provider(
        create: (_) => WeatherStore(FetchWeatherRepository()),
          child: const HomePage()),
    );
  }
}
