import 'package:flutter/material.dart';
import 'package:flutter_pete/pov_pete/screens/Drive_screen.dart';
import 'package:flutter_pete/pov_pete/screens/faq_screen.dart';
import 'package:flutter_pete/pov_pete/screens/home_screen.dart';
import 'package:flutter_pete/pov_pete/screens/profile_screen.dart';

class HistoryScreen extends StatelessWidget {
  final String username; // Tambahkan parameter username
  final String userToken;

  const HistoryScreen({required this.username, Key? key, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Kembali ke HomeScreen, bukan halaman sebelumnya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: username, userToken: userToken),
              ),
            );
          },
        ),
        title: Text("Riwayat Trayek"),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final trip = history[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(trip.trayekName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rute berangkat: ${trip.goRoute}"),
                  Text("Rute balik: ${trip.backRoute}"),
                  Text("Waktu: ${trip.timestamp.toString()}"),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        showSelectedLabels: true, // Tampilkan teks saat item dipilih
        showUnselectedLabels: false, // Sembunyikan teks saat item tidak dipilih
        currentIndex: 1, // Index yang aktif
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FAQScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(username: username, userToken: userToken),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}