import 'dart:convert';
import 'package:flutter_pete/models/location.dart';
import 'package:http/http.dart' as http;


class LocationService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Anda

  // Method untuk mengambil data rute
  Future<Map<String, dynamic>> getRoute(double startLat, double startLon, double endLat, double endLon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/route?start_lat=$startLat&start_lon=$startLon&end_lat=$endLat&end_lon=$endLon'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load route');
    }
  }

  // Method untuk mengambil data rute melingkar
  Future<Map<String, dynamic>> getCircularRoute(String waypoints) async {
  final response = await http.get(
    Uri.parse('$baseUrl/circular-route?waypoints=$waypoints'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load circular route. Status code: ${response.statusCode}');
  }
}

  Future<List<Location>> getKoordinatHalte() async {
    final response = await http.get(Uri.parse('$baseUrl/koordinat-halte'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stops');
    }
  }

}