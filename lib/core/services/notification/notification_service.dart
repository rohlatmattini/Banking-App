import 'dart:async';

import '../../../data/apis/transaction/transaction_api.dart';
import '../../patterns/observer/email_notification_observer.dart';
import '../../patterns/observer/notification_subject.dart';
import '../../patterns/observer/sms_notification_observer.dart';
import 'in_app_notification_observer.dart';

class NotificationService {
  final NotificationSubject subject = NotificationSubject();
  // final TransactionApi transactionApi = TransactionApi(); // API للوصول للرصيد/المعاملات
  // Timer? _pollingTimer;
  // double _lastBalance = 0;
  //
  //
  // void startPolling() {
  //   _pollingTimer = Timer.periodic(Duration(seconds: 30), (_) async {
  //     await _checkForChanges();
  //   });
  // }
  //
  // void stopPolling() {
  //   _pollingTimer?.cancel();
  // }
  //
  // Future<void> _checkForChanges() async {
  //   final recentTransactions = await transactionApi.getRecentTransactions(token: token);
  //
  //   for (var tx in recentTransactions) {
  //     if (tx.amount > 1000 && !tx.notified) {
  //       subject.notifyObservers(
  //         'Large Transaction Alert',
  //         'A transaction of ${tx.amount} occurred',
  //       );
  //       tx.notified = true;
  //     }
  //   }
  // }


  NotificationService() {
    subject.addObserver(InAppNotificationObserver());
    subject.addObserver(EmailNotificationObserver());
    subject.addObserver(SmsNotificationObserver());
  }

  void notify(String title, String message) {
    subject.notifyObservers(title, message);
  }
}


// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('📩 Background message: ${message.messageId}');
// }
//
// class NotificationService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//   String? fcmToken;
//
//   Future<void> init() async {
//     await _initLocalNotifications();
//     await _requestPermission();
//     await _initToken();
//     _listenForeground();
//     _listenOpenedApp();
//   }
//
//   Future<void> _initLocalNotifications() async {
//     const androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const settings = InitializationSettings(android: androidSettings);
//
//     await _localNotifications.initialize(settings);
//   }
//
//   Future<void> _requestPermission() async {
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future<void> _initToken() async {
//     fcmToken = await _messaging.getToken();
//     debugPrint('🔥 FCM TOKEN--------------: $fcmToken');
//   }
//
//   void _listenForeground() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('📨 Foreground: ${message.notification?.title}');
//       _showLocalNotification(
//         title: message.notification?.title ?? 'إشعار جديد',
//         body: message.notification?.body ?? '',
//       );
//     });
//   }
//
//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'General Notifications',
//       channelDescription: 'App notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const details = NotificationDetails(android: androidDetails);
//
//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       details,
//     );
//   }
//   void _listenOpenedApp() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('🚀 Opened from notification');
//     });
//   }
// }
