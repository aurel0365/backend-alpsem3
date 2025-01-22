import 'package:flutter/material.dart';
import 'package:flutter_pete/pov_customer/screen/OpenFaq.dart';
import 'package:flutter_pete/pov_pete/screens/History.dart';
import 'package:flutter_pete/pov_pete/screens/home_screen.dart';
import 'package:flutter_pete/pov_pete/screens/profile_screen.dart';

class FAQScreen extends StatelessWidget {
  final String username;
  final String userToken;

  const FAQScreen({Key? key, required this.username, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> faqCategories = [
      {
        'category': 'Tentang Aplikasi Naik Pete\'',
        'faqs': [
          {
            'question': 'Apa itu aplikasi Naik Pete\'?',
            'answer':
                'Naik Pete\' adalah aplikasi yang mempermudah pemesanan pete-pete dan melihat rute terdekat.'
          },
          {
            'question': 'Bagaimana cara memesan pete-pete?',
            'answer':
                'Anda dapat memilih lokasi penjemputan dan tujuan, kemudian melakukan pemesanan melalui aplikasi.'
          },
          {
            'question': 'Apakah aplikasi ini berbayar?',
            'answer':
                'Aplikasi ini gratis untuk diunduh dan digunakan. Biaya perjalanan akan ditampilkan sebelum konfirmasi pemesanan.'
          },
        ]
      },
      {
        'category': 'Fitur Aplikasi',
        'faqs': [
          {
            'question': 'Bagaimana cara melihat rute terdekat?',
            'answer':
                'Gunakan fitur pencarian rute pada menu utama untuk melihat rute terdekat dari lokasi Anda.'
          },
          {
            'question': 'Apakah saya bisa melihat kapasitas kursi?',
            'answer':
                'Ya, Anda dapat melihat kapasitas kursi yang tersedia di setiap pete-pete sebelum memesan.'
          },
          {
            'question': 'Bagaimana cara melaporkan masalah?',
            'answer':
                'Anda dapat melaporkan masalah melalui menu Bantuan, lalu pilih kategori keluhan yang sesuai.'
          },
        ]
      }
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF42C8DC)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: username, userToken: userToken),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            color: Color(0xFF42C8DC),
            child: Text(
              'How can we help you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for help topics',
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: faqCategories.length,
              itemBuilder: (context, index) {
                final category = faqCategories[index];
                return ExpansionTile(
                  title: Text(
                    category['category'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF42C8DC),
                    ),
                  ),
                  children: (category['faqs'] as List).map((faq) {
                    return ListTile(
                      title: Text(
                        faq['question'],
                        style: TextStyle(color: Colors.black87),
                      ),
                      onTap: () {
                        // Navigate to detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FAQDetailPage(
                              question: faq['question'],
                              answer: faq['answer'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: 2,
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