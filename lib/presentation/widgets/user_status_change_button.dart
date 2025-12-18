// widgets/user_status_change_button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/account_controller.dart';

class UserStatusChangeButton extends StatelessWidget {
  final int userId = 4; // User ID المحدد
  final AccountController controller = Get.find<AccountController>();

  UserStatusChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _showUserStatusDialog,
      icon: const Icon(Icons.sync, color: Colors.white),
      label: const Text('تغيير حالة المستخدم'),
      backgroundColor: Colors.teal,
    );
  }

  void _showUserStatusDialog() {
    // قائمة الحالات المتاحة
    final List<Map<String, dynamic>> availableStatuses = [
      {
        'name': 'active',
        'arabic': 'تفعيل',
        'description': 'تفعيل المستخدم',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'name': 'inactive',
        'arabic': 'تعطيل',
        'description': 'تعطيل المستخدم',
        'icon': Icons.block,
        'color': Colors.red,
      },
      {
        'name': 'suspended',
        'arabic': 'توقيف مؤقت',
        'description': 'توقيف المستخدم مؤقتًا',
        'icon': Icons.pause_circle,
        'color': Colors.orange,
      },
      {
        'name': 'pending',
        'arabic': 'قيد المراجعة',
        'description': 'وضع المستخدم قيد المراجعة',
        'icon': Icons.hourglass_empty,
        'color': Colors.blue,
      },
    ];

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            const Text(
              'تغيير حالة المستخدم',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 8),

            // معلومات المستخدم
            Card(
              color: Colors.teal.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المستخدم رقم 4',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'ID: $userId',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.teal),
                      onPressed: _showUserDetails,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // قائمة الحالات
            const Text(
              'اختر الحالة الجديدة:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            // خيارات الحالات
            ...availableStatuses.map((status) =>
                _buildStatusOption(
                  status['arabic'],
                  status['description'],
                  status['icon'],
                  status['color'],
                  status['name'],
                ),
            ).toList(),

            const SizedBox(height: 20),

            // زر الإلغاء
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: Get.back,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text('إلغاء'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildStatusOption(String title, String subtitle, IconData icon, Color color, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _confirmStatusChange(status, title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
      ),
    );
  }

  void _confirmStatusChange(String newStatus, String statusName) {
    Get.back(); // إغلاق bottom sheet

    Get.defaultDialog(
      title: 'تأكيد التغيير',
      middleText: 'هل أنت متأكد من تغيير حالة المستخدم رقم $userId إلى "$statusName"؟',
      textConfirm: 'نعم، قم بالتغيير',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // إغلاق dialog
        controller.changeAccountState(userId as String, newStatus);
      },
    );
  }

  void _showUserDetails() {
    Get.dialog(
      AlertDialog(
        title: const Text('تفاصيل المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('رقم المستخدم', userId.toString()),
            _buildDetailRow('النوع', 'مستخدم نظام'),
            _buildDetailRow('تاريخ الإنشاء', '2024-01-15'),
            _buildDetailRow('آخر نشاط', 'قبل ساعتين'),
            _buildDetailRow('عدد الحسابات', '3 حسابات'),
            _buildDetailRow('الحالة الحالية', 'نشط'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.teal),
          ),
        ],
      ),
    );
  }
}