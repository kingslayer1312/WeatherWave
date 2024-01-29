class Weather {
  final String city;
  final double latitude;
  final double longitude;
  final double temperature;
  final double minimumTemperature;
  final double maximumTemperature;
  final double humidity;
  final String condition;

  Weather({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.minimumTemperature,
    required this.maximumTemperature,
    required this.humidity,
    required this.condition
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      latitude: json['coord']['lat'],
      longitude: json['coord']['lon'],
      temperature: json['main']['temp'].toDouble(),
      minimumTemperature: json['main']['temp_min'].toDouble(),
      maximumTemperature: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
}