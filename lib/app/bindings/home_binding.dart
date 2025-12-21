import 'package:banking_system/core/constants/app_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../core/patterns/facade/account_facade.dart';
import '../../data/apis/account/account_api.dart';
import '../../modules/home/controller/home_page_controller.dart';
import '../../modules/payment/controller/payment_controller.dart';
import '../../modules/transactions/controller/transaction_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => AccountApi(
      baseUrl: AppLinks.baseUrl,
      storage: const FlutterSecureStorage(),
    ));
    Get.lazyPut(() => AccountFacade(
      api: Get.find<AccountApi>(),
    ));

    Get.lazyPut(() => HomePageController(
      facade: Get.find<AccountFacade>(),
    ));

    Get.lazyPut(() => TransactionController());
    Get.lazyPut(() => PaymentController());
  }
}
