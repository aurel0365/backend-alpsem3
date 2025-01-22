import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildCustomBackButton(context),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Notifikasi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListView(
          children: [
            NotificationTile(
              title: 'Pesan Baru',
              message: 'Anda memiliki pesan baru dari John.',
              time: '2 menit lalu',
              icon: Icons.message,
            ),
            NotificationTile(
              title: 'Pembaruan Aplikasi',
              message: 'Pembaruan baru tersedia untuk aplikasi.',
              time: '1 jam lalu',
              icon: Icons.system_update,
            ),
            NotificationTile(
              title: 'Peringatan Sistem',
              message: 'Penyimpanan Anda hampir penuh.',
              time: 'Kemarin',
              icon: Icons.warning,
            ),
          ],
        ),
      ),
    );
  }

  // Custom Back Button
  Widget _buildCustomBackButton(BuildContext context) {
    return Container(
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
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  const NotificationTile({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF42C8DC).withOpacity(0.2),
          child: Icon(icon, color: const Color(0xFF42C8DC)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () {
          // Handle notification tap (e.g., open detailed view)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title tapped!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
