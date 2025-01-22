import 'dart:convert'; // Import package untuk base64Decode
import 'dart:typed_data'; // Import Uint8List
import 'package:flutter/material.dart';
import 'package:flutter_pete/pov_customer/screen/Notification.dart';
import 'package:flutter_pete/pov_pete/network/api.dart';
import 'package:flutter_pete/pov_pete/screens/History.dart';
import 'package:flutter_pete/pov_pete/screens/edit_profile.dart';
import 'package:flutter_pete/pov_pete/screens/faq_screen.dart';
import 'package:flutter_pete/pov_pete/screens/login_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String userToken;

  const ProfileScreen({Key? key, required this.username, required this.userToken}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Network _network;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _network = Network();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await _network.getData('/profile'); // Endpoint profil
      print('Profile Response: ${response.body}'); // Log respons profil

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userProfile = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Method untuk handle logout
  Future<void> _handleLogout() async {
  try {
    await _network.logout(widget.userToken); // Panggil method logout dari Network
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigasi ke LoginScreen setelah logout
    );
  } catch (e) {
    setState(() {
      _errorMessage = 'Failed to log out: $e';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to log out: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _userProfile?['user']['foto_profil'] != null
                          ? _buildImageFromBase64(_userProfile!['user']['foto_profil']) // Tampilkan foto profil dari Base64
                          : null, // Jika foto profil null, backgroundImage akan null
                      child: _userProfile?['user']['foto_profil'] == null
                          ? const Icon(Icons.person, size: 50) // Ikon default jika foto profil tidak ada
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userProfile?['user']['nama'] ?? 'who are you?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userProfile?['user']['email'] ?? 'login!!!', // Menampilkan email
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF42C8DC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    userProfile: _userProfile!,
                                    userToken: widget.userToken,
                                  ),
                                ),
                              ).then((isUpdated) {
                                if (isUpdated == true) {
                                  _fetchProfile(); // Perbarui data profil setelah edit
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Icon(Icons.person_outline, color: Colors.white, size: 30),
                                const SizedBox(height: 5),
                                Text('Profile', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '0', // Menampilkan jumlah tiket (bisa disesuaikan)
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Tickets', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NotificationScreen()),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(Icons.notifications_outlined, color: Colors.white, size: 30),
                                const SizedBox(height: 5),
                                Text('Notifications', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          ProfileOption(
                            icon: Icons.help_outline,
                            title: 'FAQ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FAQScreen(username: widget.username, userToken: widget.userToken),
                                ),
                              );
                            },
                          ),
                          ProfileOption(
                            icon: Icons.history,
                            title: 'Riwayat Trayek',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryScreen(username: "User"),
                                ),
                              );
                            },
                          ),
                          ProfileOption(
                            icon: Icons.logout,
                            title: 'Log Out',
                            onTap: _handleLogout, // Panggil method _handleLogout saat tombol logout ditekan
                            isLogout: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: widget.username, userToken: widget.userToken),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(username: "User"),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FAQScreen(username: widget.username, userToken: widget.userToken),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(username: widget.username, userToken: widget.userToken),
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

  // Fungsi untuk mengonversi Base64 ke Image
  ImageProvider _buildImageFromBase64(String base64String) {
    final Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red : Colors.white, // Mengubah warna untuk log out
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.white : Colors.black54),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}