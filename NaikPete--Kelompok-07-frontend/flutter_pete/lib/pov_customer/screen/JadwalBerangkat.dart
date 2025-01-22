import 'package:flutter/material.dart';
import 'LihatLokasi.dart';

class Jadwalberangkat extends StatelessWidget {
  const Jadwalberangkat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF42C8DC), // Warna latar belakang biru
        foregroundColor: Colors.white,
        elevation: 4,
        automaticallyImplyLeading: false,
        toolbarHeight: 100, 
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Jadwal Berangkat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5), 
          ],
        ),
        centerTitle: true,
      ),
      body: const JadwalSemua(),
    );
  }
}

class JadwalSemua extends StatefulWidget {
  const JadwalSemua({super.key});

  @override
  _JadwalSemuaState createState() => _JadwalSemuaState();
}

class _JadwalSemuaState extends State<JadwalSemua> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _jadwal = [
    {
      'time': '11 Nov, 07.00',
      'route': 'MP – Jalan Boulevard\nPanakkukang – Jalan Pettarani – Jalan Veteran',
    },
    {
      'time': '12 Nov, 08.00',
      'route': 'Jalan Sejahtera – Mall XYZ',
    },
    {
      'time': '13 Nov, 09.00',
      'route': 'Jalan Sudirman – Plaza ABC',
    },
    {
      'time': '14 Nov, 10.00',
      'route': 'Jalan Merdeka – Pasar Tradisional',
    },
    {
      'time': '15 Nov, 11.00',
      'route': 'Jalan Veteran – Kampus UC',
    },
  ];
  List<Map<String, String>> _filteredJadwal = [];

  @override
  void initState() {
    super.initState();
    _filteredJadwal = _jadwal;
  }

  void _filterJadwal(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredJadwal = _jadwal;
      } else {
        _filteredJadwal = _jadwal
            .where((item) => item['time']!.toLowerCase().contains(query.toLowerCase()) ||
                item['route']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromRGBO(66, 200, 220, 1.0), 
                ),
                hintText: "Silahkan Mencari Jadwal...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: _filterJadwal,
            ),
          ),
        ),
        Expanded(
          child: _filteredJadwal.isEmpty
              ? Center(
                  child: Text(
                    'Tidak mendapatkan hasil pencarian',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredJadwal.length,
                  itemBuilder: (context, index) {
                    final jadwal = _filteredJadwal[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://via.placeholder.com/80',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          jadwal['time']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          jadwal['route']!,
                          style: const TextStyle(
                            height: 1.5,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: const Text(
                          'Lihat lokasi',
                          style: TextStyle(
                            color: Color(0xFF42C8DC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Lihatlokasi(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
