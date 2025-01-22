import 'package:flutter/material.dart';
import 'ConfirmTiket.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna putih untuk latar belakang AppBar
        foregroundColor: Colors.black, // Warna hitam untuk teks dan ikon
        elevation: 0,
        automaticallyImplyLeading: false, // Menghapus ikon back
        title: const Text(
          ' ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20), // Menambahkan padding ke seluruh body
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar tiket dengan bayangan
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800, // Maksimal lebar gambar
                        maxHeight: 400, // Maksimal tinggi gambar
                      ),
                      child: Image.asset(
                        'lib/pov_customer/assets/images/Tiket.png',
                        fit: BoxFit.cover, // Gambar tetap proporsional
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Nama tiket dengan font cantik
                LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize = constraints.maxWidth > 600 ? 28 : 24;
                    return Text(
                      "Tiket One Day",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF42C8DC),
                        shadows: [
                          Shadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Nikmati perjalanan seharian penuh dengan tiket satu hari.\nAkses ke seluruh rute tanpa batas!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                // Harga tiket
                const Text(
                  "Harga: IDR 7,000",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C8DC),
                  ),
                ),
                const SizedBox(height: 40),
                // Tombol untuk membeli tiket
                ElevatedButton(
                  onPressed: () {
                    // Arahkan ke layar Konfirmasi Pembelian
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TicketConfirmationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42C8DC),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.4),
                    elevation: 6,
                  ),
                  child: const Text(
                    "Beli Tiket",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
