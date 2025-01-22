import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_pete/pov_pete/models/location.dart';
import 'package:flutter_pete/pov_pete/models/polylines.dart';
import 'package:flutter_pete/pov_pete/network/location_service.dart';
import 'package:flutter_pete/pov_pete/screens/Drive_screen.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  List<Location> _stops = []; // Daftar lokasi halte
  List<RoutePolyline> _polylines = []; // Daftar polyline rute
  final MapController _mapController = MapController();
  bool _isLoading = true; // Status loading
  bool _isJourneyStarted = false; // Status perjalanan

  @override
  void initState() {
    super.initState();
    _fetchStops(); // Ambil data halte saat inisialisasi
  }

  // Fungsi untuk mengambil data lokasi halte
  Future<void> _fetchStops() async {
    try {
      final stops = await _locationService.getKoordinatHalte();
      setState(() {
        _stops = stops;
      });
      _fetchRoutes(); // Ambil data rute setelah data halte didapatkan
    } catch (e) {
      print('Error fetching stops: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk mengambil data rute
  Future<void> _fetchRoutes() async {
    try {
      // Buat waypoints dari daftar halte
      String waypoints = _stops.map((stop) => '${stop.lon},${stop.lat}').join(';');
      print('Waypoints: $waypoints'); // Debug waypoints

      // Ambil data rute melingkar
      final routeData = await _locationService.getCircularRoute(waypoints);
      print('Route Data: $routeData'); // Debug respons API

      // Decode polyline dari respons API
      if (routeData['routes'] != null && routeData['routes'].isNotEmpty) {
        final geometry = routeData['routes'][0]['geometry'];
        final points = _decodePolyline(geometry);

        setState(() {
          _polylines.add(RoutePolyline(points: points, color: Colors.blue));
          _isLoading = false; // Matikan loading setelah data diterima
        });
      } else {
        print('Data rute tidak valid atau kosong');
        setState(() {
          _isLoading = false; // Matikan loading jika data tidak valid
        });
      }
    } catch (e) {
      print('Error fetching route: $e');
      setState(() {
        _isLoading = false; // Matikan loading jika terjadi error
      });
    }
  }

  // Fungsi untuk decode polyline dari format OSRM
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

  // Fungsi untuk menampilkan dialog konfirmasi mulai perjalanan
  void _showStartJourneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mulai Perjalanan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Anda akan memulai perjalanan untuk narik di sepanjang trayek berikut:",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Trayek A",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Rute berangkat: Pasar Butung – Sulawesi – Riburane Achmad Yani (Balaikota) – Jendral Sudirman – Ratulangi (MaRI) – Landak – Veteran – Sultan Alauddin – Syech Yusuf – BTN Minasa Upa",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                "ANDA TIDAK DAPAT MENGUBAH STATUS SELAMA MEMBAWA PENUMPANG",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                setState(() {
                  _isJourneyStarted = true; // Mulai perjalanan
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverScreen(
                      trayekName: "Trayek A",
                      goRoute: "BTN Minasa Upa – Syech Yusuf – Sultan Alauddin – Andi Tonro – Kumala – Ratulangi – Jendral Sudirman (Karebosi Timur) – HOS Cokroaminoto (Sentral) – KH. Wahid Hasyim – Wahidin Sudirohusodo – Pasar Butung",
                      backRoute: "Pasar Butung – Sulawesi – Riburane Achmad Yani (Balaikota) – Jendral Sudirman – Ratulangi (MaRI) – Landak – Veteran – Sultan Alauddin – Syech Yusuf – BTN Minasa Upa",
                      routePoints: _polylines.isNotEmpty ? _polylines[0].points : [],
                      passengerCount: 0, // Jumlah penumpang awal
                    ),
                  ),
                );
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa memulai perjalanan
              },
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trayek A'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(-5.2299394697095245, 119.50211253693419), // Pusat peta di Unhas Teknik Gowa
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _stops.map((stop) {
                  return Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(stop.lat, stop.lon),
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  );
                }).toList(),
              ),
              PolylineLayer(
                polylines: _polylines.map((polyline) {
                  return Polyline(
                    points: polyline.points,
                    color: polyline.color,
                    strokeWidth: 4.0,
                  );
                }).toList(),
              ),
            ],
          ),
          if (!_isJourneyStarted)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  _showStartJourneyDialog(context); // Tampilkan dialog konfirmasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Mulai Perjalanan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}