import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;

class AccountApi {
  final String baseUrl;
  final FlutterSecureStorage storage;

  AccountApi({required this.baseUrl, required this.storage});

  Future<List<Map<String, dynamic>>> fetchAccountsRaw() async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token missing');

    final response = await http.get(
      Uri.parse('$baseUrl/v1/accounts'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) throw Exception('Failed to fetch accounts');

    final List data = json.decode(response.body)['data'];
    return List<Map<String, dynamic>>.from(data);
  }
}
