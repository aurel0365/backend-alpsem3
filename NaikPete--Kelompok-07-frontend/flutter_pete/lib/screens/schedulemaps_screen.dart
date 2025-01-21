import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_pete/models/location.dart';
import 'package:flutter_pete/models/polylines.dart';
import 'package:flutter_pete/network/location_service.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  List<Location> _stops = [];
  List<RoutePolyline> _polylines = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchStops();
  }

  Future<void> _fetchStops() async {
    try {
      final stops = await _locationService.getKoordinatHalte();
      setState(() {
        _stops = stops;
      });
      _fetchRoutes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchRoutes() async {
    try {
      // Buat waypoints dari daftar halte
      String waypoints = _stops.map((stop) => '${stop.lon},${stop.lat}').join(';');
      print('Waypoints: $waypoints'); // Debug waypoints

      // Ambil data rute melingkar
      final routeData = await _locationService.getCircularRoute(waypoints);
      print('Route Data: $routeData'); // Debug respons API

      // Decode polyline dari respons API
      final geometry = routeData['routes'][0]['geometry'];
      final points = _decodePolyline(geometry);

      setState(() {
        _polylines.add(RoutePolyline(points: points, color: Colors.blue));
      });
    } catch (e) {
      print('Error fetching route: $e'); // Debug error
    }
  }


  // Decode polyline dari format OSRM
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
      appBar: AppBar(
        title: Text('Map with Stops and Routes'),
      ),
      body: FlutterMap(
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
    );
  }
}