import 'dart:convert';

import '../model/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String API_KEY;

  WeatherService(this.API_KEY);

  Future<Weather> getWeather(String city) async {
    final response = await http.get(Uri.parse("$BASE_URL?q=$city&appid=$API_KEY&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception("Failed to fetch weather data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? "";
  }

}