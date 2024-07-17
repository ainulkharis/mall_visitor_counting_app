import 'dart:convert';

class PasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  PasswordRequestModel({required this.currentPassword, required this.newPassword});

  Map<String, dynamic> toMap() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }

  factory PasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return PasswordRequestModel(
      currentPassword: map['current_password'] ?? '',
      newPassword: map['new_password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordRequestModel.fromJson(String source) =>
      PasswordRequestModel.fromMap(json.decode(source));
}
