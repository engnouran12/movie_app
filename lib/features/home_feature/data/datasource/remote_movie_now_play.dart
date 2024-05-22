import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/const.dart';
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

class MovieRepository {
  final String apiKey;

  MovieRepository({required this.apiKey});

  Future<List<Movie>> getNowPlayingMovies(int page) async {
    final url =
        '$baseUrl/movie/now_playing?api_key=$apiKey&page=$page';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> moviesJson = jsonResponse['results'];
      print(moviesJson);
      print(moviesJson.map((json) => Movie.fromJson(json)).toList());
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
