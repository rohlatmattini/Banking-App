import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_links.dart';

class SupportApi {
  final http.Client _client = http.Client();

  Future<List<dynamic>> getTickets(String token) async {
    final response = await _client.get(
      Uri.parse('${AppLinks.baseUrl}/v1/support/tickets'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('GET TICKETS STATUS: ${response.statusCode}');
    print('GET TICKETS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else if (response.statusCode == 401) {
      throw Exception('Unauthenticated');
    } else {
      throw Exception('Failed to fetch tickets. Status: ${response.statusCode}');
    }
  }

  Future<void> createTicket({
    required String token,
    required String subject,
    required String message,
  }) async {
    final response = await _client.post(
      Uri.parse('${AppLinks.baseUrl}/v1/support/tickets'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'subject': subject,
        'message': message,
      }),
    );

    print('CREATE TICKET STATUS: ${response.statusCode}');
    print('CREATE TICKET BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthenticated');
    } else {
      throw Exception('Failed to create ticket. Status: ${response.statusCode}');
    }
  }


  Future<void> updateTicketStatus({
    required String token,
    required String ticketId,
    required String status,
  }) async {
    try {
      final response = await _client.patch(
        Uri.parse(
          '${AppLinks.baseUrl}/v1/support/tickets/$ticketId/status',
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': status}),
      );

      print('PATCH STATUS: ${response.statusCode}');
      print('PATCH BODY: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update ticket status');
      }
    } catch (e) {
      print('ERROR updateTicketStatus: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTicketDetails({
    required String token,
    required String ticketId,
  }) async {
    final response = await _client.get(
      Uri.parse('${AppLinks.baseUrl}/v1/support/tickets/$ticketId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('GET TICKET DETAILS STATUS: ${response.statusCode}');
    print('GET TICKET DETAILS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data']; // 🔥 كل التفاصيل
    } else if (response.statusCode == 401) {
      throw Exception('Unauthenticated');
    } else {
      throw Exception('Failed to fetch ticket details. Status: ${response.statusCode}');
    }
  }

}