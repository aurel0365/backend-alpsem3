import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Lihatlokasi extends StatefulWidget {
  const Lihatlokasi({super.key});

  @override
  _LihatlokasiState createState() => _LihatlokasiState();
}

class _LihatlokasiState extends State<Lihatlokasi> {
  final MapController mapController = MapController();
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    // Set lokasi default saat inisialisasi
    selectedLocation = LatLng(-5.1481182373483705, 119.39554496743399);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna putih untuk latar belakang AppBar
        foregroundColor: Colors.black, // Warna hitam untuk teks dan ikon
        elevation: 0,
        title: const Text(
          'Lokasi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildMapWithLocationPicker(),
    );
  }

  Widget _buildMapWithLocationPicker() {
    return Stack(
      children: [
        // Peta
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: selectedLocation ?? LatLng(-5.1481182373483705, 119.39554496743399), // Pusat peta ke lokasi default
            zoom: 15.0,
            onTap: (tapPosition, latLng) {
              setState(() {
                selectedLocation = latLng; // Update lokasi yang dipilih
              });
            },
          ),
          children: [
            // Layer peta dari OpenStreetMap
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            // Menampilkan marker jika lokasi dipilih
            if (selectedLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation!,
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
        // Menampilkan card dengan koordinat lokasi terpilih
        if (selectedLocation != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lokasi Terpilih",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Latitude: ${selectedLocation!.latitude.toStringAsFixed(6)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Longitude: ${selectedLocation!.longitude.toStringAsFixed(6)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}