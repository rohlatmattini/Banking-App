
import 'package:get/get.dart';
import '../../patterns/observer/notification_observer.dart';

class InAppNotificationObserver implements NotificationObserver {
  @override
  void onNotify(String title, String message) {
    Get.snackbar(title, message);
  }
}
