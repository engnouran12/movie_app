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
    final String? sessionId = await sharedPrefService!.getSessionId();
    final String? accountId = (await sharedPrefService!.getUser())?.id.toString();

    if (sessionId == null || accountId == null) {
      throw Exception('Session ID or Account ID not found');
    }

    final url =
        'https://api.themoviedb.org/3/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': true,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to update watchlist');
    }
  }

Future<void> removeToWatchlist(String movieId, bool add) async {
    final String? sessionId = await sharedPrefService!.getSessionId();
    final String? accountId = (await sharedPrefService!.getUser())?.id.toString();

    if (sessionId == null || accountId == null) {
      throw Exception('Session ID or Account ID not found');
    }

    final url =
        'https://api.themoviedb.org/3/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': false,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to update watchlist');
    }
  }








  Future<List<Movie>> getWatchlist() async {
    final String? sessionId = await sharedPrefService!.getSessionId();
    final String? accountId = (await sharedPrefService!.getUser())?.id.toString();

    if (sessionId == null || accountId == null) {
      throw Exception('Session ID or Account ID not found');
    }

    final url =
        '$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId';
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
/////////////
///
