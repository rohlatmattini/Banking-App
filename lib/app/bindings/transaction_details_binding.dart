import 'package:get/get.dart';

import '../../../core/patterns/facade/transaction_history_facade.dart';
import '../../../data/apis/transaction/transaction_history_api.dart';
import '../../modules/transaction_history/controller/transaction_details_history.dart';

class TransactionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryApi>(
          () => TransactionHistoryApi(),
    );

    Get.lazyPut<TransactionHistoryFacade>(
          () => TransactionHistoryFacade(Get.find<TransactionHistoryApi>()),
    );

    Get.lazyPut<TransactionDetailsController>(
          () => TransactionDetailsController(
        Get.find<TransactionHistoryFacade>(),
      ),
    );
  }
}
