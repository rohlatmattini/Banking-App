import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_controller.dart';
import 'payment_card/payment_card.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scheduled Transfers:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.scheduledTransfers.isEmpty) {
              return const Center(
                child: Text('No scheduled transfers found'),
              );
            }

            return Column(
              children: controller.scheduledTransfers
                  .map((transfer) => PaymentCard(transfer: transfer))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}