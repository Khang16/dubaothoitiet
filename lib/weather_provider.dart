import 'package:flutter/material.dart';
import 'package:inforweather/weather_service.dart';

import 'location_service.dart';
import 'weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Weather? _weather;
  List<WeatherForecast> _forecast = [];

  Weather? get weather => _weather;
  // Weather? get weather => _weather; giải thích: _weather là biến private, nên không thể truy cập từ bên ngoài class WeatherProvider
  // Để truy cập vào biến _weather, chúng ta cần tạo một getter là weather, getter này sẽ trả về giá trị của _weather
  // Tương tự cho biến _forecast
  //
  List<WeatherForecast> get forecast => _forecast;

  Future<void> fetchWeatherByCity(String city) async {
    _forecast = await _weatherService.fetWeatherForecast(city);
    _weather = await _weatherService.fetCurrentWeather(city);
    notifyListeners();
  }

  Future<void> fetchWeatherForecast(String city) async {
    _forecast = await _weatherService.fetWeatherForecast(city);
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    final position = await _locationService.getCurrentLocation();
    _weather = await _weatherService.fetchWeatherByLocation(
        position.latitude, position.longitude);
    _forecast = await _weatherService.fetWeatherForecast(_weather!.cityName);
    notifyListeners();
  }
}
