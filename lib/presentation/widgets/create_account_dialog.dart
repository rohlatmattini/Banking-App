import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/enums/account_type_enum.dart';

class CreateAccountDialog extends StatefulWidget {
  final Function({
  required AccountTypeEnum type,
  String? dailyLimit,
  String? monthlyLimit,
  }) onCreate;

  const CreateAccountDialog({super.key, required this.onCreate});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  AccountTypeEnum? _selectedType;
  final TextEditingController _dailyLimitController = TextEditingController();
  final TextEditingController _monthlyLimitController = TextEditingController();

  final List<AccountTypeEnum> _availableTypes = [
    AccountTypeEnum.SAVINGS,
    AccountTypeEnum.INVESTMENT,
    AccountTypeEnum.LOAN,
    AccountTypeEnum.CHECKING,
  ];

  @override
  void dispose() {
    _dailyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'إنشاء حساب جديد',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // نوع الحساب
              DropdownButtonFormField<AccountTypeEnum>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'نوع الحساب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.account_balance),
                ),
                items: _availableTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.arabicName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار نوع الحساب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // الحد اليومي
              TextFormField(
                controller: _dailyLimitController,
                decoration: InputDecoration(
                  labelText: 'الحد اليومي (اختياري)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.today),
                  suffixText: 'دولار',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final num = double.tryParse(value);
                    if (num == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    if (num <= 0) {
                      return 'يجب أن يكون الرقم أكبر من الصفر';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // الحد الشهري
              TextFormField(
                controller: _monthlyLimitController,
                decoration: InputDecoration(
                  labelText: 'الحد الشهري (اختياري)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixText: 'دولار',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final num = double.tryParse(value);
                    if (num == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    if (num <= 0) {
                      return 'يجب أن يكون الرقم أكبر من الصفر';
                    }

                    // التحقق إذا كان الحد اليومي موجود
                    if (_dailyLimitController.text.isNotEmpty) {
                      final daily = double.tryParse(_dailyLimitController.text) ?? 0;
                      if (num < daily) {
                        return 'الحد الشهري يجب أن يكون أكبر من الحد اليومي';
                      }
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              // معلومات توضيحية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملاحظات:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• سيتم إنشاء الحساب تحت اسم المستخدم الحالي',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '• الحساب سيكون نشطًا مباشرة بعد الإنشاء',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '• يمكنك تعديل الحدود لاحقًا',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreate(
                type: _selectedType!,
                dailyLimit: _dailyLimitController.text.isNotEmpty
                    ? _dailyLimitController.text
                    : null,
                monthlyLimit: _monthlyLimitController.text.isNotEmpty
                    ? _monthlyLimitController.text
                    : null,
              );
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('إنشاء'),
        ),
      ],
    );
  }
}