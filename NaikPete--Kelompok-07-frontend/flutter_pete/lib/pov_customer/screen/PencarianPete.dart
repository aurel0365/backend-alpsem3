import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Pencarianpete(),
  ));
}

class Pencarianpete extends StatefulWidget {
  @override
  _PencarianpeteState createState() => _PencarianpeteState();
}

class _PencarianpeteState extends State<Pencarianpete> {
  String currentLocation = "Mendeteksi lokasi...";
  String destination = "";
  LatLng? userLatLng;
  List<LatLng> routePoints = [];
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentLocation = "Layanan lokasi tidak aktif";
      });
      return;
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = "Izin lokasi ditolak";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation = "Izin lokasi ditolak secara permanen";
      });
      return;
    }

    // Dapatkan lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Dapatkan nama jalan dari koordinat menggunakan Nominatim
    final address = await getAddressFromLatLng(position.latitude, position.longitude);
    setState(() {
      userLatLng = LatLng(position.latitude, position.longitude);
      currentLocation = address;
    });

    // Pindahkan peta ke lokasi pengguna
    mapController.move(userLatLng!, 15.0);
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["address"] != null) {
        return data["address"]["road"] ?? "Alamat tidak ditemukan";
      }
    }
    return "Alamat tidak ditemukan";
  }

  Future<void> _searchRoute() async {
    if (userLatLng == null || destination.isEmpty) {
      return;
    }

    // Dapatkan koordinat tujuan menggunakan Nominatim
    final destinationCoordinates = await getCoordinatesFromAddress(destination);
    if (destinationCoordinates == null) {
      print("Gagal mendapatkan koordinat tujuan.");
      return;
    }

    // Dapatkan rute dari GraphHopper
    final apiKey = "4585cd0b-2f46-437c-9868-3645837b62e3"; // API key GraphHopper
    final url = Uri.parse(
        "https://graphhopper.com/api/1/route?point=${userLatLng!.latitude},${userLatLng!.longitude}&point=${destinationCoordinates.latitude},${destinationCoordinates.longitude}&vehicle=car&key=$apiKey");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["paths"] != null && data["paths"].isNotEmpty) {
        final points = data["paths"][0]["points"];
        setState(() {
          routePoints = _decodePolyline(points);
        });
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?format=json&q=$address");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]["lat"]);
        final lng = double.parse(data[0]["lon"]);
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      SearchBar(hintText: "Cari Lokasimu saat ini"),
                      SizedBox(height: 16),
                      SearchBar(
                        hintText: "Tujuan Anda",
                        onChanged: (value) {
                          setState(() {
                            destination = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: userLatLng == null
                      ? Center(child: CircularProgressIndicator())
                      : FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            center: userLatLng,
                            zoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: userLatLng!,
                                  builder: (ctx) => Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routePoints,
                                  color: Colors.blue,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Lokasi Anda saat ini",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentLocation,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _searchRoute,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildCustomBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBackButton(BuildContext context) {
    return Positioned(
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
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const SearchBar({required this.hintText, this.onChanged});

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
        onChanged: onChanged,
      ),
    );
  }
}