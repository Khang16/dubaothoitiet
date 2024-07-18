import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen_foreCast.dart';
import 'search_screen.dart';
import 'weather_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedLocation();
    });
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocation = prefs.getString('location');
    print(
        'Saved location: $savedLocation'); // Log để kiểm tra dữ liệu được đọc từ SharedPreferences
    if (savedLocation != null) {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      await weatherProvider.fetchWeatherByCity(savedLocation);
    }
  }

  Future<void> _saveLocation(String location) async {
    if (location == null || location.isEmpty) {
      debugPrint('Location is null or empty');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString('location', location);
    if (!success) {
      debugPrint(
          'Failed to save location'); // Log để kiểm tra việc lưu dữ liệu vào SharedPreferences
    } else {
      debugPrint(
          'Location saved successfully: $location'); // Log để xác nhận dữ liệu đã được lưu
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Kiểm tra nếu weather là null
    if (weatherProvider.weather == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Weather App')),
        body: const Center(
          child: Text(
            'Dữ liệu thời tiết chưa có',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        floatingActionButton:
            buildFloatingActionButtons(context, weatherProvider),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 0),
          child: Center(
            child: Column(
              children: [
                Image.network(
                  weatherProvider.weather!.getIconUrl(),
                  height: 150,
                  width: 250,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 20),
                Text(
                  weatherProvider.weather!.cityName,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  '${weatherProvider.weather!.temperature}°C',
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
                Text(
                  weatherProvider.weather!.description,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          buildFloatingActionButtons(context, weatherProvider),
    );
  }

  Widget buildFloatingActionButtons(
      BuildContext context, WeatherProvider weatherProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await weatherProvider.fetchWeatherByLocation();
          },
          child: Icon(Icons.my_location),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: 'search2',
            onPressed: () async {
              final location = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              if (location != null) {
                await _saveLocation(location);
                await weatherProvider.fetchWeatherByCity(location);
              }
            },
            child: const Icon(Icons.search),
          ),
        ),
        FloatingActionButton(
          heroTag: 'search1',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomescreenForecast(forecast: weatherProvider.forecast),
              ),
            );
          },
          child: const Icon(Icons.info),
        ),
      ],
    );
  }
}
