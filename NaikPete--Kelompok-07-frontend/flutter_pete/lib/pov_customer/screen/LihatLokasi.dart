import 'package:flutter/material.dart';

class Lihatlokasi extends StatelessWidget {
  const Lihatlokasi({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab (Semua Jadwal & Terdekat)
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Warna putih untuk latar belakang AppBar
          foregroundColor: Colors.black, // Warna hitam untuk teks dan ikon
          elevation: 0,
          title: const Text(
            'Lokasi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}