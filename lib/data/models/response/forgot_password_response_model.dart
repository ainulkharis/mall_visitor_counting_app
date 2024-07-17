import 'dart:convert';

ForgotPasswordResponseModel forgotPasswordResponseModelFromJson(String str) => ForgotPasswordResponseModel.fromJson(json.decode(str));

String forgotPasswordResponseModelToJson(ForgotPasswordResponseModel data) => json.encode(data.toJson());

class ForgotPasswordResponseModel {
    final String message;

    ForgotPasswordResponseModel({
      required this.message
    });

    factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => ForgotPasswordResponseModel(
      message: json["message"]
    );

    Map<String, dynamic> toJson() => {
      "message": message
    };
}
