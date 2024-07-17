import 'dart:convert';

class ProfileResponseModel {
  String? avatar;
  String? email;
  String? name;

  ProfileResponseModel({
    this.avatar,
    this.email,
    this.name,
  });

  factory ProfileResponseModel.fromJson(String str) => ProfileResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileResponseModel.fromMap(Map<String, dynamic> json) =>
  ProfileResponseModel(
    avatar: json["avatar"],
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "avatar": avatar,
    "email": email,
    "name": name,
  };
}
