import 'package:get/get.dart';

import '../../../core/patterns/facade/transaction_history_facade.dart';
import '../../../data/apis/transaction/transaction_history_api.dart';
import '../../modules/transaction_history/controller/transaction_history_controller.dart';

class TransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryApi>(
          () => TransactionHistoryApi(),
    );

    Get.lazyPut<TransactionHistoryFacade>(
          () => TransactionHistoryFacade(Get.find()),
    );

    Get.lazyPut<TransactionHistoryController>(
          () => TransactionHistoryController(Get.find()),
    );
  }
}
