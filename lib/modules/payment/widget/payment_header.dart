import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../controller/payment_controller.dart';

class PaymentsHeader extends StatelessWidget {
  const PaymentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.darkgreen.withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text(
              'Total scheduled payments:',
              style: TextStyle(fontSize: 18, color: AppColor.white),
            ),
            const SizedBox(width: 8),
            Obx(() => Text(
              '${controller.totalMonthlyPayments.toStringAsFixed(2)} ',
              style: const TextStyle(
                fontSize: 28,
                color: AppColor.white,
              ),
            )),
          ],
        ),
      ),
    );
  }
}