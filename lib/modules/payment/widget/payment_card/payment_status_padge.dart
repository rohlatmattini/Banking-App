import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/payment/scheduled_transfer.dart';

class PaymentStatusBadge extends StatelessWidget {
  final ScheduledTransfer transfer;
  final bool isOverdue;

  const PaymentStatusBadge({
    super.key,
    required this.transfer,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    if (transfer.status == 'paused') {
      return _badge('Paused', AppColor.grey);
    } else if (transfer.status == 'cancelled') {
      return _badge('Cancelled', AppColor.red);
    } else if (isOverdue) {
      return _badge('Overdue', AppColor.red);
    } else if (transfer.status == 'active') {
      return _badge('Active', AppColor.green);
    }
    return _badge('Pending', AppColor.orange);
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}