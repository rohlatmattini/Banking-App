import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_links.dart';
import '../../models/payment/scheduled_transfer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ScheduledTransferApi {
  final String baseUrl = AppLinks.baseUrl;
  final storage = FlutterSecureStorage();

  Future<List<ScheduledTransfer>> getScheduledTransfers() async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/transactions/scheduled'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300)
      {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map((item) => ScheduledTransfer.fromJson(item)).toList();
      }
      throw Exception('Failed to load scheduled transfers');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ScheduledTransfer> createScheduledTransfer(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/transactions/scheduled'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300)
      {
        final jsonData = json.decode(response.body);
        // للحصول على التفاصيل الكاملة، نحتاج لجلبها بعد الإنشاء
        return await getScheduledTransferById(jsonData['scheduled_public_id']);
      }
      throw Exception('Failed to create scheduled transfer');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ScheduledTransfer> getScheduledTransferById(String publicId) async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/transactions/scheduled/$publicId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300)
      {
        final jsonData = json.decode(response.body);
        return ScheduledTransfer.fromJson(jsonData['data']);
      }
      throw Exception('Failed to load scheduled transfer');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateScheduledTransferStatus(String publicId, String status) async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/v1/transactions/scheduled/$publicId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': status}),
      );
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');


      if (response.statusCode >= 200 && response.statusCode < 300)
      {
        // throw Exception('Failed to update scheduled transfer status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteScheduledTransfer(String publicId) async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/v1/transactions/scheduled/$publicId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300)
      {
        ('Success to delete scheduled transfer');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}