import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../home/controller/home_page_controller.dart';
import '../../controller/transaction_controller.dart';
import '../submit_button.dart';
import '../transaction_type_selector.dart';
import 'account_selector.dart';
import 'amout_field.dart';

class InternalTransferForm extends StatelessWidget {
  const InternalTransferForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController = Get.find();
    final HomePageController homeController = Get.find();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountSelector(homeController: homeController,transactionController: transactionController,),
          const SizedBox(height: 24),
          AmountField(controller: transactionController),
          const SizedBox(height: 24),
          // TransactionTypeSelector(controller: controller),
          const SizedBox(height: 32),
          SubmitButton(
            text: 'Complete Transfer',
            onPressed: transactionController.makeInternalTransfer,
          ),
        ],
      ),
    );
  }
}