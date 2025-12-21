import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_color.dart';
import 'controller/ticket_details_controller.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String ticketId;
  final String token;

  TicketDetailsScreen({super.key, required this.ticketId, required this.token});

  final TicketDetailsController controller = Get.put(TicketDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.loadTicketDetails(token, ticketId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: AppColor.darkgreen,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ticket = controller.ticketData;

        if (ticket.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        final messages = ticket['messages'] as List<dynamic>? ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket['subject'] ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Status: ${ticket['status']}'),
              const Divider(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final sender = msg['sender'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(sender != null ? sender['name'] : 'Unknown'),
                        subtitle: Text(msg['body']),
                        trailing: Text(
                          (msg['created_at'] ?? '').substring(0, 10),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
