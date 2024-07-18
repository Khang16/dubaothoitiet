import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'weather_model.dart';

class HomescreenForecast extends StatelessWidget {
  final List<WeatherForecast> forecast;

  const HomescreenForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Check if the forecast list is empty
    if (forecast.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Dự báo thời tiết')),
        body: Center(
          child: Text('Không có dữ liệu dự báo thời tiết.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text(
          'Dự báo thời tiết',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 400,
              height: 250,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: forecast.asMap().entries.map((entry) {
                        int index = entry.key;
                        WeatherForecast weather = entry.value;
                        return FlSpot(
                          index.toDouble(),
                          weather.temperature.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.white,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}°C');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${value.toInt()}°C',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < forecast.length) {
                            var dateTime = forecast[index].dateTime;

                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                '${dateTime.day}/${dateTime.month}',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true, border: Border.all(color: Colors.white)),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: ListView.builder(
              itemCount: forecast.length,
              itemBuilder: (context, index) {
                var item = forecast[index];
                var dateTime = item.dateTime;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0 ||
                        dateTime.day != forecast[index - 1].dateTime.day)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Ngày ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    Text(
                      'Thời gian: ${item.dateTime}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Nhiệt độ: ${item.temperature}°C',
                      style: TextStyle(color: Colors.white),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          'Mô tả: ${item.description}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Image.network(item.getIconUrl(),
                            height: 30, width: 60, fit: BoxFit.cover),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
