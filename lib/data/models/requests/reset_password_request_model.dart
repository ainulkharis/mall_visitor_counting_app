import 'dart:convert';

class ResetPasswordRequestModel {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }

  String toJson() => json.encode(toMap());
}
