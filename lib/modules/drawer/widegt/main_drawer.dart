import 'package:banking_system/app/routes/routes.dart';
import 'package:banking_system/modules/transaction_history/view/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/utils/app_row_tile.dart';
import '../../../core/services/auth/user_service.dart';
import '../../../core/patterns/facade/auth_facade.dart';
import '../../../data/models/auth/user_model.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = Get.find<UserService>();
    final AuthFacade authFacade = Get.find<AuthFacade>();

    return FutureBuilder<UserModel?>(
      future: userService.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        String firstLetter = "?";
        if (user?.name != null && user!.name.isNotEmpty) {
          firstLetter = user.name[0].toUpperCase();
        }

        return Drawer(
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: AppColor.darkgreen),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: AppColor.white,
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkgreen,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  user?.name ?? "Guest",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColor.white),
                                onPressed: () =>
                                    _showChangePasswordDialog(
                                        context, authFacade),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user?.email ?? "",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppTile(
                icon: Icons.notification_add,
                label: 'Notification'.tr,
                iconColor: AppColor.darkgreen,
                onTap: () {
                  Get.back(); // إغلاق الدرور
                  Get.toNamed('/notifications');
                },
              ),

              AppTile(
                icon: Icons.transfer_within_a_station,
                label: 'your transfer'.tr,
                iconColor: AppColor.darkgreen,
                textColor: AppColor.darkgreen,
                onTap: () => Get.toNamed(AppRoute.transactionHistory),
              ),

              AppTile(
                icon: Icons.logout_sharp,
                label: 'Logout'.tr,
                iconColor: AppColor.darkgreen,
                textColor: AppColor.red,
                onTap: () => _showLogoutDialog(context , authFacade),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthFacade authFacade) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text("Change Password".tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Current Password".tr),
                ),
                TextField(
                  controller: newController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "New Password".tr),
                ),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password".tr),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text("Cancel".tr)),
              TextButton(
                onPressed: () async {
                  final user = await authFacade.changePassword(
                    currentPassword: currentController.text,
                    newPassword: newController.text,
                    confirmPassword: confirmController.text,
                  );

                  if (user != null) {
                    Get.back();
                    Get.snackbar(
                      "Success".tr,
                      "تم تغيير كلمة المرور بنجاح",
                      backgroundColor: AppColor.green,
                      colorText: AppColor.white,
                    );
                  } else {
                    Get.snackbar(
                      "Error".tr,
                      "فشل تغيير كلمة المرور",
                      backgroundColor: AppColor.red,
                      colorText: AppColor.white,
                    );
                  }
                },
                child: Text("Confirm".tr),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthFacade authFacade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'.tr),
          content: Text('Are you sure you want to logout?'.tr),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
            TextButton(
              onPressed: () async {
                final success = await authFacade.logout();
                if (success) {
                  Get.back();
                  Get.offAllNamed('/login');
                  Get.snackbar(
                    "Success".tr,
                    "تم تسجيل الخروج بنجاح",
                    backgroundColor: AppColor.green,
                    colorText: AppColor.white,
                  );
                } else {
                  Get.snackbar(
                    "Error".tr,
                    "فشل تسجيل الخروج",
                    backgroundColor: AppColor.red,
                    colorText: AppColor.white,
                  );
                }
              },
              child: Text('Logout'.tr, style: TextStyle(color: AppColor.red)),
            ),
          ],
        );
      },
    );
  }
}
