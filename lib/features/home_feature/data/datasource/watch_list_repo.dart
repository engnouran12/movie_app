import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

class WatchlistRepository {
  final String apiKey;
  final String sessionId;
  final String accountId;

  WatchlistRepository({
    required this.apiKey,
    required this.sessionId,
    required this.accountId,
  });

  Future<void> addToWatchlist(String movieId, bool add) async {
    final url = 'https://api.themoviedb.org/3/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': add,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update watchlist');
    }
  }

  Future<List<Movie>> getWatchlist() async {
    final url = 'https://api.themoviedb.org/3/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> moviesJson = jsonResponse['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load watchlist');
    }
  }
}
