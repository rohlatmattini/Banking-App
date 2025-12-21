import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';
import '../../../core/constants/app_color.dart';
import '../controller/payment_controller.dart';
import '../widget/add_payment/add_payment_page.dart';
import '../widget/payment_header.dart';
import '../widget/payment_list.dart';


class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // المحتوى الرئيسي
            RefreshIndicator(
              onRefresh: () async => await controller.loadScheduledTransfers(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    PaymentsHeader(),
                    PaymentsList(),
                    const SizedBox(height: 100), // 🔥 مساحة للزر العائم
                  ],
                ),
              ),
            ),

            // 🔥 الزر العائم داخل Stack
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => AddPaymentPage());
                },
                backgroundColor: AppColor.darkgreen, // يمكنك تغيير اللون
                child: Icon(Icons.add, color: AppColor.white),
              ),
            ),
          ],
        ),
      ),

      // 🔥 إزالة floatingActionButton من Scaffold
      // floatingActionButton: FloatingActionButton(...),
    );
  }
}