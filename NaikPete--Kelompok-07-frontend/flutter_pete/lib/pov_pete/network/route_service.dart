import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  final String baseUrl =
      'http://127.0.0.1:8000/api'; // Replace with your actual API URL

  Future<List<LatLng>> fetchRoute(List<LatLng> locations) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/route'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'locations': locations
              .map((loc) => {'lat': loc.latitude, 'lon': loc.longitude})
              .toList()
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assume the API returns a list of points for the route
        List<LatLng> route = (data['route'] as List)
            .map((point) => LatLng(point['lat'], point['lon']))
            .toList();
        return route;
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBusStops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/busStops'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['stops']);
      } else {
        throw Exception('Failed to load bus stops');
      }
    } catch (e) {
      throw Exception('Error fetching bus stops: $e');
    }
  }
}
