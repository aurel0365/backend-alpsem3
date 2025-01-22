import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Anda
  String? token;

  Network();

  // Method untuk mengambil token dari SharedPreferences
  Future<void> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
    } catch (e) {
      print('Error fetching token: $e');
      throw Exception('Failed to fetch token: $e');
    }
  }

  // Method untuk GET request
  Future<http.Response> getData(String apiURL) async {
    try {
      await _getToken(); // Ambil token sebelum melakukan request
      var fullUrl = Uri.parse('$_url$apiURL');
      final response = await http.get(
        fullUrl,
        headers: _setHeaders(),
      );

      _checkResponse(response); // Periksa respons
      return response;
    } catch (e) {
      print('Error in GET request: $e');
      rethrow;
    }
  }

  // Method untuk logout
  Future<void> logout(String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_url/logout'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      print('Logout Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        print('Logout successful');
      } else {
        throw Exception('Failed to log out: ${response.body}');
      }
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Error during logout: $e');
    }
  }

  // Method untuk PUT request dengan file upload
  Future<http.Response> putData(
    String endpoint, {
    required Map<String, String> body,
    Uint8List? fileBytes,
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$_url$endpoint');
      final request = http.MultipartRequest('PUT', uri);

      // Tambahkan header
      request.headers['Authorization'] = 'Bearer $token';

      // Tambahkan body
      request.fields.addAll(body);

      // Tambahkan file jika ada
      if (fileBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'profile_photo',
          fileBytes,
          filename: 'profile.jpg',
        ));
      }

      final response = await request.send();
      final http.Response httpResponse = await http.Response.fromStream(response);

      _checkResponse(httpResponse);
      return httpResponse;
    } catch (e) {
      print('Error in PUT request: $e');
      rethrow;
    }
  }

  // Method untuk mengatur headers
  Map<String, String> _setHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Method untuk memeriksa response
  void _checkResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('Request failed with status: ${response.statusCode} - ${response.body}');
    }
  }
}