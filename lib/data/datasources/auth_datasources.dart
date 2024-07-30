import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mall_visitor_counting/data/localsources/auth_local_storage.dart';
import 'package:mall_visitor_counting/data/models/requests/signup_request_model.dart';
import 'package:mall_visitor_counting/data/models/requests/login_request_model.dart';
import 'package:mall_visitor_counting/data/models/requests/password_request_model.dart';
import 'package:mall_visitor_counting/data/models/response/edit_profile_response_model.dart';
import 'package:mall_visitor_counting/data/models/response/forgot_password_response_model.dart';
import 'package:mall_visitor_counting/data/models/response/login_response_model.dart';
import 'package:mall_visitor_counting/data/models/response/profile_response_model.dart';
import 'package:mall_visitor_counting/data/models/response/signup_response_model.dart';

class AuthDatasource {
  final baseUrl = 'http://194.31.53.102:21090'; // URL VPS Bitvise SSH Client
  final String apiKey = 'YWludWxraGFyaXMwNEBnbWFpbC5jb206a2hhcmlzMTIz'; // Encode youremail@gmail.com:yourpassword into Base64 string

  Future<SignupResponseModel> signup(SignupRequestModel signupRequestModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-api-key': apiKey,
      },
      body: signupRequestModel.toMap(),
    );

    if (response.statusCode == 201) {
      final result = SignupResponseModel.fromJson(response.body);
      return result;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    // Menggabungkan email dan password
    String credentials ='${loginRequestModel.email}:${loginRequestModel.password}';

    // Melakukan encoding Base64
    String base64Credentials = base64Encode(utf8.encode(credentials));

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Authorization': 'Basic $base64Credentials',
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return LoginResponseModel.fromMap(jsonResponse);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  Future<ProfileResponseModel> getProfile() async {
    final token = await AuthLocalStorage().getToken();
    var headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('$baseUrl/protected'),
      headers: headers,
    );

    final result = ProfileResponseModel.fromJson(response.body);
    return result;
  }

  Future<EditProfileResponseModel> editProfile({
    File? avatar,
    String? name,
    String? email,
  }) async {
    final token = await AuthLocalStorage().getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey
    };

    var request = MultipartRequest('PUT', Uri.parse('$baseUrl/edit_profile'));
    request.headers.addAll(headers);

    request.fields['name'] = name!;
    request.fields['email'] = email!;

    if (avatar != null) {
      request.files.add(await MultipartFile.fromPath('file', avatar.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final result = EditProfileResponseModel.fromJson(responseBody);
      return result;
    } else {
      throw Exception('Gagal memperbarui profil!');
    }
  }

  Future<EditProfileResponseModel> changePassword(
      PasswordRequestModel passwordRequestModel) async {
    final token = await AuthLocalStorage().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/change_password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-api-key': apiKey,
      },
      body: passwordRequestModel.toMap(),
    );

    if (response.statusCode == 200) {
      final result = EditProfileResponseModel.fromJson(response.body);
      return result;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  Future<ForgotPasswordResponseModel> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot_password'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-api-key': apiKey
        },
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        return ForgotPasswordResponseModel.fromJson(json.decode(response.body));
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('Gagal mengirim email reset kata sandi: ${responseBody['message']}');
      }
    } catch (e) {
      throw Exception('Gagal mengirim email reset kata sandi: ${e.toString()}');
    }
  }

  // Method untuk validasi token
  Future<void> validateToken(String token) async {
    final url = '$baseUrl/reset_password/$token';
    print('Memvalidasi token menggunakan URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Respon validasi token: $responseBody');
    } else {
      final responseBody = jsonDecode(response.body);
      print('Validasi token gagal: $responseBody');
      throw Exception('Token tidak valid atau kadaluarsa: ${responseBody['message']}');
    }
  }

  // Method untuk reset password
  Future<void> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    final url = '$baseUrl/reset_password/$token';
    print('Mereset kata sandi menggunakan URL: $url');
    final response = await http.post(
      Uri.parse(url),
      body: {
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Respon reset kata sandi: $responseBody');
    } else {
      final responseBody = jsonDecode(response.body);
      print('Gagal mereset kata sandi: $responseBody');
      throw Exception('Gagal mereset kata sandi: ${responseBody['message']}');
    }
  }
}
