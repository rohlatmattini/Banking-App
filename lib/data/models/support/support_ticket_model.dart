// lib/data/models/support/support_ticket_model.dart
class SupportTicket {
  final String publicId;
  final String subject;
  final String status;

  SupportTicket({
    required this.publicId,
    required this.subject,
    required this.status,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      publicId: json['public_id'],
      subject: json['subject'],
      status: json['status'],
    );
  }
}
