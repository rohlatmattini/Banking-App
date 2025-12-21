import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_color.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Banking System ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColor.darkgreen,
      foregroundColor: AppColor.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: _showNotifications,
        ),

      ],
    );
  }

  void _showNotifications() {
    Get.snackbar(
      'الإشعارات',
      'هذه الخاصية قيد التطوير',
      backgroundColor: AppColor.darkgreen,
      colorText: AppColor.white,
    );
  }
}