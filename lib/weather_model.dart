class Weather {
  final String description;
  final double temperature;
  final String cityName;
  final String weather;
  final String icon;

  Weather({
    required this.description,
    required this.temperature,
    required this.cityName,
    required this.weather,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      cityName: json['name'],
      weather: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
  String getIconUrl() {
    return 'http://openweathermap.org/img/wn/$icon.png';
  }
}

class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;

  WeatherForecast(
      {required this.dateTime,
      required this.temperature,
      required this.description,
      required this.icon});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
  String getIconUrl() {
    return 'http://openweathermap.org/img/wn/$icon.png';
  }
}
