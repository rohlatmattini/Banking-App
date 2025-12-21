import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_links.dart';
import '../../models/transaction/transaction_request.dart';

class TransactionApi {
  final String token;

  TransactionApi({required this.token});

  Future<Map<String, dynamic>> transfer(TransferRequest request) async {
    final url = Uri.parse('${AppLinks.baseUrl}/v1/transactions/transfer');

    final headers = {
      'Accept': 'application/json',
      'Idempotency-Key': DateTime.now().microsecondsSinceEpoch.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // سجل كل شيء بالتفصيل
    print('\n🚀 === TRANSFER API REQUEST ===');
    print('📤 URL: $url');
    print('🔑 Token (first 20 chars): ${token.substring(0, min(20, token.length))}...');
    print('📦 Headers: ${json.encode(headers)}');
    print('📝 Request Body:');
    print(json.encode(request.toJson()));
    print('============================\n');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('\n📥 === TRANSFER API RESPONSE ===');
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Headers: ${response.headers}');
      print('📋 Response Body:');
      print(response.body);
      print('==============================\n');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else if (response.statusCode == 500) {
        print('❌ SERVER ERROR 500');
        print('Full response: ${response.body}');
        throw Exception('Server Error (500): Please contact support');
      } else {
        print('❌ Request Failed with status: ${response.statusCode}');
        throw Exception('Failed to transfer: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ HTTP Client Exception: $e');
      throw Exception('Network error: $e');
    } catch (e) {
      print('❌ Unexpected Error: $e');
      rethrow;
    }
  }

  int min(int a, int b) => a < b ? a : b;
}