import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../accounts/view/account_info_screen.dart';
import '../../ask_question/ask_question_screen.dart';
import '../../drawer/widegt/main_drawer.dart';
import '../../payment/view/payment_screen.dart';
import '../../transactions/view/transactions_screen.dart';
import '../controller/home_page_controller.dart';
import '../widget/home_app_bar.dart';
import '../widget/home_bottom_nav_bar.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find<HomePageController>();

    return Scaffold(
      drawer: MainDrawer(),
      appBar: const HomeAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.accounts.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchAccounts,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 200,
                  child: Center(child: Text('No details available')),
                ),
              ],
            ),
          );
        }

        // RefreshIndicator حول المحتوى الرئيسي
        return RefreshIndicator(
          onRefresh: controller.fetchAccounts,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    kBottomNavigationBarHeight,
                child: Obx(() => IndexedStack(
                  index: controller.currentIndex.value,
                  children: [
                    const AccountInfoScreen(),
                    const TransactionsScreen(),
                    const PaymentsScreen(),
                    AskQuestionScreen(),
                  ],
                )),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
