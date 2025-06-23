import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';
import 'package:weather_app/weather_model.dart';
import 'package:weather_app/manage_cities_page.dart'; // Import halaman Manage Cities
import 'package:weather_app/weather_detail_page.dart'; // Import halaman Weather Detail

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        brightness: Brightness.dark, // Pengaturan tema utama untuk dark mode
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212), // Latar belakang gelap mendekati hitam
        // Sesuaikan warna teks default untuk dark mode
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white70),
        ),
        // Sesuaikan warna ikon default untuk dark mode
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // AppBar transparan
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white, // Warna teks AppBar putih
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Warna ikon AppBar putih
          ),
        ),
      ),
      home: const WeatherDashboardPage(), // Halaman awal aplikasi
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}

// =========================================================================
// Halaman Dashboard Cuaca (Slide 1) - DINAMIS & Desain Baru
// =========================================================================
class WeatherDashboardPage extends StatefulWidget {
  const WeatherDashboardPage({super.key});

  @override
  State<WeatherDashboardPage> createState() => _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _citySearchController = TextEditingController();
  
  Weather? _currentWeather; // Untuk menyimpan data cuaca saat ini
  bool _isLoading = false; // Status loading
  String? _error; // Pesan error jika ada

  @override
  void initState() {
    super.initState();
    // Memuat cuaca untuk kota default saat aplikasi pertama kali dimulai
    _fetchWeather('Jakarta');
  }

  Future<void> _fetchWeather(String cityName) async {
    if (cityName.isEmpty) {
      setState(() {
        _error = 'Nama kota tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentWeather = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(cityName);
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat cuaca untuk $cityName. Coba lagi. (${e.toString()})';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memungkinkan body di belakang appbar untuk latar belakang gambar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0, top: 20.0), // Sesuaikan padding agar rata kiri
          child: Row(
            children: [
              Text(
                'Trasak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              // Indikator lokasi (titik-titik)
              Icon(Icons.circle, size: 8, color: Colors.white70),
              SizedBox(width: 4),
              Icon(Icons.circle, size: 8, color: Colors.white70),
              SizedBox(width: 4),
              Icon(Icons.circle, size: 8, color: Colors.white70),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 20.0),
            child: Row(
              children: [
                // Tombol menu
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      // Aksi untuk ikon menu
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol pengaturan
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // Aksi untuk ikon pengaturan
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Latar belakang gambar - KOREKSI DI SINI: URL placeholder tanpa teks
          Positioned.fill(
            child: Image.network(
              'https://placehold.co/1000x1500/1E88E5/FFFFFF/png', // URL gambar placeholder tanpa teks
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken, // Memberi efek gelap pada gambar
              color: Colors.black.withOpacity(0.4), // Menyesuaikan opasitas gelap
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.blueGrey.shade900, // Warna solid jika gambar gagal dimuat
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight), // Spacer untuk AppBar
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                  else if (_error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (_currentWeather != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50), // Jarak dari atas
                        // Suhu utama
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${_currentWeather!.temperature.toStringAsFixed(0)}°',
                            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Deskripsi cuaca dan suhu min/max
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${_currentWeather!.description} ${_currentWeather!.temperature.toStringAsFixed(0)}°/${_currentWeather!.temperature.toStringAsFixed(0)}° Kualitas', // Suhu min/max placeholder
                            style: const TextStyle(fontSize: 20, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'udara: 63 - Sedang', // Kualitas udara placeholder
                            style: const TextStyle(fontSize: 20, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 50),

                        // Kartu Kualitas Udara
                        _buildAirQualityCard(),
                        const SizedBox(height: 20),

                        // Prakiraan Per Jam
                        _buildHourlyForecast(),
                        const SizedBox(height: 20),

                        // Prakiraan Harian
                        _buildDailyForecast(),
                        const SizedBox(height: 20),
                      ],
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Masukkan nama kota untuk melihat cuaca.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Search bar di atas konten (floating)
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight, // Sesuaikan posisi
            left: 16,
            right: 16,
            child: _buildSearchBarDashboard(),
          ),
        ],
      ),
    );
  }

  // Search bar khusus untuk Dashboard
  Widget _buildSearchBarDashboard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: _citySearchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari kota...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: IconButton(
            icon: _isLoading ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white) : const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              _fetchWeather(_citySearchController.text);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        ),
        onSubmitted: (value) {
          _fetchWeather(value);
        },
      ),
    );
  }


  // Fungsi pembantu untuk membangun kartu umum
  Widget _buildCard({required Widget child, EdgeInsets? padding, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF2C2C2C).withOpacity(0.8), // Warna kartu default atau kustom
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16.0),
      child: child,
    );
  }

  // Kartu Kualitas Udara (didesain ulang sesuai gambar baru)
  Widget _buildAirQualityCard() {
    return _buildCard(
      color: Colors.blue.shade700.withOpacity(0.8), // Warna biru untuk kartu ini
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Sedang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              // Teks 'Sedang' dan angka 63 di kanan
              Text(
                '63',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Kualitas udara dapat diterima; namun, bagi beberapa polutan mungkin ada ke...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 63 / 100, // Contoh nilai 0-100
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.greenAccent, // Warna indikator
            minHeight: 8,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  // Bagian Prakiraan Per Jam
  Widget _buildHourlyForecast() {
    // Data dummy untuk prakiraan per jam
    final List<Map<String, dynamic>> hourlyData = [
      {'time': 'Sekarang', 'temp': '29°', 'icon': Icons.wb_cloudy_outlined},
      {'time': '17.00', 'temp': '29°', 'icon': Icons.wb_cloudy_outlined},
      {'time': '17.18', 'temp': '29°', 'icon': Icons.wb_sunny_outlined}, // Icon matahari di tengah
      {'time': '18.00', 'temp': '28°', 'icon': Icons.wb_cloudy_outlined},
      {'time': '19.00', 'temp': '28°', 'icon': Icons.wb_cloudy_outlined},
      {'time': '20.00', 'temp': '27°', 'icon': Icons.cloud_outlined},
      {'time': '21.00', 'temp': '26°', 'icon': Icons.cloud_outlined},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prakiraan Per Jam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 120, // Tinggi tetap untuk scroll horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hourlyData[index]['time']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        hourlyData[index]['icon']!,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hourlyData[index]['temp']!,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Prakiraan Harian
  Widget _buildDailyForecast() {
    // Data dummy untuk prakiraan harian
    final List<Map<String, dynamic>> dailyData = [
      {'date': '18 Jun', 'day': 'Hari ini', 'temp': '25°/31°', 'icon': Icons.wb_cloudy_outlined},
      {'date': '19 Jun', 'day': 'Besok', 'temp': '24°/31°', 'icon': Icons.cloud_outlined},
      {'date': '20 Jun', 'day': 'Jum', 'temp': '25°/30°', 'icon': Icons.umbrella_outlined}, // Contoh hujan
      {'date': '21 Jun', 'day': 'Sab', 'temp': '25°/31°', 'icon': Icons.wb_sunny_outlined},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prakiraan 4 Hari', // Judul opsional
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${dailyData[index]['date']} ${dailyData[index]['day']}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        dailyData[index]['icon']!,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        dailyData[index]['temp']!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
