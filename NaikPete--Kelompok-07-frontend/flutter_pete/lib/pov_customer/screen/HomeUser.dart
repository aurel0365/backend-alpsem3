import 'package:flutter/material.dart';
import '../widget/BottomNavBar.dart'; // Pastikan path ini sesuai
import 'JadwalBerangkat.dart'; // Pastikan path ini sesuai
import 'Notification.dart'; // Pastikan path ini sesuai
import 'PencarianPete.dart'; // Pastikan path ini sesuai
import 'ProfileUser.dart'; // Pastikan path ini sesuai
import 'Tiket.dart'; // Pastikan path ini sesuai

class HomeScreens extends StatefulWidget {
  final String username; // Parameter username
  final String userToken; // Parameter userToken

  const HomeScreens({super.key, required this.username, required this.userToken});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreens> {
  int _selectedIndex = 0; // Indeks untuk BottomNavigationBar

  // Method untuk menangani perubahan indeks BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Daftar layar yang akan ditampilkan di IndexedStack
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Inisialisasi _screens dengan username dan userToken
    _screens = [
      HomeScreenBody(username: widget.username, userToken: widget.userToken),
      Jadwalberangkat(),
      TicketScreen(),
      ProfileScreens(username: widget.username, userToken: widget.userToken),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex, // Tampilkan layar sesuai indeks yang dipilih
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Widget untuk body layar beranda (HomeScreenBody)
class HomeScreenBody extends StatelessWidget {
  final String username;
  final String userToken;

  const HomeScreenBody({super.key, required this.username, required this.userToken});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildWelcomeSection(context, username), // Bagian selamat datang
            const SizedBox(height: 20),
            _buildSearchBar(), // Bar pencarian
            const SizedBox(height: 20),
            _buildImageCarousel(), // Carousel gambar
            const SizedBox(height: 30),
            const Text(
              "Layanan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildServiceGrid(context), // Grid layanan
            const SizedBox(height: 30),
            _buildInfoSection(), // Bagian informasi
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian selamat datang
  Widget _buildWelcomeSection(BuildContext context, String username) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  username, // Menampilkan username
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 83, 232, 255),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF42C8DC),
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk bar pencarian
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: "Silahkan Mencari",
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Widget untuk carousel gambar
  Widget _buildImageCarousel() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: 3, // Jumlah banner
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'lib/pov_pete/assets/pete-pete.jpg', // Gambar banner
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk grid layanan
  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildFeatureCard(Icons.directions_bus, "Pete-pete", context, Pencarianpete()),
        _buildFeatureCard(Icons.location_on, "Halte", context, TicketScreen()),
      ],
    );
  }

  // Widget untuk kartu layanan
  Widget _buildFeatureCard(IconData icon, String label, BuildContext context, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF42C8DC)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian informasi
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Informasi Penting",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Cek jadwal keberangkatan pete-pete dan layanan lainnya langsung melalui aplikasi kami. Selalu update untuk fitur terbaru!",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}