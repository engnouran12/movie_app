class Movie {
  final String id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;

    Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage
  });


  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id:json['title'],
      title: json['title'],
      overview: json['overview'],
      posterPath: 'https://image.tmdb.org/t/p/w500' + json['poster_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}
