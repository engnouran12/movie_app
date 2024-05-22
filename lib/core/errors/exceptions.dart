
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class UserException implements Exception {
  final String message;
  UserException(this.message);
}
