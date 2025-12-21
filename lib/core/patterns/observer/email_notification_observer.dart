import 'notification_observer.dart';

class EmailNotificationObserver implements NotificationObserver {
  @override
  void onNotify(String title, String message) {
    print('📧 Email Sent: $title - $message');
  }
}
