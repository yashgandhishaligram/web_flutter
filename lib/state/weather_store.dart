import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:web_flutter/pages/earth_view.dart';
import 'package:web_flutter/repository/weather_repository.dart';
import '../model/weather.dart';

part 'weather_store.g.dart';

class WeatherStore extends _WeatherStore with _$WeatherStore{
WeatherStore(WeatherRepository weatherRepository) : super(weatherRepository);
}

enum StoreState { initial, loading, loaded }

abstract class _WeatherStore with Store {
  final WeatherRepository? weatherRepository;
  @observable
  ObservableFuture<Weather>? _weatherFuture;

  @observable
  Weather? weather;

  @observable
  String? errorMessage;

  _WeatherStore(this.weatherRepository);


  @computed
  StoreState get state {
    if(_weatherFuture == null || _weatherFuture?.status == FutureStatus.rejected){
      return StoreState.initial;
    }
    return _weatherFuture?.status == FutureStatus.pending ? StoreState.loading : StoreState.loaded;
  }
 
  @action
  Future getWeather(String cityName) async {
    try{
      errorMessage = null;
      _weatherFuture = ObservableFuture(weatherRepository!.fetchWeather(cityName));
      weather = (await _weatherFuture)!;
      // print("weather : ${jsonEncode(weather)}");
    } catch(e) {
      errorMessage = "City Not found";
    }
  }

  @action
  Future gotoEarthView(BuildContext context) async {
    Navigator.push(
        context, // here you got the context and now you can decouple your business logic to the view
        MaterialPageRoute(
        builder: (_) => const EarthView(),
    ));
  }

  @computed
  Future<void> _readAndParseJson(List<dynamic> args) async {
    SendPort resultPort = args[0];
    String fileLink = args[1];
    String newImageData = fileLink;
    await Future.delayed(const Duration(seconds: 2));
    Isolate.exit(resultPort, newImageData);
  }

  Future<String> _readAndParseJsonWithoutIsolateLogic() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'this is downloaded data';
  }
}