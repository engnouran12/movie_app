import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/Auth_features/data/datasource/local_data_source.dart';
import 'package:movie_app/features/Auth_features/data/models/user_model.dart';

class TMDBAuth {
  final String apiKey;
   String requestToken;
  String sessionId;
  User ?currentUser;
  final SharedPrefService sharedPrefService;

  TMDBAuth({
     required this.apiKey,
     required this.currentUser,
   required this.requestToken,
  required this.sessionId,
    required this.sharedPrefService}
  );

  Future<void> getRequestToken() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      requestToken = data['request_token'];
    } else {
      throw Exception('Failed to get request token: ${response.body}');
    }
  }

  Future<void> validateWithLogin(String username, String password) async {
    if (requestToken == null) {
      throw Exception('Request token not found. Call getRequestToken first.');
    }

    final url = Uri.parse('https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey');
    final response = await http.post(
      url,
      body: json.encode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      requestToken = data['request_token'];
    } else {
      throw Exception('Failed to validate with login: ${response.body}');
    }
  }

  Future<void> createSession() async {
    if (requestToken == null) {
      throw Exception('Request token not found. Call validateWithLogin first.');
    }

    final url = Uri.parse('https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey');
    final response = await http.post(
      url,
      body: json.encode({'request_token': requestToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      sessionId = data['session_id'];
      await sharedPrefService!.saveSessionId(sessionId!);
      await _fetchUserDetails();
    } else {
      throw Exception('Failed to create session: ${response.body}');
    }
  }

  Future<void> _fetchUserDetails() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/account?api_key=$apiKey&session_id=$sessionId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      currentUser = User.fromJson(data);
      await sharedPrefService!.saveUser(currentUser!);
    } else {
      throw Exception('Failed to fetch user details: ${response.body}');
    }
  }

  Future<void> checkLoginStatus() async {
    sessionId = (await sharedPrefService.getSessionId())!;
    if (sessionId != null) {
      currentUser = (await sharedPrefService.getUser())!;
    }
  }

  Future<void> logout() async {
    await sharedPrefService.clearSessionId();
    await sharedPrefService.clearUser();
    sessionId = '';
    currentUser = null;
  }
}
