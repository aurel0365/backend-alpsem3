import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'user_profile.dart';

class ProfileService {
  final String baseUrl = 'https://your-api-url.com'; // Ganti dengan URL API Anda
  final String token; // Token autentikasi

  ProfileService({required this.token});

  // Fetch profile data
  Future<UserProfile> fetchProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update profile data
  Future<void> updateProfile(UserProfile updatedProfile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedProfile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  // Upload profile image (optional)
  Future<void> uploadProfileImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-profile-image'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('profile_photo', image.path));

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }
}