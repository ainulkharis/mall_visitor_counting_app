import 'dart:convert';

class LoginResponseModel {
  final String accessToken;

  LoginResponseModel({
    required this.accessToken
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      accessToken: map['access_token'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) => LoginResponseModel.fromMap(json.decode(source));
}
