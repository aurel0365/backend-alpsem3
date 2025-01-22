class UserProfile {
  final String name;
  final String email;
  final String username;
  final String phone;
  final String? profilePhotoUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    this.profilePhotoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'phone': phone,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}