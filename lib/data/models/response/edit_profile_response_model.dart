import 'dart:convert';

class EditProfileResponseModel {
  String? message;
  bool emailRequiresConfirmation;

  EditProfileResponseModel({this.message, required this.emailRequiresConfirmation});

  factory EditProfileResponseModel.fromJson(String str) => EditProfileResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EditProfileResponseModel.fromMap(Map<String, dynamic> json) =>
    EditProfileResponseModel(
      message: json["message"],
      emailRequiresConfirmation: json["emailRequiresConfirmation"] ?? false,
    );

  Map<String, dynamic> toMap() => {
    "message": message,
    "emailRequiresConfirmation": emailRequiresConfirmation
  };
}
