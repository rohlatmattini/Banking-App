import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/account_entity.dart';
import '../controller/account_controller.dart';
import '../helpers/state_helper.dart';

class AccountCard extends StatelessWidget {
  final AccountEntity account;
  final AccountController controller;

  const AccountCard({
    super.key,
    required this.account,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    final statusColor = StateHelper.getColorForState(account.state);
    final typeColor = StateHelper.getColorForType(account);
    final statusIcon = StateHelper.getIconForState(account.state);
    final typeIcon = StateHelper.getIconForType(account);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(typeIcon, size: 16, color: typeColor),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            account.type.arabicName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.holderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.fingerprint, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'ID: ${account.publicId}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        account.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      backgroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${account.createdAt.day}/${account.createdAt.month}/${account.createdAt.year}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 20, thickness: 1),

            // Balance and Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الرصيد الحالي:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${account.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (account.dailyLimit != null || account.monthlyLimit != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (account.dailyLimit != null)
                        Row(
                          children: [
                            Icon(Icons.today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'يومي: \$${account.dailyLimit}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      if (account.monthlyLimit != null)
                        Row(
                          children: [
                            Icon(Icons.calendar_month, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'شهري: \$${account.monthlyLimit}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // State and Actions
            _buildStateAndActionsSection(statusColor, statusIcon),
          ],
        ),
      ),
    );
  }

  Widget _buildStateAndActionsSection(Color statusColor, IconData statusIcon) {
    return Column(
      children: [
        // State Info
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'الحالة: ${account.status}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (account.state.canChangeState)
              IconButton(
                icon: Icon(Icons.sync, color: Colors.teal, size: 20),
                onPressed: () => _showStateChangeDialog(),
                tooltip: 'تغيير الحالة',
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Operations
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildOperationButton(
              'إيداع',
              account.state.canDeposit,
              Icons.add,
              Colors.green,
                  () => _showOperationDialog('deposit'),
            ),
            _buildOperationButton(
              'سحب',
              account.state.canWithdraw,
              Icons.remove,
              Colors.orange,
                  () => _showOperationDialog('withdraw'),
            ),
            _buildOperationButton(
              'تحويل',
              account.state.canTransfer,
              Icons.swap_horiz,
              Colors.blue,
                  () => _showTransferDialog(),
            ),
            _buildOperationButton(
              'تغيير الحالة',
              account.state.canChangeState,
              Icons.sync,
              Colors.purple,
                  () => _showStateChangeDialog(),
            ),
            if (account.state.canClose)
              _buildOperationButton(
                'إغلاق',
                true,
                Icons.lock,
                Colors.red,
                    () => _confirmCloseAccount(),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Delete Button
        if (account.state.canDelete)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.deleteAccount(account.publicId),
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('حذف الحساب'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOperationButton(
      String label,
      bool enabled,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey[300],
        foregroundColor: enabled ? Colors.white : Colors.grey[500],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  void _showStateChangeDialog() {
    final currentState = account.state.name;
    final List<Map<String, dynamic>> availableStates = [];

    // إضافة الحالات المتاحة بناءً على الحالة الحالية
    if (account.canTransitionTo('active')) {
      availableStates.add({
        'name': 'active',
        'arabic': 'تفعيل',
        'description': 'جعل الحساب نشطًا',
        'icon': Icons.check_circle,
        'color': Colors.green,
      });
    }

    if (account.canTransitionTo('frozen')) {
      availableStates.add({
        'name': 'frozen',
        'arabic': 'تجميد',
        'description': 'الإيداعات فقط مسموحة',
        'icon': Icons.ac_unit,
        'color': Colors.blue,
      });
    }

    if (account.canTransitionTo('suspended')) {
      availableStates.add({
        'name': 'suspended',
        'arabic': 'إيقاف',
        'description': 'جميع العمليات متوقفة',
        'icon': Icons.pause_circle,
        'color': Colors.orange,
      });
    }

    if (account.canTransitionTo('closed')) {
      availableStates.add({
        'name': 'closed',
        'arabic': 'إغلاق',
        'description': 'إغلاق الحساب نهائيًا',
        'icon': Icons.cancel,
        'color': Colors.red,
      });
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تغيير حالة الحساب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'الحساب: ${account.holderName}',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                'الحالة الحالية: ${account.status}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              if (availableStates.isEmpty)
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.block, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('لا توجد حالات متاحة للتغيير'),
                    ],
                  ),
                )
              else ...[
                const Text(
                  'اختر الحالة الجديدة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...availableStates.map((state) =>
                    _buildStateOption(
                      state['arabic'],
                      state['description'],
                      state['icon'],
                      state['color'],
                      state['name'],
                    ),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: Get.back,
                  child: const Text('إلغاء'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateOption(String title, String subtitle, IconData icon, Color color, String state) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Get.back();
        controller.changeAccountState(account.publicId, state);
      },
      tileColor: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  void _showOperationDialog(String operation) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final isDeposit = operation == 'deposit';
    final title = isDeposit ? 'إيداع' : 'سحب';

    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الحساب: ${account.holderName}', style: const TextStyle(color: Colors.teal)),
              Text('الرصيد الحالي: \$${account.balance.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'المبلغ',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'الرجاء إدخال مبلغ صحيح أكبر من الصفر';
                  }
                  if (!isDeposit && amount > account.balance) {
                    return 'المبلغ أكبر من الرصيد المتاح';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final amount = double.parse(amountController.text);
                Get.back();

                // Note: In real app, call use case for deposit/withdraw
                Get.snackbar(
                  'نجاح',
                  'تم ${isDeposit ? 'إيداع' : 'سحب'} \$${amount.toStringAsFixed(2)}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.teal,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('تنفيذ $title'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog() {
    final amountController = TextEditingController();
    final targetAccountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('تحويل بين الحسابات'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('من: ${account.holderName}', style: const TextStyle(color: Colors.teal)),
              Text('الرصيد: \$${account.balance.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الرجاء إدخال المبلغ';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'مبلغ غير صحيح';
                  if (amount > account.balance) return 'رصيد غير كافي';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: targetAccountController,
                decoration: const InputDecoration(
                  labelText: 'رقم الحساب الهدف',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الحساب';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                Get.snackbar(
                  'نجاح',
                  'تم بدء عملية التحويل',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.teal,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('تحويل'),
          ),
        ],
      ),
    );
  }

  void _confirmCloseAccount() {
    Get.defaultDialog(
      title: 'تأكيد الإغلاق',
      middleText: 'هل أنت متأكد من إغلاق الحساب ${account.holderName}؟\n'
          'بعد الإغلاق لا يمكن إعادة تفعيل الحساب.',
      textConfirm: 'نعم، أغلق',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.changeAccountState(account.publicId, 'closed');
      },
    );
  }
}