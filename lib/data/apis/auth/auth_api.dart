import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_links.dart';
import '../../models/auth/signin_model.dart';

class AuthApi {
  Future<Map<String, dynamic>?> login(LoginModel model) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/v1/auth/login');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(model.toJson()),
      );

      print('Login Status: ${response.statusCode}');
      print('Login Body: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/v1/auth/change-password');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);
      print("Change Password Status: ${response.statusCode}");
      print("Change Password Response: ${response.body}");
      return json.decode(response.body);
    } catch (e) {
      print("Change Password Exception: $e");
      return null;
    }
  }
  Future<Map<String, dynamic>?> logout({required String token}) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/v1/auth/logout');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request('POST', uri);
      request.body = ''; // لا يوجد body
      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print("Logout Status: ${streamedResponse.statusCode}");
      print("Logout Response: $responseBody");

      if (streamedResponse.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        return {'error': streamedResponse.reasonPhrase};
      }
    } catch (e) {
      print("Logout Exception: $e");
      return null;
    }
  }


// Future<Map<String, dynamic>?> forgotPassword(String email) async {
  //   final uri = Uri.parse('${AppLinks.baseUrl}/password/forgot');
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json'
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode({"email": email}),
  //     );
  //
  //     print('Forgot Status: ${response.statusCode}');
  //     print('Forgot Body: ${response.body}');
  //
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print('Forgot Exception: $e');
  //     return null;
  //   }
  // }
  //
  // Future<Map<String, dynamic>?> resetPassword({
  //   required String email,
  //   required String code,
  //   required String password,
  //   required String confirmPassword,
  // }) async {
  //   final uri = Uri.parse('${AppLinks.baseUrl}/password/reset');
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json'
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode({
  //         "email": email,
  //         "code": code,
  //         "password": password,
  //         "password_confirmation": confirmPassword
  //       }),
  //     );
  //
  //     print('Reset Status: ${response.statusCode}');
  //     print('Reset Body: ${response.body}');
  //
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print('Reset Exception: $e');
  //     return null;
  //   }
  // }
}
