// lib/presentation/controller/transaction_controller.dart
import 'package:get/get.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_detail_entity.dart';
import 'package:flutter/material.dart';

class TransactionController extends GetxController {
  final AccountRepository repository;

  TransactionController({required this.repository});

  final transactions = <TransactionEntity>[].obs;
  final filteredTransactions = <TransactionEntity>[].obs;
  final selectedTransaction = Rxn<TransactionDetailEntity>();
  final isLoading = true.obs;
  final transactionTypeFilter = 'all'.obs; // تغيير من scope إلى type filter

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final result = await repository.getTransactions(scope: 'all');
      transactions.assignAll(result);
      _applyFilter();
    } catch (e) {
      _showError('Failed to load transactions', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
// lib/presentation/controller/transaction_controller.dart
// Add this method:
  void filterByStatus(TransactionStatus status) {
    transactionTypeFilter.value = 'status:${status.value}';
    _applyFilter();
  }

// Update _applyFilter method:
// lib/presentation/controller/transaction_controller.dart
  void _applyFilter() {
    if (transactionTypeFilter.value == 'all') {
      filteredTransactions.assignAll(transactions);
    } else if (transactionTypeFilter.value == 'pending_approval') {
      // فلترة حسب حالة pending_approval
      filteredTransactions.assignAll(
          transactions.where((transaction) =>
          transaction.status == TransactionStatus.PENDING_APPROVAL
          ).toList()
      );
    } else if (transactionTypeFilter.value.startsWith('status:')) {
      final status = transactionTypeFilter.value.replaceFirst('status:', '');
      filteredTransactions.assignAll(
          transactions.where((transaction) =>
          transaction.status.value == status
          ).toList()
      );
    } else {
      // فلترة حسب نوع المعاملة
      filteredTransactions.assignAll(
          transactions.where((transaction) =>
          transaction.type.value == transactionTypeFilter.value
          ).toList()
      );
    }
  }
// Add this getter:
  List<TransactionEntity> get pendingApprovalTransactions {
    return transactions.where((t) => t.status == TransactionStatus.PENDING_APPROVAL).toList();
  }

  Future<void> fetchTransactionDetail(String transactionId) async {
    try {
      final result = await repository.getTransactionDetail(transactionId, scope: 'all');
      selectedTransaction.value = result;
    } catch (e) {
      _showError('Failed to load transaction details', e.toString());
    }
  }
// lib/presentation/controller/transaction_controller.dart
  void changeTypeFilter(String filterValue) {
    transactionTypeFilter.value = filterValue;
    _applyFilter();
  }

  String getTransactionTypeIcon(String type) {
    switch (type) {
      case 'deposit':
        return '↑';
      case 'withdraw':
        return '↓';
      case 'transfer':
        return '↔';
      default:
        return '•';
    }
  }

  Color getTransactionColor(String type) {
    switch (type) {
      case 'deposit':
        return Colors.teal;
      case 'withdraw':
        return Colors.teal;
      case 'transfer':
        return Colors.teal;
      default:
        return Colors.teal;
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // إضافة إحصائيات للمعاملات
  Map<String, int> getTransactionStatistics() {
    final deposits = transactions.where((t) => t.type.value == 'deposit').length;
    final withdrawals = transactions.where((t) => t.type.value == 'withdraw').length;
    final transfers = transactions.where((t) => t.type.value == 'transfer').length;

    return {
      'total': transactions.length,
      'deposits': deposits,
      'withdrawals': withdrawals,
      'transfers': transfers,
    };
  }

  // حساب إجمالي المبالغ حسب النوع
  Map<String, double> getTransactionAmounts() {
    double totalDeposits = 0;
    double totalWithdrawals = 0;
    double totalTransfers = 0;

    for (var transaction in transactions) {
      switch (transaction.type.value) {
        case 'deposit':
          totalDeposits += transaction.amount;
          break;
        case 'withdraw':
          totalWithdrawals += transaction.amount;
          break;
        case 'transfer':
          totalTransfers += transaction.amount;
          break;
      }
    }

    return {
      'deposits': totalDeposits,
      'withdrawals': totalWithdrawals,
      'transfers': totalTransfers,
      'net': totalDeposits - totalWithdrawals,
    };
  }
}