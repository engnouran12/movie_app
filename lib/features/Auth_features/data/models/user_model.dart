class User {
  final String id;
  final String name;
  
  final String profilePath;

  User({
    required this.id,
    required this.name,
   
    required this.profilePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
     
      profilePath: 'https://image.tmdb.org/t/p/w500' + (json['profile_path'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      
      'profile_path': profilePath,
    };
  }
}
