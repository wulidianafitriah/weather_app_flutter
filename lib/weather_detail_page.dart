import 'package:flutter/material.dart';

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Membuat body bisa di belakang appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Tanpa shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Tombol kembali putih
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        actions: [
          // Search Bar di dalam AppBar
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // Latar belakang transparan gelap
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'The\nWeather\nChannel', // Placeholder untuk logo "The Weather Channel"
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari Kode Pos',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isDense: true, // Mengurangi padding internal
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white54, size: 20), // Ikon pencarian
                  SizedBox(width: 8),
                  Icon(Icons.person_outline, color: Colors.white54, size: 20), // Ikon profil
                  SizedBox(width: 8),
                  Icon(Icons.menu, color: Colors.white, size: 20), // Ikon menu
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header Utama Cuaca
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0).copyWith(top: MediaQuery.of(context).padding.top + kToolbarHeight), // Sesuaikan padding atas dengan status bar dan appbar
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade800.withOpacity(0.8), // Gradien biru gelap
                    Colors.blue.shade500.withOpacity(0.8),
                    Colors.blue.shade300.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Memberi sedikit ruang dari appbar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '28°', // Suhu utama
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Gambar ikon cuaca
                      // Menggunakan placeholder image, ganti dengan ikon dari API nanti
                      Image.network(
                        'https://placehold.co/100x100/000000/FFFFFF?text=%E2%98%81', // Placeholder icon (cloud with sun emoji)
                        // 'https://openweathermap.org/img/wn/04d@2x.png', // Contoh ikon OpenWeatherMap
                        color: Colors.white, // Agar ikon jadi putih jika placeholder adalah SVG atau bisa diwarnai
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 100, color: Colors.white), // Fallback icon
                      ),
                    ],
                  ),
                  const Text(
                    'Sebagian Berawan', // Deskripsi cuaca
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Siang 31° • Malam 25°', // Suhu siang/malam
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Kartu "Terasa Spt"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C).withOpacity(0.8), // Warna kartu transparan gelap
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
                      crossAxisAlignment: CrossAxisAlignment.end, // Agar ikon sejajar di bawah
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Terasa Spt',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '33°',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.wb_sunny_outlined, size: 40, color: Colors.white), // Ikon matahari
                            const SizedBox(height: 5),
                            Row(
                              children: const [
                                Icon(Icons.arrow_upward, size: 16, color: Colors.white70),
                                Text('5.35', style: TextStyle(color: Colors.white)),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_downward, size: 16, color: Colors.white70),
                                Text('17.17', style: TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Daftar Detail Cuaca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C).withOpacity(0.8), // Warna kartu transparan gelap
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
                  children: [
                    _buildDetailRow(Icons.thermostat_outlined, 'Maks/Min', '31°/25 °'),
                    _buildDivider(),
                    _buildDetailRow(Icons.water_drop_outlined, 'Angin', '< 11 km/j', icon2: Icons.arrow_back), // Ikon panah kiri
                    _buildDivider(),
                    _buildDetailRow(Icons.opacity_outlined, 'Kelembapan', '84 %'),
                    _buildDivider(),
                    _buildDetailRow(Icons.bubble_chart, 'Titik Embun', '25 °'), // Icon placeholder, ganti jika ada
                    _buildDivider(),
                    _buildDetailRow(Icons.bar_chart, 'Tekanan', '↑1012.2 mb'), // Icon placeholder, ganti jika ada
                    _buildDivider(),
                    _buildDetailRow(Icons.wb_sunny_outlined, 'Indeks UV', '1 dari 11'),
                    _buildDivider(),
                    _buildDetailRow(Icons.remove_red_eye_outlined, 'Jarak Pandang', 'Tak Terbatas'),
                    _buildDivider(),
                    _buildDetailRow(Icons.nightlight_round, 'Fase Bulan', 'Benjol Akhir'), // Icon placeholder, ganti jika ada
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sponsored Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sponsored Content',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150, // Tinggi placeholder
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800, // Warna latar belakang placeholder
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Iklan / Konten Sponsor Di Sini',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Ruang untuk bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9), // Warna gelap untuk bottom bar
        selectedItemColor: Colors.blueAccent, // Warna ikon/teks yang dipilih
        unselectedItemColor: Colors.white70, // Warna ikon/teks yang tidak dipilih
        type: BottomNavigationBarType.fixed, // Memastikan semua item terlihat
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Hari Ini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Per jam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: '15 Hari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radar_outlined),
            label: 'Radar',
          ),
        ],
        onTap: (index) {
          // Aksi ketika item bottom bar ditekan
          print('Bottom bar item $index ditekan');
        },
      ),
    );
  }

  // Fungsi pembantu untuk baris detail cuaca
  Widget _buildDetailRow(IconData icon, String title, String value, {IconData? icon2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Colors.white70),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (icon2 != null) ...[
                Icon(icon2, size: 18, color: Colors.white70),
                const SizedBox(width: 5),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu untuk divider di daftar detail
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }
}