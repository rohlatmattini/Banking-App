
import 'notification_observer.dart';

class SmsNotificationObserver implements NotificationObserver {
  @override
  void onNotify(String title, String message) {
    print('📱 SMS Sent: $title - $message');
  }
}
