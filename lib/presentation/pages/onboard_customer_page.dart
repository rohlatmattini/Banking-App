import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/dtos/customer_dto.dart';
import '../../domain/dtos/open_account_dto.dart';
import '../../domain/dtos/onboard_customer_dto.dart';
import '../../domain/enums/account_type_enum.dart';
import '../../data/datasource/api_account_data_source.dart';

class OnboardCustomerPage extends StatefulWidget {
  const OnboardCustomerPage({super.key});

  @override
  State<OnboardCustomerPage> createState() => _OnboardCustomerPageState();
}

class _OnboardCustomerPageState extends State<OnboardCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<OpenAccountData> _accounts = [];
  final ApiAccountDataSource _dataSource = ApiAccountDataSource();
  bool _isLoading = false;

  // قائمة أنواع الحسابات المتاحة
  final List<AccountTypeEnum> _availableTypes = [
    AccountTypeEnum.CHECKING,
    AccountTypeEnum.SAVINGS,
    AccountTypeEnum.INVESTMENT,
    AccountTypeEnum.LOAN,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة عميل جديد',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // معلومات العميل
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات العميل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم العميل',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم العميل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'الرجاء إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // الحسابات المراد إنشاؤها
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الحسابات المراد إنشاؤها',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.teal),
                            onPressed: _addAccount,
                            tooltip: 'إضافة حساب',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'يمكن إضافة أكثر من حساب للعميل في نفس الوقت',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_accounts.isEmpty)
                        const Center(
                          child: Column(
                            children: [
                              Icon(Icons.account_balance_wallet,
                                  size: 60, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('لم يتم إضافة أي حسابات بعد'),
                            ],
                          ),
                        )
                      else
                        ..._accounts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final account = entry.value;
                          return _buildAccountCard(index, account);
                        }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ملخص الطلب
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ملخص الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('عدد الحسابات: '),
                          Text(
                            '${_accounts.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('أنواع الحسابات: '),
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              children: _accounts
                                  .map((a) => Chip(
                                label: Text(a.type.arabicName),
                                backgroundColor:
                                Colors.teal.withOpacity(0.1),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'إضافة العميل',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(int index, OpenAccountData account) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.teal.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getTypeIcon(account.type),
                      color: _getTypeColor(account.type),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      account.type.arabicName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(account.type),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeAccount(index),
                  tooltip: 'حذف الحساب',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (account.dailyLimit != null)
              Text('الحد اليومي: \$${account.dailyLimit}'),
            if (account.monthlyLimit != null)
              Text('الحد الشهري: \$${account.monthlyLimit}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _editAccount(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.withOpacity(0.1),
                foregroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('تعديل الحساب'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAccount() {
    showDialog(
      context: context,
      builder: (context) => _buildAccountDialog(null),
    );
  }

  void _editAccount(int index) {
    showDialog(
      context: context,
      builder: (context) => _buildAccountDialog(_accounts[index], index),
    );
  }

  Widget _buildAccountDialog([OpenAccountData? account, int? index]) {
    final typeController = TextEditingController(
        text: account?.type.value ?? AccountTypeEnum.CHECKING.value);
    final dailyLimitController =
    TextEditingController(text: account?.dailyLimit ?? '');
    final monthlyLimitController =
    TextEditingController(text: account?.monthlyLimit ?? '');

    AccountTypeEnum selectedType =
        account?.type ?? AccountTypeEnum.CHECKING;

    return AlertDialog(
      title: Text(index == null ? 'إضافة حساب' : 'تعديل حساب'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AccountTypeEnum>(
              value: selectedType,
              onChanged: (value) {
                if (value != null) {
                  selectedType = value;
                }
              },
              items: _availableTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(
                        _getTypeIcon(type),
                        color: _getTypeColor(type),
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
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dailyLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الحد اليومي (اختياري)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.today),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: monthlyLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الحد الشهري (اختياري)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_month),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final newAccount = OpenAccountData(
              type: selectedType,
              dailyLimit: dailyLimitController.text.isNotEmpty
                  ? dailyLimitController.text
                  : null,
              monthlyLimit: monthlyLimitController.text.isNotEmpty
                  ? monthlyLimitController.text
                  : null,
            );

            if (index == null) {
              _accounts.add(newAccount);
            } else {
              _accounts[index] = newAccount;
            }

            setState(() {});
            Navigator.pop(context);
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  void _removeAccount(int index) {
    setState(() {
      _accounts.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_accounts.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء إضافة حساب واحد على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final customer = CustomerData(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      final onboardData = OnboardCustomerData(
        customer: customer,
        accounts: _accounts,
      );

      // استدعاء API
      final result = await _dataSource.onboardCustomer(onboardData);

      // إظهار رسالة النجاح
      Get.defaultDialog(
        title: 'تمت العملية بنجاح',
        middleText:
        'تم إنشاء العميل وفتح الحسابات بنجاح.\nتم إرسال بيانات الدخول عبر البريد.',
        textConfirm: 'موافق',
        onConfirm: () {
          Get.back(); // إغلاق dialog
          Get.back(); // العودة للصفحة السابقة
        },
        confirmTextColor: Colors.white,
      );

      // يمكن هنا تحديث قائمة الحسابات أو إجراء عمليات أخرى
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إضافة العميل: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
}