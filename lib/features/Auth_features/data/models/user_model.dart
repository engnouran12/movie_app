class User {
  final String id;
  final String name;
  final String email;
  final String profilePath;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      profilePath: 'https://image.tmdb.org/t/p/w500' + (json['profile_path'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_path': profilePath,
    };
  }
}
