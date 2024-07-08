class Weather {
  final String description;
  final double temperature;
  final String cityName;
  final String weather;

  Weather({
    required this.description,
    required this.temperature,
    required this.cityName,
    required this.weather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      cityName: json['name'],
      weather: json['weather'][0]['main'],
    );
  }
}
