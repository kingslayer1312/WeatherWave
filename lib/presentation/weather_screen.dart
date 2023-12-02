import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_wave/services/weather_service.dart';
import '../key/api_key.dart';
import '../model/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  final _weatherService = WeatherService(API_KEY);
  Weather? _weather;

  _fetchWeather() async {
    final city = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  String findCondition() {
    String? condition = _weather?.condition ?? "";
    List<String> conditions = ["Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado"];
    if (conditions.contains(condition)) {
      return "mist";
    }
    else {
      return condition.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade500, Colors.deepPurple.shade800, Colors.black],
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Good ${greeting()}",
                  style: GoogleFonts.comfortaa(
                    fontWeight: FontWeight.w300,
                    fontSize: 40
                  ),
                ),
                Text(
                  _weather?.city ?? "",
                ),
                Image(
                  image: AssetImage("assets/images/${findCondition()}.png")
                ),
                Text(
                  _weather?.temperature.toStringAsFixed(0) ?? "",
                ),
                Text(
                  _weather?.condition.toString() ?? "",
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}