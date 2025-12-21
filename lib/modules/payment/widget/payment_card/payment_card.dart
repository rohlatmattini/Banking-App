import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/payment/scheduled_transfer.dart';
import 'payment_card_actions.dart';
import 'payment_card_header.dart';
import 'payment_card_meta.dart';

class PaymentCard extends StatelessWidget {
  final ScheduledTransfer transfer;

  const PaymentCard({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final isActive = transfer.status == 'active';
    final isOverdue = transfer.nextRunAt != null &&
        transfer.nextRunAt!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive
              ? AppColor.green
              : isOverdue
              ? AppColor.red
              : AppColor.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PaymentCardHeader(transfer: transfer),
            const SizedBox(height: 8),
            PaymentCardMeta(transfer: transfer, isOverdue: isOverdue),
            const SizedBox(height: 12),
            PaymentCardActions(transfer: transfer),
          ],
        ),
      ),
    );
  }
}