import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_color.dart';
import '../controller/transaction_controller.dart';
import '../widget/external_transfer/external_transfer_form.dart';
import '../widget/internal_transfer/internal_transfer_form.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();

    return Column(
      children: [
        TabBar(
          controller: controller.tabController,
          indicator:  UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2.0,
              color: AppColor.darkgreen,
            ),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          labelColor: AppColor.darkgreen,
          unselectedLabelColor: AppColor.black,
          tabs: const [
            Tab(text: 'My Accounts'),
            Tab(text: 'Another Accounts'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: const [
              InternalTransferForm(),
              ExternalTransferForm(),
            ],
          ),
        ),
      ],
    );
  }
}