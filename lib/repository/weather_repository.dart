import 'dart:convert';
import '../model/weather.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FetchWeatherRepository implements WeatherRepository {

  @override
  Future<Weather> fetchWeather(String cityName) async {
    String url = "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=f47dd784ee2b83b60acb7de66397a6f4";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    return Weather(
      cityName: responseData["name"] + ", " + responseData["sys"]["country"] ?? "",
      temperatureCelsius: responseData["main"]["temp"] ?? ""
    );
  }
}

class NetworkError extends Error {}