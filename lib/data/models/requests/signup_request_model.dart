import 'dart:convert';

class SignupRequestModel {
  final String name;
  final String email;
  final String password;

  SignupRequestModel({
    required this.name,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password
    };
  }

  factory SignupRequestModel.fromMap(Map<String, dynamic> map) {
    return SignupRequestModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory SignupRequestModel.fromJson(String source) =>
      SignupRequestModel.fromMap(json.decode(source));
}
