import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/const.dart';
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';
import 'package:movie_app/features/Auth_features/data/datasource/local_data_source.dart';

class WatchlistRepository {
  final String? apiKey;
  final SharedPrefService sharedPrefService;

  WatchlistRepository({
    this.apiKey,
    required this.sharedPrefService,
  });

  Future<void> addToWatchlist(String movieId, bool add) async {
    final String? sessionId = await sharedPrefService.getSessionId();
    final String? accountId = (await sharedPrefService.getUser())?.id.toString();

    if (sessionId == null || accountId == null) {
      throw Exception('Session ID or Account ID not found');
    }

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
    if (response.statusCode != 201) {
      print('Failed to update watchlist: ${response.body}');
      throw Exception('Failed to update watchlist: ${response.body}');
    } else {
      print('Watchlist update successful: ${response.body}');
    }
  }

  Future<void> removeFromWatchlist(String movieId) async {
    await addToWatchlist(movieId, false);
  }

  Future<List<Movie>> getWatchlist() async {
    final String? sessionId = await sharedPrefService.getSessionId();
    final String? accountId = (await sharedPrefService.getUser())?.id.toString();

    if (sessionId == null || accountId == null) {
      throw Exception('Session ID or Account ID not found');
    }

    final url = '$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> moviesJson = jsonResponse['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      print('Failed to load watchlist: ${response.body}');
      throw Exception('Failed to load watchlist: ${response.body}');
    }
  }

  // Method to get a single movie by ID (if required)
  Future<Movie> getMovieById(String movieId) async {
    final url = '$baseUrl/movie/$movieId?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse);
    } else {
      print('Failed to load movie details: ${response.body}');
      throw Exception('Failed to load movie details: ${response.body}');
    }
  }
}
