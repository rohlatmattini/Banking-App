import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/payment/scheduled_transfer.dart';
import '../../controller/payment_controller.dart';
import '../add_payment/add_payment_page.dart';

class PaymentCardActions extends StatelessWidget {
  final ScheduledTransfer transfer;

  const PaymentCardActions({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();

    return Row(
      children: [
        // زر تفعيل/تعطيل
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              final newStatus = transfer.status == 'active' ? 'paused' : 'active';
              controller.updateTransferStatus(transfer.publicId, newStatus);
            },
            icon: Icon(
              transfer.status == 'active' ? Icons.pause : Icons.play_arrow,
              size: 18,
            ),
            label: Text(
              transfer.status == 'active' ? 'Pause' : 'Activate',
              style: TextStyle(color: AppColor.subtitleColor),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // في PaymentCardActions

        // زر الحذف
        IconButton(
          icon: Icon(Icons.delete, color: AppColor.red),
          onPressed: () => _confirmDelete(controller),
        ),
      ],
    );
  }

  void _confirmDelete(PaymentController controller) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this scheduled transfer?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: AppColor.white,
      onConfirm: () {
        controller.deleteTransfer(transfer.publicId);
        Get.back();
      },
    );
  }
}