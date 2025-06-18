import 'dart:convert';
    import 'package:http/http.dart' as http;
    // import 'package:weather_app/weather_model.dart'; // Sesuaikan path jika Anda punya model terpisah

    // Anda bisa membuat kelas model Weather di sini atau di file terpisah (weather_model.dart)
    class Weather {
      final String cityName;
      final double temperature;
      final String description;
      final String iconCode;

      Weather({
        required this.cityName,
        required this.temperature,
        required this.description,
        required this.iconCode,
      });

      factory Weather.fromJson(Map<String, dynamic> json) {
        return Weather(
          cityName: json['name'],
          temperature: json['main']['temp'].toDouble(),
          description: json['weather'][0]['description'],
          iconCode: json['weather'][0]['icon'],
        );
      }
    }


    class WeatherService {
      // *** GANTI 'YOUR_API_KEY' DENGAN KUNCI API OPENWEATHERMAP ANDA YANG SEBENARNYA ***
      final String _apiKey = '6d211d7f73a825259e07ae60f0856383';
      final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

      Future<Weather> fetchWeather(String cityName) async {
        final response = await http.get(Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric'));

        if (response.statusCode == 200) {
          return Weather.fromJson(jsonDecode(response.body));
        } else {
          // Anda bisa menambahkan penanganan error yang lebih spesifik di sini
          // misalnya, memeriksa response.statusCode untuk 404 (kota tidak ditemukan)
          throw Exception('Failed to load weather data: ${response.statusCode} ${response.body}');
        }
      }

      String getWeatherIconUrl(String iconCode) {
        return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
      }
    }
    