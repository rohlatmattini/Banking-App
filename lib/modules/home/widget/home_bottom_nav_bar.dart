import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_color.dart';
import '../controller/home_page_controller.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find<HomePageController>();

    return Obx(() => BottomNavigationBar(
      currentIndex: controller.currentIndex.value,
      onTap: (index) => controller.changeIndex(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: 'account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments),
          label: 'payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_mark_sharp),
          label: 'question',
        ),
      ],
      selectedItemColor: AppColor.darkgreen,
      unselectedItemColor: AppColor.grey.withOpacity(0.4),
    ));
  }
}