    // lib/weather_model.dart
    // Ini adalah tempat satu-satunya di mana kelas Weather didefinisikan
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
        // Menambahkan pengecekan null dan tipe data untuk robust
        if (json['name'] == null || json['main'] == null || json['weather'] == null || json['weather'].isEmpty) {
          throw Exception('Invalid weather data format: Missing essential fields.');
        }
        if (json['main']['temp'] == null) {
          throw Exception('Invalid weather data format: Missing temperature data.');
        }
        if (json['weather'][0]['description'] == null || json['weather'][0]['icon'] == null) {
          throw Exception('Invalid weather data format: Missing weather description or icon.');
        }

        return Weather(
          cityName: json['name'],
          temperature: json['main']['temp'].toDouble(),
          description: json['weather'][0]['description'],
          iconCode: json['weather'][0]['icon'],
        );
      }
    }
    