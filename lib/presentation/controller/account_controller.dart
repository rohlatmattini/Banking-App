import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/dtos/open_account_dto.dart';
import '../../domain/enums/account_type_enum.dart';
import '../helpers/state_helper.dart';

class AccountController extends GetxController {
  final AccountRepository repository;

  AccountController({required this.repository});

  final accounts = <AccountEntity>[].obs;
  final isLoading = true.obs;
  final selectedAccount = Rxn<AccountEntity>();

  @override
  void onInit() {
    fetchAccounts();
    super.onInit();
  }

  Future<void> fetchAccounts() async {
    isLoading.value = true;
    try {
      // TODO: Get actual user ID from authentication
      final userId = 1; // Replace with actual user ID
      final result = await repository.listByUser(userId);
      accounts.assignAll(result);
    } catch (e) {
      _showError('فشل تحميل الحسابات', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAccount(OpenAccountData data) async {
    try {
      // TODO: Get actual user ID from authentication
      final userId = 1; // Replace with actual user ID

      // This would use OpenAccountUseCase in production
      final group = await repository.findUserGroup(userId);
      if (group == null) {
        throw Exception('لا يوجد حساب مجموعة للمستخدم');
      }

      final newAccount = await repository.createChildAccount(
        userId: userId,
        groupId: group.id,
        type: data.type,
        dailyLimit: data.dailyLimit,
        monthlyLimit: data.monthlyLimit,
      );

      accounts.add(newAccount);
      _showSuccess('تم إنشاء الحساب بنجاح');
    } catch (e) {
      _showError('فشل إنشاء الحساب', e.toString());
    }
  }

  Future<void> changeAccountState(String publicId, String newState) async {
    try {
      final account = accounts.firstWhere((acc) => acc.publicId == publicId);

      // Validate state transition
      if (!account.canTransitionTo(newState)) {
        throw Exception(account.transitionError(newState));
      }

      // Update via repository
      final updated = await repository.updateStateByPublicId(publicId, newState);

      // Update local list
      final index = accounts.indexWhere((acc) => acc.publicId == publicId);
      if (index != -1) {
        accounts[index] = updated;
      }

      _showSuccess('تم تغيير حالة الحساب بنجاح');
    } catch (e) {
      _showError('فشل تغيير حالة الحساب', e.toString());
    }
  }

  Future<void> deleteAccount(String publicId) async {
    try {
      final account = accounts.firstWhere((acc) => acc.publicId == publicId);

      if (!account.canDelete) {
        throw Exception('لا يمكن حذف الحساب لأنه ${account.status}. يجب إغلاقه أولاً');
      }

      // Confirm deletion
      Get.defaultDialog(
        title: 'تأكيد الحذف',
        middleText: 'هل أنت متأكد من حذف هذا الحساب؟\nهذا الإجراء لا يمكن التراجع عنه.',
        textConfirm: 'نعم، احذف',
        textCancel: 'إلغاء',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          try {
            // In real app, call repository.deleteAccount
            accounts.removeWhere((acc) => acc.publicId == publicId);
            _showSuccess('تم حذف الحساب بنجاح');
          } catch (e) {
            _showError('فشل حذف الحساب', e.toString());
          }
        },
      );
    } catch (e) {
      _showError('خطأ', e.toString());
    }
  }

  void selectAccount(String publicId) {
    selectedAccount.value = accounts.firstWhere((acc) => acc.publicId == publicId);
  }

  Map<String, int> getAccountStatistics() {
    Map<String, int> stats = {
      'total': accounts.length,
      'active': 0,
      'frozen': 0,
      'suspended': 0,
      'closed': 0,
    };

    for (var account in accounts) {
      switch (account.state.name) {
        case 'active':
          stats['active'] = stats['active']! + 1;
          break;
        case 'frozen':
          stats['frozen'] = stats['frozen']! + 1;
          break;
        case 'suspended':
          stats['suspended'] = stats['suspended']! + 1;
          break;
        case 'closed':
          stats['closed'] = stats['closed']! + 1;
          break;
      }
    }

    return stats;
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'نجاح',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
}