import 'package:flutter/material.dart';
import 'package:inforweather/weather_service.dart';

import 'location_service.dart';
import 'weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Weather? _weather;

  Weather? get weather => _weather;

  Future<void> fetchWeatherByCity(String city) async {
    _weather = await _weatherService.fetchWeatherByCity(city);
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    final position = await _locationService.getCurrentLocation();
    _weather = await _weatherService.fetchWeatherByLocation(
        position.latitude, position.longitude);
    notifyListeners();
  }
}
