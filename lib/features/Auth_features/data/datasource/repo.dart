import 'package:movie_app/features/Auth_features/data/models/request_model.dart';

abstract class AuthenticationRemoteDataSource {
  //1
   Future<void> 
  getRequestToken();
  //2
  Future<RequestTokenModel>
   validateWithLogin(Map<String, dynamic> requestBody);
  //3
  Future<void> createSession(Map<String, dynamic> requestBody);
}