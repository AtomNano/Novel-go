class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profilePhoto;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePhoto,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profilePhoto: json['profile_photo'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_photo': profilePhoto,
      'address': address,
    };
  }
}
