import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:web_flutter/model/weather.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../state/weather_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityController = TextEditingController();
  WeatherStore? _weatherStore;
  List<ReactionDisposer>? _disposers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherStore ??= Provider.of<WeatherStore>(context);
    _disposers ??= [reaction(
            (_) => _weatherStore?.errorMessage, (message) {
              if(message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message.toString()),
                  ),
                );
              }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Check Your city weather",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cityController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: const Color(0xffEBEBEC),
                contentPadding: const EdgeInsets.all(15),
                hintText: "Enter City Name",
                hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      backgroundColor:
                      const MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    submitCity(context,cityController.text);
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ),
            const SizedBox(height: 20),
            cardView(),
            const SizedBox(height: 25),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    backgroundColor:
                    const MaterialStatePropertyAll(Colors.black)),
                onPressed: () {
                  gotoEarthView();
                },
                child: const Text(
                  "Earth View",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ],
        ),
      ),
    ));
  }

  Widget cardView() {
    return Card(
      color: Colors.black,
      child: Container(
        width: double.maxFinite,
        height: 180,
        margin: const EdgeInsets.only(left: 20,right: 10,top: 15,bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
        ),
        child: Observer(
            builder : (_) {
              switch (_weatherStore!.state) {
                case StoreState.initial:
                  return initialWeatherCardView();
                case StoreState.loading:
                  return buildLoading();
                case StoreState.loaded:
                  return weatherCardView(_weatherStore?.weather);
              }
            }),
      ),
    );
  }

  Widget initialWeatherCardView(){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.MMMEd().format(DateTime.now()),  //"Tuesday,14 May",
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 5),
            const Text("Enter City",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
            const SizedBox(height: 5),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "0",
                  style: TextStyle(fontSize: 64, color: Colors.grey),
                ),
                Text(
                  '°C',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Image.asset(getWeatherImage(10), height: 180, width: 180),
      ],
    );
  }


  Widget weatherCardView(Weather? weather) {
    return Row(
      children: [
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.MMMEd().format(DateTime.now()),  //"Tuesday,14 May",
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 5),
             Text(weather?.cityName ?? "",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
             Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather!.temperatureCelsius!.toInt().toString().substring(0,2),
                  style: const TextStyle(fontSize: 64, color: Colors.white),
                ),
                const Text(
                  '°C',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ],
            ),
             const Text("Sunny Cloudy",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
          ],
        ),
        const Spacer(),
        Expanded(flex : 8,child: Image.asset(getWeatherImage(weather.temperatureCelsius!.toInt()), height: 180, width: 180)),
      ],
    );
  }
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }


  String getWeatherImage(int temperature) {
    if(temperature == 15){
      return "assets/images/rainy_cloud.png";
    }else{
      return "assets/images/sunny_cloud.png";
    }
  }

  void submitCity(BuildContext context, String cityName) {
    final weatherStore = Provider.of<WeatherStore>(context,listen: false);
    weatherStore.getWeather(cityName);
  }

  void gotoEarthView() {
    final weatherStore = Provider.of<WeatherStore>(context,listen: false);
    weatherStore.gotoEarthView(context);
  }
}
