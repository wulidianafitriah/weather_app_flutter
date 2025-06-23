    // lib/weather_service.dart
    import 'dart:convert';
    import 'package:http/http.dart' as http;
    import 'package:weather_app/weather_model.dart'; // WAJIB ADA DAN TIDAK DIKOMENTARI

    class WeatherService {
      // *** GANTI 'YOUR_API_KEY' DENGAN KUNCI API OPENWEATHERMAP ANDA YANG SEBENARNYA ***
      final String _apiKey = '6d211d7f73a825259e07ae60f0856383'; 
      final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

      Future<Weather> fetchWeather(String cityName) async {
        final response = await http.get(Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric'));

        if (response.statusCode == 200) {
          // Menggunakan Weather.fromJson dari weather_model.dart
          return Weather.fromJson(jsonDecode(response.body));
        } else {
          print('Failed to load weather data: Status Code ${response.statusCode}, Body: ${response.body}');
          throw Exception('Failed to load weather data for $cityName. Status: ${response.statusCode}');
        }
      }

      String getWeatherIconUrl(String iconCode) {
        return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
      }
    }
    