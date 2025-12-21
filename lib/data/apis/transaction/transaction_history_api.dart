import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/app_links.dart';

class TransactionHistoryApi {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> _getToken() async {
    return await _storage.read(key: 'token') ?? '';
  }

  Future<Map<String, dynamic>> getMyTransactions() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${AppLinks.baseUrl}/v1/transactions?scope=mine'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('STATUS => ${response.statusCode}');
    print('BODY => ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load transactions');
  }

  Future<Map<String, dynamic>> getTransactionDetails(String publicId) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${AppLinks.baseUrl}/v1/transactions/$publicId?scope=mine',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load transaction details');
  }
}
