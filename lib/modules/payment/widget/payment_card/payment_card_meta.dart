import 'package:banking_system/modules/payment/widget/payment_card/payment_status_padge.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/payment/scheduled_transfer.dart';

class PaymentCardMeta extends StatelessWidget {
  final ScheduledTransfer transfer;
  final bool isOverdue;

  const PaymentCardMeta({
    super.key,
    required this.transfer,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _typeChip(transfer.type),
            const SizedBox(width: 8),
            _frequencyChip(transfer.frequency),
            const Spacer(),
            PaymentStatusBadge(transfer: transfer, isOverdue: isOverdue),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: AppColor.grey),
            const SizedBox(width: 4),
            Text(
              'Next: ${_formatDate(transfer.nextRunAt)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Spacer(),
            Text(
              'Time: ${transfer.runTime}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeChip(String type) {
    Color color;
    switch (type) {
      case 'transfer':
        color = Colors.blue;
      case 'withdraw':
        color = Colors.orange;
      case 'deposit':
        color = Colors.green;
      default:
        color = AppColor.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _frequencyChip(String frequency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.subtitleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        frequency.toUpperCase(),
        style: TextStyle(
          color: AppColor.subtitleColor,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not scheduled';
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Tomorrow';
    if (difference.inDays > 1) return 'In ${difference.inDays} days';
    return '${date.day}/${date.month}/${date.year}';
  }
}