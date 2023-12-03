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
    final location = await _weatherService.getCurrentCity();
    final latitude = location[1];
    final longitude = location[2];
    try {
      final weather = await _weatherService.getWeather(latitude, longitude);
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
    else if (condition.toLowerCase() == "clear"
        && DateTime.now().hour < 19
        && DateTime.now().hour > 7) {
      return "sun";
    }
    else if (condition.toLowerCase() == "clear") {
      return "moon";
    }
    else {
      return condition.toLowerCase();
    }
  }

  List<Color> findPalette() {
    String? condition = "clouds"; // findCondition()
    List<Color> palette = [];
    switch (condition) {
      case "sun":
        palette = [Colors.blue.shade300, Colors.purple.shade100, Colors.amber.shade300, Colors.black87, Colors.black87];
        break;
      case "moon":
        palette = [Colors.blueGrey.shade900, Colors.blueGrey.shade800, Colors.black87, Colors.white70, Colors.white];
        break;
      case "clouds":
        palette = [Colors.amber.shade800, Colors.deepPurple.shade700, Colors.black54, Colors.black87, Colors.white];
        break;
      case "drizzle":
        palette = [];
        break;

    }

    return palette;
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
          colors: findPalette().sublist(0, 3),
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
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    color: findPalette().elementAt(3)
                  ),
                ),
                Text(
                  "${_weather?.city}" ?? "",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    color: findPalette().elementAt(3)
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Image(
                  image: AssetImage("assets/images/clouds.png"), // ${findCondition()}
                  width: 270,
                  height: 270,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "${_weather?.temperature.toStringAsFixed(0)}°C" ?? "",
                  style: GoogleFonts.comfortaa(
                    fontSize: 70,
                    fontWeight: FontWeight.w800,
                      color: findPalette().elementAt(4)
                  ),
                ),
                Text(
                  _weather?.condition.toString() ?? "",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: findPalette().elementAt(4)
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/hot.png"),
                          height: 50,
                          width: 50,
                        ),
                        Text(
                          "${_weather?.maximumTemperature.toStringAsFixed(0)}°C" ?? "",
                          style: GoogleFonts.quicksand(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: findPalette().elementAt(4)
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/humidity.png"),
                          height: 50,
                          width: 50,
                        ),
                        Text(
                          "${_weather?.humidity.toStringAsFixed(0)}%" ?? "",
                          style: GoogleFonts.quicksand(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: findPalette().elementAt(4)
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/cold.png"),
                          height: 50,
                          width: 50,
                        ),
                        Text(
                          "${_weather?.minimumTemperature.toStringAsFixed(0)}°C" ?? "",
                          style: GoogleFonts.quicksand(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: findPalette().elementAt(4)
                          ),
                        )
                      ],

                    )
                  ],
                )

              ],
            ),
          )
        ),
      ),
    );
  }
}