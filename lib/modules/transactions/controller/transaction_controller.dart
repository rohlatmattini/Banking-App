// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../../../core/patterns/facade/transaction_facade.dart';
// import '../../../core/patterns/strategy/validation_strategy.dart';
// import '../../../data/apis/transaction/transaction_api.dart';
// import '../../../data/models/transaction/transaction_model.dart';
// import '../../../data/models/transaction/transaction_request.dart';
//
// class TransactionController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   late TabController tabController;
//   late TransactionFacade transactionFacade;
//   final storage = FlutterSecureStorage();
//
//   final RxString selectedFromAccount = ''.obs;
//   final RxString selectedToAccount = ''.obs;
//   final RxDouble amount = 0.0.obs;
//   final RxString externalAccountNumber = ''.obs;
//   final RxString transactionDescription = ''.obs;
//   final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
//   final RxBool isLoading = false.obs;
//
//   @override
//   void onInit() async {
//     super.onInit();
//     tabController = TabController(length: 2, vsync: this);
//
//     await initializeTransactionFacade();
//   }
//
//   Future<void> initializeTransactionFacade() async {
//     try {
//       final token = await storage.read(key: 'token') ?? '';
//       if (token.isEmpty) {
//         print('ERROR: Token is empty!');
//         Get.snackbar(
//           'Error',
//           'Please login first',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       print('Initializing TransactionFacade with token');
//       final api = TransactionApi(token: token);
//       transactionFacade = TransactionFacade(api: api);
//       print('TransactionFacade initialized successfully');
//     } catch (e) {
//       print('Error initializing TransactionFacade: $e');
//     }
//   }
//
//   @override
//   void onClose() {
//     tabController.dispose();
//     super.onClose();
//   }
//
//   // التحقق من التحويل الداخلي
//   bool validateInternalTransfer() {
//     if (selectedFromAccount.value.isEmpty) {
//       Get.snackbar('Error', 'Please select source account',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (selectedToAccount.value.isEmpty) {
//       Get.snackbar('Error', 'Please select destination account',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (amount.value <= 0) {
//       Get.snackbar('Error', 'Please enter a valid amount',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (selectedFromAccount.value == selectedToAccount.value) {
//       Get.snackbar('Error', 'Cannot transfer to the same account',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     return true;
//   }
//
//   // التحقق من التحويل الخارجي
//   bool validateExternalTransfer() {
//     if (selectedFromAccount.value.isEmpty) {
//       Get.snackbar('Error', 'Please select source account',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (externalAccountNumber.value.isEmpty) {
//       Get.snackbar('Error', 'Please enter destination account number',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (amount.value <= 0) {
//       Get.snackbar('Error', 'Please enter a valid amount',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     return true;
//   }
//
//   // إجراء التحويل الداخلي
//   Future<void> makeInternalTransfer() async {
//     if (!validateInternalTransfer()) return;
//
//     _showConfirmationDialog(
//       title: 'Confirm Internal Transfer',
//       message: 'Transfer ${amount.value} from ${selectedFromAccount.value} to ${selectedToAccount.value}',
//       onConfirm: () => _executeTransfer(isExternal: false),
//     );
//   }
//
//   // إجراء التحويل الخارجي
//   Future<void> makeExternalTransfer() async {
//     if (!validateExternalTransfer()) return;
//     _showConfirmationDialog(
//       title: 'Confirm External Transfer',
//       message: 'Transfer ${amount.value} from ${selectedFromAccount.value} to ${externalAccountNumber.value}',
//       onConfirm: () => _executeTransfer(isExternal: true),
//     );
//   }
//
//   // تنفيذ التحويل
//   Future<void> _executeTransfer({required bool isExternal}) async {
//     isLoading.value = true;
//
//     try {
//       print('=== Starting Transfer Execution ===');
//
//       final request = TransferRequest(
//         sourceAccountId: selectedFromAccount.value,
//         destinationAccountId: isExternal
//             ? externalAccountNumber.value
//             : selectedToAccount.value,
//         amount: amount.value,
//         description: transactionDescription.value.isNotEmpty
//             ? transactionDescription.value
//             : 'Transfer via Banking App',
//       );
//
//       print('Transfer Request: ${request.toJson()}');
//
//       final transaction = await transactionFacade.transfer(request);
//
//       print('=== Transfer Completed Successfully ===');
//       print('Transaction ID: ${transaction.id}');
//       print('Status: ${transaction.status}');
//
//       transactions.add(transaction);
//       _resetForm();
//
//       // عرض الرسالة المناسبة
//       if (transaction.status == 'pending_approval') {
//         Get.snackbar(
//           'Pending Approval',
//           transaction.message ?? 'Transfer created and pending approval',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//         );
//       } else {
//         Get.snackbar(
//           'Success',
//           transaction.message ?? 'Transfer completed successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       }
//
//     } catch (e) {
//       print('=== Transfer Failed ===');
//       print('Error: $e');
//
//       Get.snackbar(
//         'Transfer Failed',
//         'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 5),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _resetForm() {
//     selectedFromAccount.value = '';
//     selectedToAccount.value = '';
//     amount.value = 0.0;
//     externalAccountNumber.value = '';
//     transactionDescription.value = '';
//   }
//
//   void _showConfirmationDialog({
//     required String title,
//     required String message,
//     required VoidCallback onConfirm,
//   }) {
//     Get.dialog(
//       AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               onConfirm();
//             },
//             child: const Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/modules/transaction/controller/transaction_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/patterns/facade/transaction_facade.dart';
import '../../../core/patterns/observer/email_notification_observer.dart';
import '../../../core/patterns/observer/notification_subject.dart';
import '../../../core/patterns/observer/sms_notification_observer.dart';
import '../../../data/apis/transaction/transaction_api.dart';
import '../../../data/models/transaction/transaction_model.dart';
import '../../../data/models/transaction/transaction_request.dart';
import '../../../core/patterns/chain/transaction_approval_chain.dart';

class TransactionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late TransactionFacade transactionFacade;
  final storage = FlutterSecureStorage();

  // Observable Accounts
  final RxString selectedFromAccount = ''.obs;
  final RxString selectedToAccount = ''.obs;
  final RxDouble amount = 0.0.obs;
  final RxString externalAccountNumber = ''.obs;
  final RxString transactionDescription = ''.obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  // Notification Subject
  final NotificationSubject notificationSubject = NotificationSubject();

  // Approval Chain
  final TransactionApprovalChain approvalChain = TransactionApprovalChain();

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // إضافة observers (Email + SMS)
    notificationSubject.addObserver(EmailNotificationObserver());
    notificationSubject.addObserver(SmsNotificationObserver());

    await initializeTransactionFacade();
  }

  Future<void> initializeTransactionFacade() async {
    try {
      final token = await storage.read(key: 'token') ?? '';
      if (token.isEmpty) {
        print('ERROR: Token is empty!');
        Get.snackbar(
          'Error',
          'Please login first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('Initializing TransactionFacade with token');
      final api = TransactionApi(token: token);
      transactionFacade = TransactionFacade(api: api);
      print('TransactionFacade initialized successfully');
    } catch (e) {
      print('Error initializing TransactionFacade: $e');
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // التحقق من التحويل الداخلي
  bool validateInternalTransfer() {
    if (selectedFromAccount.value.isEmpty) {
      Get.snackbar('Error', 'Please select source account',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (selectedToAccount.value.isEmpty) {
      Get.snackbar('Error', 'Please select destination account',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (amount.value <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (selectedFromAccount.value == selectedToAccount.value) {
      Get.snackbar('Error', 'Cannot transfer to the same account',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  // التحقق من التحويل الخارجي
  bool validateExternalTransfer() {
    if (selectedFromAccount.value.isEmpty) {
      Get.snackbar('Error', 'Please select source account',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (externalAccountNumber.value.isEmpty) {
      Get.snackbar('Error', 'Please enter destination account number',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (amount.value <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  // إجراء التحويل الداخلي
  Future<void> makeInternalTransfer() async {
    if (!validateInternalTransfer()) return;

    _showConfirmationDialog(
      title: 'Confirm Internal Transfer',
      message:
      'Transfer ${amount.value} from ${selectedFromAccount.value} to ${selectedToAccount.value}',
      onConfirm: () => _executeTransfer(isExternal: false),
    );
  }

  // إجراء التحويل الخارجي
  Future<void> makeExternalTransfer() async {
    if (!validateExternalTransfer()) return;

    _showConfirmationDialog(
      title: 'Confirm External Transfer',
      message:
      'Transfer ${amount.value} from ${selectedFromAccount.value} to ${externalAccountNumber.value}',
      onConfirm: () => _executeTransfer(isExternal: true),
    );
  }

  // تنفيذ التحويل
  Future<void> _executeTransfer({required bool isExternal}) async {
    isLoading.value = true;

    try {
      print('=== Starting Transfer Execution ===');

      final request = TransferRequest(
        sourceAccountId: selectedFromAccount.value,
        destinationAccountId: isExternal
            ? externalAccountNumber.value
            : selectedToAccount.value,
        amount: amount.value,
        description: transactionDescription.value.isNotEmpty
            ? transactionDescription.value
            : 'Transfer via Banking App',
      );

      print('Transfer Request: ${request.toJson()}');

      // إرسال التحويل للـ backend كما هو
      final transaction = await transactionFacade.transfer(request);
      transactions.add(transaction);
      _resetForm();

      // **Observer notifications**
      if (transaction.status == 'pending_approval') {
        notificationSubject.notifyObservers(
          'Pending Approval',
          'Transfer of ${request.amount} requires admin approval',
        );
      } else {
        notificationSubject.notifyObservers(
          'Transfer Success',
          'Transfer of ${request.amount} completed successfully',
        );

        notificationSubject.notifyObservers(
          'Balance Update',
          'Your new balance in ${request.sourceAccountId} has been updated.',
        );
      }

      // **Chain of Responsibility notifications (طباعة فقط)**
      final approvalResult =
      await approvalChain.checkForNotifications(request);
      print(
          '🔔 Chain Notification: ${approvalResult.message} (Approved: ${approvalResult.isApproved})');

      // Snackbars
      if (transaction.status == 'pending_approval') {
        Get.snackbar(
          'Pending Approval',
          transaction.message ?? 'Transfer created and pending approval',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Success',
          transaction.message ?? 'Transfer completed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('=== Transfer Failed ===');
      print('Error: $e');

      Get.snackbar(
        'Transfer Failed',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    selectedFromAccount.value = '';
    selectedToAccount.value = '';
    amount.value = 0.0;
    externalAccountNumber.value = '';
    transactionDescription.value = '';
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
