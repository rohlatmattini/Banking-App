

// home_page_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/patterns/composite/account_component.dart';
import '../../../core/patterns/facade/account_facade.dart';

class HomePageController extends GetxController {
  final AccountFacade facade;
  HomePageController({required this.facade});

  final RxInt currentIndex = 0.obs;
  final RxList<AccountComponent> accounts = <AccountComponent>[].obs;
  final RxDouble totalBalance = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> fetchAccounts() async {
    print('🔥 fetchAccounts CALLED');

    isLoading.value = true;
    try {
      final result = await facade.fetchAccounts();
      accounts.assignAll(result);
      _calculateTotalBalance();
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  void _calculateTotalBalance() {
    double sum(AccountComponent acc) {
      if (acc.children.isEmpty) return acc.balance;
      return acc.children.fold(0.0, (prev, child) => prev + sum(child));
    }

    totalBalance.value =
        accounts.fold(0.0, (prev, acc) => prev + sum(acc));
  }

  IconData getIconFromType(String type) {
    switch (type) {
      case 'current':
        return Icons.account_balance;
      case 'savings':
        return Icons.savings;
      case 'checking':
        return Icons.account_box;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
