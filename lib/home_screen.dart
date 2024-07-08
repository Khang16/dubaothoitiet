import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'search_screen.dart';
import 'weather_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Hàm lấy ảnh thời tiết dựa trên trạng thái thời tiết
    Widget weatherImage(String weather) {
      String imageName;
      switch (weather) {
        case 'Sun':
        case 'Sunny':
          imageName = 'thunderstorm.png';
          break;
        case 'Clouds':
          imageName = 'cloud.png';

          break;
        case 'Rain':
          imageName = 'heavy-rain.png';
          break;
        case 'Clear':
          imageName = 'internet.png'; // Có thể bạn muốn đổi tên ảnh này?
          break;
        case 'Snow':
          imageName = 'snow.png';
          break;
        case 'Mist':
        case 'Haze':
        case 'Fog':
          imageName = 'fog.png';
          break;
        default:
          return const SizedBox
              .shrink(); // Trả về widget trống nếu không có trạng thái phù hợp
      }
      return Image.asset('assets/images/$imageName', height: 250, width: 250);
    }

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
                weatherImage(weatherProvider.weather!.weather),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await weatherProvider.fetchWeatherByLocation();
          },
          child: Icon(Icons.my_location),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'search2',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}
