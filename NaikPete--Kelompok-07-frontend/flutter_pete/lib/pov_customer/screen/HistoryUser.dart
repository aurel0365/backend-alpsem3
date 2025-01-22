import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Warna putih untuk latar belakang AppBar
          foregroundColor: Colors.black, // Warna hitam untuk teks dan ikon
          elevation: 0,
          title: const Text(
            'Sejarah Perjalanan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF42C8DC), // Warna biru untuk teks tab aktif
            unselectedLabelColor: Colors.grey, // Warna abu-abu untuk teks tab non-aktif
            indicatorColor: Color(0xFF42C8DC), // Garis bawah tab aktif (biru)
            indicatorWeight: 3.0,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Dalam Perjalanan'),
              Tab(text: 'Transaksi'),
              Tab(text: 'Perjalanan Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(), // Smooth scroll physics
          children: [
            const Center(child: Text('Dalam Perjalanan')),
            const TransactionHistory(),
            const Center(child: Text('Perjalanan Selesai')),
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan history transaksi
class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, // Jumlah data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://via.placeholder.com/80', // Ganti dengan gambar asli
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: const Text(
              '11 Nov, 07.00',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // Teks hitam untuk judul
              ),
            ),
            subtitle: const Text(
              'MP – Jalan Boulevard\nPanakkukang – Jalan Pettarani – Jalan Veteran',
              style: TextStyle(
                height: 1.5,
                color: Colors.black54, // Warna hitam transparan untuk subtitle
              ),
            ),
            trailing: const Text(
              'Lihat detail',
              style: TextStyle(
                color: Color(0xFF42C8DC), // Biru untuk teks trailing
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Aksi ketika item ditekan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Detail transaksi ke-${index + 1}')),
              );
            },
          ),
        );
      },
    );
  }
}