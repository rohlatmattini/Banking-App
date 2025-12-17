import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/account_controller.dart';
import '../widgets/account_card.dart';
import '../widgets/create_account_dialog.dart';
import '../../domain/dtos/open_account_dto.dart';
import '../../domain/enums/account_type_enum.dart';

class AccountManagementPage extends StatelessWidget {
  final AccountController controller = Get.find<AccountController>();

  AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الحسابات',
          style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchAccounts(),
            tooltip: 'تحديث',
          ),
          // إضافة زر رؤية الشجرة
          IconButton(
            icon: const Icon(Icons.account_tree, color: Colors.white),
            onPressed: _showAccountTree,
            tooltip: 'عرض الشجرة',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري تحميل الحسابات...'),
              ],
            ),
          );
        }

        if (controller.accounts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                const Text(
                  'لا توجد حسابات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'استخدم زر + لإنشاء حساب جديد',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showCreateAccountDialog(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('إنشاء حساب جديد', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          );
        }

        final stats = controller.getAccountStatistics();

        return Column(
          children: [
            // إحصائيات الحسابات
            _buildStatisticsCard(stats),

            // بحث وفلاتر
            _buildSearchAndFilters(),

            // قائمة الحسابات
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchAccounts(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.accounts.length,
                  itemBuilder: (context, index) {
                    final account = controller.accounts[index];
                    return AccountCard(
                      account: account,
                      controller: controller,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAccountDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('حساب جديد'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildStatisticsCard(Map<String, int> stats) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'إحصائيات الحسابات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    '${stats['total']} حساب',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('نشطة', stats['active'] ?? 0, Colors.green),
                _buildStatItem('مجمدة', stats['frozen'] ?? 0, Colors.blue),
                _buildStatItem('موقوفة', stats['suspended'] ?? 0, Colors.orange),
                _buildStatItem('مغلقة', stats['closed'] ?? 0, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن حساب...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // يمكن إضافة فلترة هنا
              },
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
              // تطبيق الفلتر
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('جميع الحسابات')),
              const PopupMenuItem(value: 'active', child: Text('الحسابات النشطة')),
              const PopupMenuItem(value: 'frozen', child: Text('الحسابات المجمدة')),
              const PopupMenuItem(value: 'suspended', child: Text('الحسابات الموقوفة')),
              const PopupMenuItem(value: 'closed', child: Text('الحسابات المغلقة')),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateAccountDialog(
        onCreate: (holderName, balance, type, dailyLimit, monthlyLimit) {
          final dto = OpenAccountData(
            type: type,
            dailyLimit: dailyLimit?.toString(),
            monthlyLimit: monthlyLimit?.toString(),
          );

          // في الواقع، يجب إرسال DTO للـ Controller
          // لكن لتبسيط الأمور، سنمرر البيانات كما هي
          controller.createAccount(dto);
        },
      ),
    );
  }

  void _showAccountTree() {
    // عرض شجرة الحسابات
    Get.defaultDialog(
      title: 'شجرة الحسابات',
      content: const Column(
        children: [
          Icon(Icons.account_tree, size: 60, color: Colors.teal),
          SizedBox(height: 16),
          Text('ميزة عرض الشجرة قيد التطوير'),
          Text('ستتمكن من رؤية Group والحسابات الفرعية'),
        ],
      ),
      textConfirm: 'موافق',
      onConfirm: Get.back,
    );
  }
}