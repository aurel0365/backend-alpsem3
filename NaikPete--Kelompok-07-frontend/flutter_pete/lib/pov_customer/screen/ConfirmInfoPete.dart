import 'package:flutter/material.dart';

import 'MetodePembayaran.dart';

class Confirmpete extends StatelessWidget {
  final List<String> ruteAlternatif = [
    "Rute Alternatif 1: Mall Panakkukang – Jalan Boulevard Panakkukang – Jalan AP Pettarani – Jalan Dr. Ratulangi – Jalan Haji Bau – Jalan Penghibur – Ciputra",
    "Rute Alternatif 2: Mall Panakkukang – Jalan Boulevard Panakkukang – Jalan Dr. Ratulangi – Jalan Haji Bau – Jalan Penghibur – Ciputra",
    "Rute Alternatif 3: Mall Panakkukang – Jalan Boulevard Panakkukang – Jalan AP Pettarani – Jalan Haji Bau – Ciputra",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Search Bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 60), // Jarak awal dari atas
                      SearchBar(hintText: "Cari Lokasimu saat ini"),
                      SizedBox(height: 16), // Jarak antar SearchBar
                      SearchBar(hintText: "Tujuan Anda"),
                    ],
                  ),
                ),
                // Map Placeholder
                Expanded(
                  child: Container(
                    color: Colors.white, // Warna latar belakang seragam
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // DraggableScrollableSheet for Bottom Panel
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang seragam
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Garis untuk penarik
                      Container(
                        width: 50,
                        height: 4,
                        margin: EdgeInsets.only(top: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Pete-pete A",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.favorite_border, color: Colors.red),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text("19 Km", style: TextStyle(fontSize: 14)),
                                    SizedBox(width: 24),
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Text("4.8 Rating", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Mall Panakkukang – Jalan Boulevard Panakkukang – Jalan AP Pettarani – Jalan Dr. Ratulangi – Jalan Haji  – Ciputra",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.5, // Menambahkan line-height untuk keterbacaan
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Saran Rute Tercepat: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: ruteAlternatif.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Menampilkan dialog konfirmasi saat rute dipilih
                                          _showConfirmationDialog(context, ruteAlternatif[index]);
                                        },
                                        child: Text(
                                          "• ${ruteAlternatif[index]}",
                                          style: TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Custom Back Button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(51, 83, 232, 255), // Latar belakang soft blue
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF42C8DC)), // Ikon biru
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke layar sebelumnya
                  },
                ),
              ),
            ),

            // **Fixed Bottom Panel for Cost and Next Button**
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white, // Latar belakang putih
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Biaya:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "3.000,00 IDR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentMethodScreen(), // Ganti HalamanSelanjutnya dengan layar tujuan
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF42C8DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        elevation: 2,
                      ),
                      child: Text(
                        "Selanjutnya",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context, String ruteTercepat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Rute"),
          content: Text("Apakah Anda yakin memilih rute ini?\n\n$ruteTercepat"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog jika "Tidak"
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog jika "Iya"
                // Mengupdate rute dengan rute tercepat yang dipilih
                // Gantilah rute yang ada dengan rute tercepat
                print("Rute diperbarui dengan: $ruteTercepat");
                // Di sini Anda dapat memperbarui state atau menggunakan provider
              },
              child: Text("Iya"),
            ),
          ],
        );
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;

  const SearchBar({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}