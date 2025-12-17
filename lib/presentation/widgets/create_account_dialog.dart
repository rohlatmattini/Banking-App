import 'package:flutter/material.dart';
import '../../domain/enums/account_type_enum.dart';
import '../../domain/dtos/open_account_dto.dart';

class CreateAccountDialog extends StatefulWidget {
  final Function(String, double, AccountTypeEnum, double?, double?) onCreate;

  const CreateAccountDialog({super.key, required this.onCreate});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0.0');
  final _dailyLimitController = TextEditingController();
  final _monthlyLimitController = TextEditingController();

  AccountTypeEnum _selectedType = AccountTypeEnum.SAVINGS;
  bool _showLimits = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _dailyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إنشاء حساب جديد', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اسم صاحب الحساب
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم صاحب الحساب',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // الرصيد الأولي
              TextFormField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الرصيد الأولي',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الرصيد';
                  }
                  final balance = double.tryParse(value);
                  if (balance == null || balance < 0) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // نوع الحساب
              DropdownButtonFormField<AccountTypeEnum>(
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _showLimits = value != AccountTypeEnum.GROUP &&
                        value != AccountTypeEnum.LOAN;
                  });
                },
                items: AccountTypeEnum.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(
                          _getTypeIcon(type),
                          color: _getTypeColor(type),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(type.arabicName),
                      ],
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'نوع الحساب',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              // حدود السحب (اختياري)
              if (_showLimits) ...[
                const Text(
                  'حدود السحب (اختياري):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dailyLimitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الحد اليومي',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.today),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final limit = double.tryParse(value);
                            if (limit == null || limit <= 0) {
                              return 'حد غير صحيح';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _monthlyLimitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الحد الشهري',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_month),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final limit = double.tryParse(value);
                            if (limit == null || limit <= 0) {
                              return 'حد غير صحيح';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'ملاحظة: اترك الحقول فارغة إذا كنت تريد عدم تحديد حدود',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              // معلومات إضافية
              ExpansionTile(
                title: const Text('معلومات إضافية'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('نشط', Icons.check_circle, Colors.green),
                        _buildInfoItem('يمكن الإيداع', Icons.add_circle, Colors.green),
                        _buildInfoItem('يمكن السحب', Icons.remove_circle, Colors.green),
                        _buildInfoItem('يمكن التحويل', Icons.swap_horiz, Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('إنشاء'),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  IconData _getTypeIcon(AccountTypeEnum type) {
    switch (type) {
      case AccountTypeEnum.SAVINGS:
        return Icons.savings;
      case AccountTypeEnum.CHECKING:
        return Icons.account_balance;
      case AccountTypeEnum.LOAN:
        return Icons.money;
      case AccountTypeEnum.INVESTMENT:
        return Icons.trending_up;
      case AccountTypeEnum.GROUP:
        return Icons.account_tree;
    }
  }

  Color _getTypeColor(AccountTypeEnum type) {
    switch (type) {
      case AccountTypeEnum.SAVINGS:
        return Colors.green;
      case AccountTypeEnum.CHECKING:
        return Colors.blue;
      case AccountTypeEnum.LOAN:
        return Colors.orange;
      case AccountTypeEnum.INVESTMENT:
        return Colors.purple;
      case AccountTypeEnum.GROUP:
        return Colors.teal;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final double? dailyLimit = _dailyLimitController.text.isNotEmpty
          ? double.tryParse(_dailyLimitController.text)
          : null;

      final double? monthlyLimit = _monthlyLimitController.text.isNotEmpty
          ? double.tryParse(_monthlyLimitController.text)
          : null;

      widget.onCreate(
        _nameController.text,
        double.parse(_balanceController.text),
        _selectedType,
        dailyLimit,
        monthlyLimit,
      );
      Navigator.pop(context);
    }
  }
}