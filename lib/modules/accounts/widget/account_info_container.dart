import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/services/auth/user_service.dart';
import '../../home/controller/home_page_controller.dart';
import '../../../data/models/auth/user_model.dart';

class AccountInfoContainer extends StatelessWidget {
  const AccountInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find();
    final UserService userService = Get.find<UserService>();

    return FutureBuilder<UserModel?>(
      future: userService.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.darkgreen.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${user?.name ?? "Guest"}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ),
                    Divider(thickness: 1, color: AppColor.white),
                    const Text(
                      'Total balances',
                      style: TextStyle(color: AppColor.white, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => Text(
                        '${controller.totalBalance.value.toStringAsFixed(2)} \$',
                        style: const TextStyle(
                          color: AppColor.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
