import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  // Item Details
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/shoes.jpg'), // Ganti dengan path gambar Anda
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Perjalanan",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Offers Section - Tiket
                  Text("Tiket", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(3), // Lebar kolom pertama
                        1: FlexColumnWidth(1), // Lebar kolom kedua
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      children: [
                        // Header
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Harga", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        // Row 1
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Perjalanan"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("\u20B9 3,000.0"),
                          ),
                        ]),
                        // Row 2
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Tiket"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("\u20B9 7,000.0"),
                          ),
                        ]),
                        // Divider Row
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("\u20B9 10,000.0", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment Methods
                  Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  PaymentMethodCard(
                    title: "OVO",
                    icon: Icons.account_balance_wallet,
                    onTap: () {
                      _showPaymentConfirmation(context, "OVO");
                    },
                  ),
                  PaymentMethodCard(
                    title: "QRIS",
                    icon: Icons.qr_code,
                    onTap: () {
                      _showPaymentConfirmation(context, "QRIS");
                    },
                  ),
                  Spacer(),

                  // Pay Now Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF42C8DC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Bayar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Custom Back Button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(51, 83, 232, 255),
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
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF42C8DC)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Pembayaran"),
          content: Text("Anda memilih metode pembayaran: $method. Lanjutkan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pembayaran melalui $method berhasil dipilih.")),
                );
              },
              child: Text("Lanjutkan"),
            ),
          ],
        );
      },
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentMethodCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
