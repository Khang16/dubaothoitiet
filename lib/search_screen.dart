import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'weather_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm thành phố')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Thành phố'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await weatherProvider.fetchWeatherByCity(_controller.text);
                  Navigator.pop(context, MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                } catch (e) {
                  // Hiển thị SnackBar nếu có lỗi
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Không tìm thấy thành phố. Vui lòng nhập lại.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }
}
