import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart'; // Pastikan path ini benar
import 'package:weather_app/weather_model.dart'; // Pastikan path ini benar

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
// Halaman Dashboard Cuaca (Slide 1) - DINAMIS
// =========================================================================
class WeatherDashboardPage extends StatefulWidget {
  const WeatherDashboardPage({super.key});

  @override
  State<WeatherDashboardPage> createState() => _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  // --- KOREKSI ADA DI SINI ---
  // Deklarasi WeatherService yang benar
  final WeatherService _weatherService = WeatherService();
  // Deklarasi TextEditingController yang benar
  final TextEditingController _citySearchController = TextEditingController();
  // --- END KOREKSI ---

  Weather? _currentWeather; // Untuk menyimpan data cuaca saat ini
  bool _isLoading = false; // Status loading
  String? _error; // Pesan error jika ada


  // Inisialisasi state, ambil cuaca default saat aplikasi dimulai
  @override
  void initState() {
    super.initState();
    _fetchWeather('Jakarta'); // Ambil cuaca untuk kota default (misal Jakarta) saat aplikasi pertama kali dimuat
  }

  // Fungsi untuk mengambil data cuaca dari API
  Future<void> _fetchWeather(String cityName) async {
    if (cityName.isEmpty) {
      setState(() {
        _error = 'Nama kota tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Set loading true saat memulai fetch
      _error = null; // Hapus error sebelumnya
      _currentWeather = null; // Hapus data cuaca sebelumnya
    });

    try {
      final weather = await _weatherService.fetchWeather(cityName);
      setState(() {
        _currentWeather = weather; // Simpan data cuaca yang berhasil
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat cuaca untuk $cityName. Coba lagi. (${e.toString()})'; // Simpan pesan error
      });
    } finally {
      setState(() {
        _isLoading = false; // Set loading false setelah fetch selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // TextField pencarian kota
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: _citySearchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari kota...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        suffixIcon: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        _fetchWeather(value); // Panggil fetchWeather saat tombol enter ditekan
                      },
                    ),
                  ),

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
                        Text(
                          _currentWeather!.cityName,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${_currentWeather!.temperature.toStringAsFixed(0)}°C', // Tampilkan suhu tanpa desimal
                              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Image.network(
                              _weatherService.getWeatherIconUrl(_currentWeather!.iconCode),
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 80, color: Colors.white54),
                            ),
                          ],
                        ),
                        Text(
                          _currentWeather!.description.toUpperCase(), // Deskripsi cuaca
                          style: const TextStyle(fontSize: 24, color: Colors.white70),
                        ),
                        const SizedBox(height: 30),
                        // Bagian lainnya dari slide 1 tetap statis untuk saat ini,
                        // tetapi Anda bisa menghubungkannya ke data API jika OpenWeatherMap menyediakannya
                        _buildAirQualityCard(), // Ini masih pakai data statis
                        const SizedBox(height: 20),
                        _buildDetailedInfoGrid(), // Ini masih pakai data statis
                        const SizedBox(height: 20),
                        _buildSunriseSunsetCard(context), // Ini masih pakai data statis
                        const SizedBox(height: 20),
                        _buildLifestyleTips(), // Ini masih pakai data statis
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
        ],
      ),
    );
  }

  // Fungsi untuk membangun AppBar kustom
  SliverAppBar _buildCustomAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 80.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueGrey.shade900.withOpacity(0.8),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0, top: 20.0),
        child: Text(
          'Trasak',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 20.0),
          child: Row(
            children: [
              // Tombol untuk menavigasi ke halaman kelola kota
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageCitiesPage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
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
      floating: true,
      pinned: false,
    );
  }

  // Fungsi pembantu untuk membangun kartu umum
  Widget _buildCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C).withOpacity(0.8),
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

  // Fungsi untuk membangun kartu Kualitas Udara (masih statis)
  Widget _buildAirQualityCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kualitas udara',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Sedang 59',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 59 / 100,
            backgroundColor: Colors.grey.shade700,
            color: Colors.greenAccent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun Grid Informasi Detail Cuaca (masih statis)
  Widget _buildDetailedInfoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildInfoGridItem(
          icon: Icons.wb_sunny_outlined,
          title: 'UV',
          value: '0 Sangat le...',
        ),
        _buildInfoGridItem(
          icon: Icons.thermostat_outlined,
          title: 'Terasa seperti',
          value: '29 °',
        ),
        _buildInfoGridItem(
          icon: Icons.water_drop_outlined,
          title: 'Kelembaban',
          value: '89 %',
        ),
        _buildInfoGridItem(
          icon: Icons.wind_power,
          title: 'Angin STG',
          value: '3 mpj',
        ),
        _buildInfoGridItem(
          icon: Icons.compress,
          title: 'Tekanan udara',
          value: '1.011 hPa',
        ),
        _buildInfoGridItem(
          icon: Icons.visibility_outlined,
          title: 'Visibilitas',
          value: '14 km',
        ),
      ],
    );
  }

  // Fungsi pembantu untuk item dalam Grid Informasi Detail
  Widget _buildInfoGridItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return _buildCard(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun kartu Terbit/Terbenam Matahari (masih statis)
  Widget _buildSunriseSunsetCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.wb_sunny_outlined, size: 24, color: Colors.white),
              const Text(
                'Terbit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                    trackShape: const RectangularSliderTrackShape(),
                    activeTrackColor: Colors.amberAccent,
                    inactiveTrackColor: Colors.blueGrey.shade800,
                  ),
                  child: Slider(
                    value: 0.6,
                    onChanged: (value) {
                      // Ini slider statis untuk tampilan
                    },
                  ),
                ),
              ),
              const Text(
                'Terbenam',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const Icon(Icons.nights_stay_outlined, size: 24, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '05.35',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '17.17',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun bagian Kiat Gaya Hidup (masih statis)
  Widget _buildLifestyleTips() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kiat gaya hidup',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildLifestyleTipItem(
                icon: Icons.local_florist_outlined,
                text: 'Very low pollen count',
              ),
              _buildLifestyleTipItem(
                icon: Icons.umbrella_outlined,
                text: 'High UV index',
              ),
              _buildLifestyleTipItem(
                icon: Icons.clean_hands_outlined,
                text: 'Use oil-control products',
              ),
              _buildLifestyleTipItem(
                icon: Icons.directions_car_outlined,
                text: 'Suitable for car washing',
              ),
              _buildLifestyleTipItem(
                icon: Icons.directions_run_outlined,
                text: 'Suitable for indoor workouts',
              ),
              _buildLifestyleTipItem(
                icon: Icons.directions_bus_outlined,
                text: 'Good traffic conditions',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu untuk item Kiat Gaya Hidup
  Widget _buildLifestyleTipItem({
    required IconData icon,
    required String text,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Latar belakang ikon lebih gelap transparan
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// Halaman Kelola Kota (Slide 2)
// =========================================================================
class ManageCitiesPage extends StatelessWidget {
  const ManageCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Kelola kota',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              // Aksi untuk mengurutkan kota
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCityWeatherCard(
                    cityName: 'Trasak',
                    temperature: '27°',
                    airQuality: '54 - Bagus',
                    description: 'Cerah berawan',
                    cardColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context); // Kembali ke dashboard
                      // Untuk fungsi yang lebih canggih, gunakan provider/bloc untuk manajemen state lintas halaman.
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCityWeatherCard(
                    cityName: 'Blumbungan',
                    temperature: '27°',
                    airQuality: '49 - Luar biasa',
                    description: 'Cerah berawan',
                    cardColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context); // Kembali ke dashboard
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCityWeatherCard(
                    cityName: 'Pamekasan',
                    temperature: '26°',
                    airQuality: '58 - Bagus',
                    description: 'Hujan sebentar',
                    cardColor: Colors.blueGrey.shade800,
                    onTap: () {
                      Navigator.pop(context); // Kembali ke dashboard
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Tambah kota baru');
          // Anda bisa menambahkan dialog atau navigasi ke halaman input kota baru di sini
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Fungsi untuk membangun Search Bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.white54),
          hintText: 'Cari',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Fungsi untuk membangun Kartu Cuaca Kota
  Widget _buildCityWeatherCard({
    required String cityName,
    required String temperature,
    required String airQuality,
    required String description,
    required Color cardColor,
    VoidCallback? onTap, // Parameter untuk aksi onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  temperature,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Kualitas udara: $airQuality',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}