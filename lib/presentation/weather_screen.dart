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
  DateTime? _lastApiCallTime;
  late List<Color> _currentPalette;

  Future<void> _fetchWeather() async {
    if (_lastApiCallTime == null ||
        DateTime.now().difference(_lastApiCallTime!) > Duration(minutes: 5)) {
      final location = await _weatherService.getCurrentCity();
      final latitude = location[1];
      final longitude = location[2];
      try {
        final weather = await _weatherService.getWeather(latitude, longitude);
        setState(() {
          _weather = weather;
        });

        _lastApiCallTime = DateTime.now();
      } catch (e) {
        print("Error");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _currentPalette = findPalette(appTheme);
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
    else if (condition.toLowerCase() == "") {
      return "fallback";
    }
    else {
      return condition.toLowerCase();
    }
  }

  String appTheme = "minimal";

  List<Color> findPalette(String appTheme) {
    String? condition = findCondition();
    List<Color> palette = [];

    if (appTheme == "minimal") {
      palette = [const Color(0xFFE5E9F0),
        const Color(0xFFE5E9F0),
        const Color(0xFFE5E9F0),
        const Color(0xFF2E3440),
        const Color(0xFF3B4252)];
    }
    else if (appTheme == "standard") {
      switch (condition) {
        case "sun":
          palette = [Colors.blue.shade300, Colors.purple.shade100, Colors.amber.shade300, Colors.black87, Colors.black87];
          break;
        case "moon":
          palette = [Colors.black26, Colors.blueGrey.shade900, Colors.black87, Colors.white70, Colors.white];
          break;
        case "clouds":
          palette = [Colors.blue.shade700, Colors.lightBlue.shade300, Colors.cyan.shade900, Colors.black87, Colors.black87];
          break;
        case "drizzle":
          palette = [Colors.blueGrey.shade700, Colors.blueGrey.shade500, Colors.black26, Colors.white70, Colors.white];
          break;
        case "rain":
          palette = [Colors.blueGrey.shade900, Colors.blueGrey.shade700, Colors.black54, Colors.white70, Colors.white];
          break;
        case "thunderstorm":
          palette = [Colors.black54, Colors.blueGrey.shade900, Colors.black87, Colors.white, Colors.white60];
          break;
        case "mist":
          palette = [Colors.grey.shade600, Colors.grey.shade300, Colors.grey.shade900, Colors.black87, Colors.black87];
          break;
        case "snow":
          palette = [Color(0xFF88C0D0), Color(0xFF5E81AC), Color(0xFF4C566A), Colors.black87, Colors.black87];
          break;
        case "fallback":
          palette = [Colors.blue.shade300, Colors.purple.shade100, Colors.amber.shade300, Colors.black87, Colors.black87];
          break;
      }
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
          colors: findPalette(appTheme).sublist(0, 3),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          iconTheme: IconThemeData(color: findPalette(appTheme)[4]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
          ),
        ),
        drawer: Drawer(
          backgroundColor: findPalette(appTheme)[1],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: findPalette(appTheme)[1],
                ),
                child: Text(
                  'WeatherWave',
                  style: GoogleFonts.comfortaa(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: findPalette(appTheme)[4]
                  ),
                ),
              ),
              ListTile(
                leading: Image(
                  image: AssetImage(
                      "assets/images/$appTheme/theme.png"
                  ),
                  height: 40,
                  width: 40,
                ),
                title: Text(
                    "Switch Theme",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      color: findPalette(appTheme)[4]
                    )
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    appTheme = (appTheme == "minimal") ? "standard" : "minimal";
                    _currentPalette = findPalette(appTheme);
                  });
                },
              ),
              ListTile(
                leading: Image(
                  image: AssetImage(
                    "assets/images/$appTheme/about.png"
                  ),
                  height: 40,
                  width: 40,
                ),
                title: Text(
                    "About",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                        color: findPalette(appTheme)[4]
                    )
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: findPalette(appTheme)[4],
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "WeatherWave",
                              style: GoogleFonts.comfortaa(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme)[1]
                              ),
                            ),
                          ],
                        ),
                        content: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Made with ❤️ using Flutter",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: findPalette(appTheme)[1]
                              ),
                            ),
                            Text(
                              "Developed by kingslayer1312",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: findPalette(appTheme)[1]
                              ),
                            ),
                          ],
                        )
                      );
                    },
                  );
                },
              )
            ]
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
                  height: 35,
                ),
                Text(
                  "Good ${greeting()}",
                  style: GoogleFonts.comfortaa(
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    color: findPalette(appTheme).elementAt(3)
                  ),
                ),
                Text(
                  _weather?.city ?? "Fetching location...",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    color: findPalette(appTheme).elementAt(3)
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Image(
                  image: AssetImage("assets/images/$appTheme/${findCondition()}.png"), //
                  width: 270,
                  height: 270,
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weather?.temperature.toStringAsFixed(0) ?? "--",
                      style: GoogleFonts.comfortaa(
                          fontSize: 70,
                          fontWeight: FontWeight.w800,
                          color: findPalette(appTheme).elementAt(4)
                      ),
                    ),
                    Text(
                      "°C",
                      style: GoogleFonts.comfortaa(
                          fontSize: 70,
                          fontWeight: FontWeight.w800,
                          color: findPalette(appTheme).elementAt(4)
                      )
                    )
                  ],
                ),
                Text(
                  _weather?.condition.toString() ?? "Fetching condition...",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: findPalette(appTheme).elementAt(4)
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/$appTheme/hot.png"),
                          height: 50,
                          width: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              _weather?.maximumTemperature.toStringAsFixed(0) ?? "--",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            ),
                            Text(
                              "°C",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/$appTheme/humidity.png"),
                          height: 50,
                          width: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              _weather?.humidity.toStringAsFixed(0) ?? "--",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            ),
                            Text(
                              "%",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/$appTheme/cold.png"),
                          height: 50,
                          width: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              _weather?.minimumTemperature.toStringAsFixed(0) ?? "--",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            ),
                            Text(
                              "°C",
                              style: GoogleFonts.quicksand(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: findPalette(appTheme).elementAt(4)
                              ),
                            )
                          ],
                        )
                      ],

                    )
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}