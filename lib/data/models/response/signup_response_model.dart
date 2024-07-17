import 'dart:convert';

class SignupResponseModel {
  bool? error;
  String? message;

  SignupResponseModel({
    this.error,
    this.message,
  });

  factory SignupResponseModel.fromJson(String str) => SignupResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SignupResponseModel.fromMap(Map<String, dynamic> json) =>
  SignupResponseModel(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "message": message,
  };
  
  @override
  String toString() {
    return 'SignupResponseModel(error: $message, message: $message)';
  }
}
