
import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';

class AccountInfoDialog extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final double balance;
  final String currency;
  final String accountType;
  final String state;
  final IconData icon;

  const AccountInfoDialog({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.currency,
    required this.accountType,
    required this.state,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildDialogTitle(),
      content: _buildDialogContent(),
      actions: _buildDialogActions(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildDialogTitle() {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.darkgreen,
          size: 30,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            accountName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.darkgreen,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDialogRow('رقم الحساب:', accountNumber),
        const SizedBox(height: 12),
        _buildDialogRow('نوع الحساب:', _getAccountType(accountType)),
        const SizedBox(height: 12),
        _buildDialogRow(
          'الرصيد:',
          '${balance.toStringAsFixed(2)} $currency',
          valueColor: balance >= 0 ? AppColor.lightgreen : Colors.red,
        ),
        _buildDialogRow('حالة الحساب:', state),
      ],
    );
  }

  Widget _buildDialogRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColor.darkgreen,
              fontSize: 14,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'إغلاق',
          style: TextStyle(color: AppColor.darkgreen),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          _navigateToTransfer();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.darkgreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'تحويل',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ];
  }

  String _getAccountType(String type) {
    switch (type) {
      case 'current':
        return 'حساب جاري';
      case 'saving':
        return 'حساب توفير';
      case 'investment':
        return 'حساب استثماري';
      case 'loan':
        return 'حساب قرض';
      default:
        return type;
    }
  }

  void _navigateToTransfer() {
    // TODO: التنقل إلى صفحة التحويل
    print('Navigate to transfer for account: $accountName');
  }

  // دالة ثابتة لفتح الـ Dialog بسهولة
  static void show({
    required BuildContext context,
    required String accountName,
    required String accountNumber,
    required double balance,
    required String currency,
    required String accountType,
    required String state,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (context) => AccountInfoDialog(
        accountName: accountName,
        accountNumber: accountNumber,
        balance: balance,
        currency: currency,
        accountType: accountType,
        state: state,
        icon: icon,
      ),
    );
  }
}