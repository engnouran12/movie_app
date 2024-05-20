import 'package:equatable/equatable.dart';

class RequestTokenModel extends Equatable{
  //1
  final bool success;
  final String requestToken;
  final String expiresAt;
  RequestTokenModel({
    required this.success,
    required this.requestToken,
    required this.expiresAt,
  });
  //2
  factory RequestTokenModel.fromJson(Map<String, dynamic> json) {
    return RequestTokenModel(
      success: json['success'],
      requestToken: json['request_token'],
      expiresAt: json['expires_at'],
    );
  }
  //3
  Map<String, dynamic> toJson() => {
        'request_token': requestToken,
      };
      
        @override
        // TODO: implement props
        List<Object?> get props=> [
          success,
          requestToken,
          expiresAt

        ];
}