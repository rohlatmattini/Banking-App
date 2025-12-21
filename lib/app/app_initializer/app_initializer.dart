import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_links.dart';
import '../../core/localization/my_locale.dart';
import '../../core/patterns/facade/account_facade.dart';
import '../../core/services/notification/notification_service.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../modules/home/controller/home_page_controller.dart';
import '../../modules/payment/controller/payment_controller.dart';
import '../../modules/transactions/controller/transaction_controller.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/notification_binding.dart';



class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized(); // ⚡ مهم جدًا

    await Firebase.initializeApp();
    sharedpref = await SharedPreferences.getInstance();


    Get.put(MyLocaleController());
    // في صفحة main أو عند التنقل للصفحة الرئيسية
    Get.put(PaymentController());
    // Get.lazyPut(() => AccountFacade(
    //     baseUrl: AppLinks.baseUrl,
    //     token: '' // سيتم الحصول عليه ديناميكياً لاحقاً
    // ));
    // Get.put(HomePageController());
    Get.put(TransactionController());

    AuthBinding().dependencies();
    HomeBinding().dependencies();

    // /// Notification
    // FirebaseMessaging.onBackgroundMessage(
    //   firebaseMessagingBackgroundHandler,
    // );
    // NotificationBinding().dependencies();
    // await Get.find<NotificationService>().init();

  }
}


