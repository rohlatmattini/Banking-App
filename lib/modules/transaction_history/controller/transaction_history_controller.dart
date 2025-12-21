import 'package:banking_system/app/routes/routes.dart';
import 'package:get/get.dart';

import '../../../core/patterns/facade/transaction_history_facade.dart';
import '../../../data/models/transaction/transaction_history_model.dart';

class TransactionHistoryController extends GetxController {
  final TransactionHistoryFacade facade;

  TransactionHistoryController(this.facade);

  var transactions = <TransactionHistoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    transactions.value = await facade.fetchMyTransactions();
    isLoading.value = false;
  }

  void openDetails(String publicId) {
    Get.toNamed(
      AppRoute.transactionDetails,
      arguments: publicId,
    );
  }
}
