import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/utils/load_indicator.dart';
import '../controller/transaction_history_controller.dart';
import '../widget/transaction_card.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionHistoryController>();

    return Scaffold(
      appBar: AppBar(title: Text('Transaction History',style: TextStyle(color: AppColor.darkgreen,fontWeight: FontWeight.bold))),
      body: Obx(() {
        return AppRefreshIndicator(
          onRefresh: controller.fetchTransactions,
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.transactions.isEmpty
              ? const Center(child: Text('No transactions found'))
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];
              return TransactionCard(
                transaction: transaction,
                onTap: () => controller.openDetails(transaction.publicId),
              );
            },
          ),
        );
      }),
    );
  }
}
