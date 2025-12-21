import 'package:get/get.dart';

import '../../../core/patterns/facade/transaction_history_facade.dart';

class TransactionDetailsController extends GetxController {
  final TransactionHistoryFacade facade;

  TransactionDetailsController(this.facade);

  late String publicId;
  var details = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    publicId = Get.arguments;
    fetchDetails();
    super.onInit();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    details.value = await facade.fetchTransactionDetails(publicId);
    isLoading.value = false;
  }
}
