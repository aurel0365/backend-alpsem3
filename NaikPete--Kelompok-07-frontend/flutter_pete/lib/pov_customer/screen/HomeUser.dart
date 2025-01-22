import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pete/pov_pete/screens/Halte_screen.dart';
import '../widget/BottomNavBar.dart'; // Pastikan path ini sesuai
import 'ConfirmInfoPete.dart';
import 'JadwalBerangkat.dart';
import 'Notification.dart';
import 'PencarianPete.dart';
import 'ProfileUser.dart';
import 'Tiket.dart';
import 'package:carousel_slider/carousel_slider.dart';
class HomeScreens extends StatefulWidget {
  final String username; // Parameter username
  final String userToken; // Parameter userToken

  const HomeScreens({super.key, required this.username, required this.userToken});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreens> {
  int _selectedIndex = 0;
  late List<Widget> _screens; // Deklarasikan _screens sebagai late

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi _screens di dalam initState
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
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  final String username;
  final String userToken;

  const HomeScreenBody({super.key, required this.username, required this.userToken});

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final List<String> imageUrls = [
    'lib/pov_customer/assets/images/berita1.jpg', // Pastikan path gambar benar
    'lib/pov_customer/assets/images/berita2.jpg', // Pastikan path gambar benar
  ];

  late PageController _pageController;
  int _currentPage = 0;

  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Timer untuk mengontrol auto-scroll setiap 3 detik
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < imageUrls.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _locationController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundCarousel(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildWelcomeSection(context, widget.username), // Bagian selamat datang
                const SizedBox(height: 20),
                _buildSearchBar(), // Bar pencarian
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
        ),
      ],
    );
  }

  Widget _buildBackgroundCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlay: true,
        viewportFraction: 1.0,
      ),
      items: imageUrls.map((url) {
        return Image.asset(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }).toList(),
    );
  }

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
                color: Colors.white,
                fontFamily: 'Montserrat',
                shadows: [
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 4.0,
                    color: Colors.black54,
                  ),
                ],
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
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    shadows: [
                      Shadow(
                        offset: Offset(1.5, 1.5),
                        blurRadius: 4.0,
                        color: Colors.black54,
                      ),
                    ],
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
                color: const Color.fromARGB(150, 66, 200, 220),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildLocationInput(Icons.location_on, "Lokasi anda saat ini", Colors.cyan, _locationController),
          const SizedBox(height: 16),
          _buildLocationInput(Icons.location_on, "Tujuan anda saat ini", Colors.red, _destinationController),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                String location = _locationController.text;
                String destination = _destinationController.text;

                if (location.isEmpty || destination.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tujuan anda atau lokasi anda kosong!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Confirmpete(
                        currentLocation: location,
                        destination: destination,
                        selectedRoute: '',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42C8DC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cari", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput(IconData icon, String hintText, Color color, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: color,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildServiceCard(context, Icons.directions_bus, "Transportasi", Colors.blue, Pencarianpete()),
        _buildServiceCard(context, Icons.location_on, "Halte", Colors.red, HalteListScreen()),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title, Color color, Widget targetScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

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