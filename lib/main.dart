import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app_initializer/app_initializer.dart';
import 'app/routes/routes.dart';
import 'app/routes/routes_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/localization/my_locale.dart';
import 'data/apis/transaction/transaction_api.dart';

SharedPreferences? sharedpref;



void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  // notificationService.startPolling();

  runApp( MyApp(token:token));
}


class MyApp extends StatelessWidget {
final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {


        final MyLocaleController localeController = Get.find();

        return GetMaterialApp(

          debugShowCheckedModeBanner: false,
          getPages: AppPages.pages,
          locale: localeController.currentLocale.value,
          initialRoute: AppRoute.onboarding, // 👈 هون الحل
        );
      },
    );
  }
}
