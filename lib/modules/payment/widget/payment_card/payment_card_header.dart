import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/payment/scheduled_transfer.dart';

class PaymentCardHeader extends StatelessWidget {
  final ScheduledTransfer transfer;

  const PaymentCardHeader({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            transfer.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '${transfer.amount.toStringAsFixed(2)} ${transfer.currency}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: transfer.status == 'active' ? Colors.green : AppColor.darkgreen,
          ),
        ),
      ],
    );
  }
}