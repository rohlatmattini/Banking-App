import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/patterns/facade/scheduled_transfer_facade.dart';
import '../../../data/models/payment/scheduled_transfer.dart';

enum TransactionType { transfer, withdraw, deposit }

class PaymentController extends GetxController {
  final ScheduledTransferFacade _facade = ScheduledTransferFacade();

  // قائمة الجدولات
  final scheduledTransfers = <ScheduledTransfer>[].obs;

  // بيانات الفورم
  var title = ''.obs;
  var amount = ''.obs;
  final sourceAccount = ''.obs;
  final destinationAccount = ''.obs;

  var selectedTransactionType = Rxn<TransactionType>();
  var selectedSourceAccount = Rxn<String>();
  var selectedDestinationAccount = Rxn<String>();
  var selectedFrequency = 'monthly'.obs;
  var selectedDayOfMonth = DateTime.now().day.obs;
  var selectedRunTime = '00:00'.obs;

  // Controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadScheduledTransfers();

    // مزامنة Rx مع Controller
    titleController.addListener(() {
      title.value = titleController.text;
    });
    amountController.addListener(() {
      amount.value = amountController.text;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    super.onClose();
  }

  Future<void> loadScheduledTransfers() async {
    try {
      final transfers = await _facade.getAllScheduledTransfers();
      scheduledTransfers.assignAll(transfers);
    } catch (e) {
      if (Get.isSnackbarOpen) Get.back();
      Get.snackbar(
        'Error',
        'Failed to load scheduled transfers',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setTransactionType(TransactionType? type) {
    selectedTransactionType.value = type;
    if (type == TransactionType.withdraw || type == TransactionType.deposit) {
      destinationAccount.value = '';
      selectedDestinationAccount.value = null;
    }
  }

  void setSourceAccount(String? accountId) {
    selectedSourceAccount.value = accountId;
    sourceAccount.value = accountId ?? '';
  }

  void setDestinationAccount(String? accountId) {
    selectedDestinationAccount.value = accountId;
    destinationAccount.value = accountId ?? '';
  }

  void setFrequency(String frequency) => selectedFrequency.value = frequency;
  void setDayOfMonth(int day) => selectedDayOfMonth.value = day;
  void setRunTime(String time) => selectedRunTime.value = time;
  void setTitle(String value) => title.value = value;
  void setAmount(String value) => amount.value = value;

  void clearForm() {
    titleController.clear();
    amountController.clear();
    title.value = '';
    amount.value = '';
    sourceAccount.value = '';
    destinationAccount.value = '';
    selectedTransactionType.value = null;
    selectedSourceAccount.value = null;
    selectedDestinationAccount.value = null;
    selectedFrequency.value = 'monthly';
    selectedDayOfMonth.value = DateTime.now().day;
    selectedRunTime.value = '00:00';
  }

  Future<void> saveTransfer() async {
    try {
      // Validation
      if (title.value.isEmpty) throw Exception('Enter description');
      if (amount.value.isEmpty || double.tryParse(amount.value) == null)
        throw Exception('Enter valid amount');
      if (selectedSourceAccount.value == null)
        throw Exception('Select source account');

      // 🔥 تعديل هنا: التحقق من destination account لكل الأنواع
      String? destinationAccountId;

      if (selectedTransactionType.value == TransactionType.transfer) {
        if (selectedDestinationAccount.value == null ||
            selectedDestinationAccount.value!.isEmpty)
          throw Exception('Select destination account');
        destinationAccountId = selectedDestinationAccount.value;
      } else {
        // 🔥 للـ withdraw و deposit، أرسل نفس الـ source account أو قيمة افتراضية
        destinationAccountId = selectedSourceAccount.value;
        // أو: destinationAccountId = 'default_account_id';
        // أو: destinationAccountId = null; // إذا سمح الخادم
      }

      final transfer = await _facade.createTransfer(
        sourceAccountId: selectedSourceAccount.value!,
        destinationAccountId: destinationAccountId, // 🔥 التعديل هنا
        type: selectedTransactionType.value!.name,
        amount: double.parse(amount.value),
        description: title.value,
        frequency: selectedFrequency.value,
        interval: 1,
        dayOfMonth: selectedFrequency.value == 'monthly'
            ? selectedDayOfMonth.value
            : null,
        runTime: selectedRunTime.value,
      );

      scheduledTransfers.add(transfer);
      clearForm();
      Get.back();
      Get.snackbar('Success', 'Transfer scheduled successfully');
    } catch (e) {
      if (Get.isSnackbarOpen) Get.back();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception:', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> updateTransferStatus(String publicId, String status) async {
    try {
      await _facade.updateStatus(publicId, status);
      await loadScheduledTransfers();
      Get.snackbar('Success', 'Status updated successfully');
    } catch (e) {
      if (Get.isSnackbarOpen) Get.back();
      // Get.snackbar(
      //   'Error',
      //   'Failed to update status',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  Future<void> deleteTransfer(String publicId) async {
    try {
      await _facade.deleteTransfer(publicId);
      scheduledTransfers.removeWhere((t) => t.publicId == publicId);
      Get.snackbar(
        'Success',
        'Transfer deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (Get.isSnackbarOpen) Get.back();
      Get.snackbar(
        'Error',
        'Failed to delete transfer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  double get totalMonthlyPayments => scheduledTransfers
      .where((t) => t.status == 'active' && t.frequency == 'monthly')
      .fold(0.0, (sum, t) => sum + t.amount);
}