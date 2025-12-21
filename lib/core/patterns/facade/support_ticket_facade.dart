// lib/core/patterns/facade/support_facade.dart
import '../../../data/apis/support/support_ticket_api.dart';
import '../../../data/models/support/support_ticket_model.dart';

class SupportFacade {
  final SupportApi _api = SupportApi();

  Future<List<SupportTicket>> fetchTickets(String token) async {
    final data = await _api.getTickets(token);
    return data.map((e) => SupportTicket.fromJson(e)).toList();
  }

  Future<void> createTicket({
    required String token,
    required String subject,
    required String message,
  }) {
    return _api.createTicket(
      token: token,
      subject: subject,
      message: message,
    );
  }

  Future<void> closeTicket({
    required String token,
    required String ticketId,
  }) {
    return _api.updateTicketStatus(
      token: token,
      ticketId: ticketId,
      status: 'closed',
    );
  }


  Future<Map<String, dynamic>> fetchTicketDetails({
    required String token,
    required String ticketId,
  }) {
    return _api.getTicketDetails(token: token, ticketId: ticketId);
  }

}
